//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class InterstitialProvider {
    public enum State: Equatable {
        case unknown
        case loading
        case loaded(precached: Bool)
        case presented
    }
    
    public enum Result: String, Equatable {
        case failedToLoad
        case cancelled
        case timeout
        case watched
    }
    
    public typealias LoadingCompletion = (Bool) -> Void
    public typealias Completion = (Result) -> Void
    
    public var isEnabled: Bool = false
    
    public init(config: AdsConfig, mediator: AdsMediator) {
        self.config = config
        self.mediator = mediator
    }
    
    public func setup() {
        mediator.interstitialDelegate = self
    }
    
    public func cooldown() {
        timer.cooldown(for: config.cooldown)
    }
    
    public func invalidate() {
        timer.invalidate()
    }
    
    public func preload(for placement: InterstitialPlacement) {
        if isEnabled, state == .unknown {
            mediator.loadInterstitial(for: placement.name)
        }
    }
    
    public func canProvide() -> Bool {
        guard isEnabled else {
            return false
        }

        guard config.interstitialsPerSession > timer.cooldowns else {
            log("max interstitials count reached")
            return false
        }

        guard !timer.onCooldown else {
            log("interstitial is on cooldown")
            return false
        }

        guard state != .presented else {
            log("interstitial is already presented")
            return false
        }

        return true
    }
    
    @discardableResult
    public func provide(
        for placement: InterstitialPlacement,
        from controller: UIViewController,
        then completion: Completion? = nil
    ) -> Bool {
        guard canProvide(), placement.isEnabled else {
            return false
        }
         
        cancel(result: .cancelled)
        self.completion = completion
        
        load(for: placement) { [weak self, weak controller] success in
            if success, let controller = controller {
                self?.showLoadedInterstitial(for: placement.name, from: controller)
            }
        }

        return true
    }
    
    private func showLoadedInterstitial(for placement: String, from controller: UIViewController) {
        if canProvide(), mediator.canShowInterstitial(for: placement) {
            mediator.showInterstitial(from: controller, for: placement)
        }
    }
    
    private func load(for placement: InterstitialPlacement, then callback: @escaping LoadingCompletion) {
        timer.limitedLoad(allowedTime: placement.allowedLoadingTime) { [weak self] in
            if self?.cancel(result: .timeout) == true {
                callback(false)
            }
        }

        load(for: placement.name) { [weak self] success in
            self?.timer.invalidateLoading()
            success ? callback(true) : self?.finish(result: .failedToLoad)
        }
    }

    private func load(for placement: String, then callback: @escaping LoadingCompletion) {
        if mediator.isReadyToShowInterstitial(for: placement) {
            callback(true)
            return
        }

        state = .loading
        loadingCompletion = callback
        mediator.loadInterstitial(for: placement)
    }
    
    @discardableResult
    private func cancel(result: Result) -> Bool {
        if state == .presented {
            return false
        }

        state = .unknown
        finish(result: result)
        return true
    }
    
    private func finish(result: Result) {
        completion?(result)
        completion = nil
    }
    
    private func finishLoading(success: Bool) {
        loadingCompletion?(success)
        loadingCompletion = nil
    }
    
    private func log(_ message: String) {
        if config.isVerbose {
            print(message)
        }
    }
    
    private var loadingCompletion: LoadingCompletion?
    private var completion: Completion?
    
    private let timer = AdsTimer()
    private let config: AdsConfig
    private var mediator: AdsMediator
    public private(set) var state: State = .unknown
}

extension InterstitialProvider: AdsMediatorInterstitialDelegate {
    public func interstitialLoaded(isPrecached: Bool) {
        log("interstitial did load, is precached: \(isPrecached)")
        
        if case .loading = state {
            state = .loaded(precached: isPrecached)
            finishLoading(success: true)
        }
    }
    
    public func interstitialFailedToLoad() {
        log("interstitial failed to load")
        
        if case .loading = state {
            state = .unknown
            finishLoading(success: false)
        }
    }
    
    public func interstitialWillPresent() {
        log("interstitial will present")
        state = .presented
    }
    
    public func interstitialDismissed() {
        log("interstitial dismissed")
        state = .unknown
        cooldown()
        finish(result: .watched)
    }
    
    public func interstitialDidClick() {
        log("interstitial tapped")
    }
}
