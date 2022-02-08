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
    
    public init() {}

    public func initialize(config: AdsConfig, then completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    public func isReadyToShowRewardedVideo(for placement: String) -> Bool {
        return true
    }

    public func canShowRewardedVideo(for placement: String) -> Bool {
        return true
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) -> Bool {
        rewardedVideoDelegate?.rewardedVideoPresented()
        rewardedVideoDelegate?.rewardedVideoWillDismiss()
        rewardedVideoDelegate?.rewardedVideoWatched()
        return true
    }

    public func loadRewardedVideo(for placement: String) {
        rewardedVideoDelegate?.rewardedVideoLoaded()
    }

    public func isReadyToShowInterstitial(for placement: String) -> Bool {
        return true
    }

    public func showInterstitial(from controller: UIViewController, for placement: String)  -> Bool {
        interstitialDelegate?.interstitialWillPresent()
        interstitialDelegate?.interstitialDismissed()
        return true
    }

    public func loadInterstitial(for placement: String) {
        interstitialDelegate?.interstitialLoaded(isPrecached: false)
    }
    
    public func loadBanner(in controller: UIViewController, for placement: String?) -> BannerView? {
        return nil
    }
}
