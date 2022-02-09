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

    public func isReadyToShowRewardedVideo() -> Bool {
        return true
    }

    public func canShowRewardedVideo() -> Bool {
        return true
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) -> Bool {
        rewardedVideoDelegate?.rewardedVideoPresented()
        rewardedVideoDelegate?.rewardedVideoWillDismiss()
        rewardedVideoDelegate?.rewardedVideoWatched()
        return true
    }

    public func loadRewardedVideo() {
        rewardedVideoDelegate?.rewardedVideoLoaded()
    }

    public func isReadyToShowInterstitial() -> Bool {
        return true
    }

    public func showInterstitial(from controller: UIViewController, for placement: String)  -> Bool {
        interstitialDelegate?.interstitialPresented()
        interstitialDelegate?.interstitialDismissed()
        return true
    }

    public func loadInterstitial() {
        interstitialDelegate?.interstitialLoaded()
    }
    
    public func loadBanner() -> BannerView {
        MockBannerView()
    }
}

private final class MockBannerView: UIView, BannerView {
    var delegate: BannerViewDelegate?
    var placement: String?
    var sourceViewController: UIViewController?
    func load() {}
    func startAutoRefresh() {}
    func stopAutoRefresh() {}
}
