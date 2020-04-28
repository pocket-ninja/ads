//
//  Copyright © 2020 sroik. All rights reserved.
//

import Appodeal
import UIKit
import AdsCore

public final class AppodealMediator: NSObject, AdsMediator {
    public weak var interstitialDelegate: AdsMediatorInterstitialDelegate?
    public weak var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate?

    public init(apiKey: String) {
        self.apiKey = apiKey
        super.init()
    }

    @discardableResult
    public func initialize(config: AdsConfig) -> Bool {
        let adTypes: AppodealAdType = [.rewardedVideo, .interstitial]
        
        guard !Appodeal.isInitalized(for: adTypes) else {
            return false
        }

        Appodeal.setTestingEnabled(config.isTesting)
        Appodeal.setLogLevel(config.isVerbose ? .verbose : .warning)
        Appodeal.setAutocache(false, types: [.rewardedVideo])
        Appodeal.setAutocache(true, types: [.interstitial])
        Appodeal.initialize(withApiKey: apiKey, types: adTypes, hasConsent: true)
        Appodeal.setInterstitialDelegate(self)
        Appodeal.setRewardedVideoDelegate(self)
        return true
    }

    public func isReadyToShowInterstitial(for placement: String) -> Bool {
        return Appodeal.isReadyForShow(with: .interstitial)
    }

    public func canShowInterstitial(for placement: String) -> Bool {
        return Appodeal.canShow(.interstitial, forPlacement: placement)
    }

    public func showInterstitial(from controller: UIViewController, for placement: String) {
        if canShowInterstitial(for: placement) {
            Appodeal.showAd(.interstitial, forPlacement: placement, rootViewController: controller)
        }
    }

    public func loadInterstitial(for placement: String) {
        Appodeal.cacheAd(.interstitial)
    }

    public func isReadyToShowRewardedVideo(for placement: String) -> Bool {
        return Appodeal.isReadyForShow(with: .rewardedVideo)
    }

    public func canShowRewardedVideo(for placement: String) -> Bool {
        return Appodeal.canShow(.rewardedVideo, forPlacement: placement)
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) {
        if canShowRewardedVideo(for: placement) {
            Appodeal.showAd(.rewardedVideo, forPlacement: placement, rootViewController: controller)
        }
    }

    public func loadRewardedVideo(for placement: String) {
        Appodeal.cacheAd(.rewardedVideo)
    }

    private let apiKey: String
}

extension AppodealMediator: AppodealInterstitialDelegate {
    public func interstitialDidLoadAdIsPrecache(_ precache: Bool) {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialLoaded(isPrecached: precache)
        }
    }

    public func interstitialDidFailToLoadAd() {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialFailedToLoad()
        }
    }

    public func interstitialWillPresent() {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialWillPresent()
        }
    }

    public func interstitialDidDismiss() {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialDismissed()
        }
    }

    public func interstitialDidClick() {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialDidClick()
        }
    }
}

extension AppodealMediator: AppodealRewardedVideoDelegate {
    public func rewardedVideoDidLoadAdIsPrecache(_ precache: Bool) {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoLoaded()
        }
    }

    public func rewardedVideoDidFailToLoadAd() {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoFailedToLoad()
        }
    }

    public func rewardedVideoDidFailToPresentWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoFailedToPresent()
        }
    }

    public func rewardedVideoDidPresent() {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoPresented()
        }
    }

    public func rewardedVideoWillDismissAndWasFullyWatched(_ wasFullyWatched: Bool) {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoWillDismiss()
        }
    }

    public func rewardedVideoDidFinish(_ rewardAmount: Float, name rewardName: String?) {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoWatched()
        }
    }

    public func rewardedVideoDidClick() {
        DispatchQueue.main.async {
            self.rewardedVideoDelegate?.rewardedVideoDidClick()
        }
    }
}
