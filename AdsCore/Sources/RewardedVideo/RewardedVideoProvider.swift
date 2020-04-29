//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class RewardedVideoProvider {
    public enum State: Equatable {
        case unknown
        case loading
        case loaded
        case presented(isWatched: Bool)
    }
    
    public enum Result: String, Equatable {
        case watched
        case closed
        case cancelled
        case timeout
        case failedToLoad
        case failedToPresent
    }
    
    public typealias LoadingCompletion = (Bool) -> Void
    public typealias Completion = (Result) -> Void
    
    var isEnabled: Bool = false
    
    init(config: AdsConfig, mediator: AdsMediator) {
        self.config = config
        self.mediator = mediator
    }
    
    public func setup() {
        mediator.rewardedVideoDelegate = self
    }
    
    @discardableResult
    public func cancel() -> Bool {
        return cancel(result: .cancelled)
    }
    
    public func preload(for placement: RewardedVideoPlacement) {
        if isEnabled, state == .unknown {
            mediator.loadRewardedVideo(for: placement.name)
        }
    }
    
    @discardableResult
    public func provide(
        for placement: RewardedVideoPlacement,
        from controller: UIViewController,
        then completion: @escaping Completion
    ) -> Bool {
        guard isEnabled else {
            return false
        }
        
        cancel()
        self.completion = completion
        
        load(for: placement) { [weak self, weak controller] success in
            if success, let controller = controller {
                self?.showLoadedVideo(for: placement.name, from: controller)
            }
        }
        
        return true
    }
    
    private func showLoadedVideo(for placement: String, from controller: UIViewController) {
        guard canPresent() else {
            finish(result: .failedToPresent)
            return
        }
        
        state = .presented(isWatched: false)
        mediator.showRewardedVideo(from: controller, for: placement)
    }
    
    private func load(for placement: RewardedVideoPlacement, then callback: @escaping LoadingCompletion) {
        load(for: placement.name) { [weak self] success in
            self?.timer.invalidateLoading()
            success ? callback(true) : self?.finish(result: .failedToLoad)
        }

        timer.limitedLoad(allowedTime: placement.allowedLoadingTime) { [weak self] in
            if self?.cancel(result: .timeout) == true {
                callback(false)
            }
        }
    }

    private func load(for placement: String, then callback: @escaping LoadingCompletion) {
        if mediator.isReadyToShowRewardedVideo(for: placement) {
            callback(true)
            return
        }

        state = .loading
        loadingCompletion = callback
        mediator.loadRewardedVideo(for: placement)
    }
    
    private func canPresent() -> Bool {
        guard isEnabled else {
            return false
        }
        
        switch state {
        case .presented: return false
        default: return UIApplication.shared.applicationState == .active
        }
    }
    
    @discardableResult
    private func cancel(result: Result) -> Bool {
        if case .presented = state {
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

extension RewardedVideoProvider: AdsMediatorRewardedVideoDelegate {
    public func rewardedVideoLoaded() {
        log("rewarded video loaded")
        
        if case .loading = state {
            state = .loaded
            finishLoading(success: true)
        }
    }
    
    public func rewardedVideoFailedToLoad() {
        log("rewarded video failed to load")
        
        if case .loading = state {
            state = .unknown
            finishLoading(success: false)
        }
    }
    
    public func rewardedVideoWillDismiss() {
        log("rewarded video will dismiss")
        
        if case let .presented(isWatched) = state {
            finish(result: isWatched ? .watched : .closed)
            state = .unknown
        }
    }
    
    public func rewardedVideoWatched() {
        log("rewarded video watched")

        if case .presented = state {
            state = .presented(isWatched: true)
        }
    }
    
    public func rewardedVideoFailedToPresent() {
        log("rewarded video failed to present")
        
        if case .presented = state {
            finish(result: .failedToPresent)
            state = .unknown
        }
    }
    
    public func rewardedVideoPresented() {
        log("rewarded video presented")
    }
    
    public func rewardedVideoDidClick() {
        log("rewarded video clicked")
    }
}
