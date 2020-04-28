//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public class MockAdsMediator: AdsMediator {
    
    weak public var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate?
    weak public var interstitialDelegate: AdsMediatorInterstitialDelegate?

    public var bannerSize: CGSize {
        return CGSize(width: 320, height: 50)
    }

    @discardableResult
    public func initialize(config: AdsConfig) -> Bool {
        return true
    }

    public func isReadyToShowRewardedVideo(for placement: String) -> Bool {
        return true
    }

    public func canShowRewardedVideo(for placement: String) -> Bool {
        return true
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) {
        rewardedVideoDelegate?.rewardedVideoPresented()
        rewardedVideoDelegate?.rewardedVideoWillDismiss()
        rewardedVideoDelegate?.rewardedVideoWatched()
    }

    public func loadRewardedVideo(for placement: String) {
        rewardedVideoDelegate?.rewardedVideoLoaded()
    }

    public func isReadyToShowInterstitial(for placement: String) -> Bool {
        return true
    }

    public func canShowInterstitial(for placement: String) -> Bool {
        return true
    }

    public func showInterstitial(from controller: UIViewController, for placement: String) {
        interstitialDelegate?.interstitialWillPresent()
        interstitialDelegate?.interstitialDismissed()
    }

    public func loadInterstitial(for placement: String) {
        interstitialDelegate?.interstitialLoaded(isPrecached: false)
    }
    
    public func loadBanner(in controller: UIViewController, for placement: String?) -> BannerView? {
        return nil
    }
}
