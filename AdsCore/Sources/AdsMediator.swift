//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol AdsMediatorInterstitialDelegate: AnyObject {
    func interstitialLoaded()
    func interstitialFailedToLoad()
    func interstitialFailedToPresent()
    func interstitialPresented()
    func interstitialDismissed()
    func interstitialDidClick()
}

public protocol AdsMediatorRewardedVideoDelegate: AnyObject {
    func rewardedVideoLoaded()
    func rewardedVideoFailedToLoad()
    func rewardedVideoDismissed()
    func rewardedVideoWatched()
    func rewardedVideoFailedToPresent()
    func rewardedVideoPresented()
    func rewardedVideoDidClick()
}

public protocol AdsInterstitialMediator {
    var interstitialDelegate: AdsMediatorInterstitialDelegate? { get set }
    func isReadyToShowInterstitial() -> Bool
    func showInterstitial(from controller: UIViewController, for placement: String) -> Bool
    func loadInterstitial()
}

public protocol AdsRewardedVideoMediator {
    var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate? { get set }
    func isReadyToShowRewardedVideo() -> Bool
    func showRewardedVideo(from controller: UIViewController, for placement: String) -> Bool
    func loadRewardedVideo()
}

public protocol AdsBannerMediator {
    var bannerSize: CGSize { get }
    func loadBanner() -> BannerView
}

public protocol AdsMediator: AdsRewardedVideoMediator, AdsInterstitialMediator, AdsBannerMediator {
    func initialize(config: AdsConfig, then completion: @escaping (Bool) -> Void)
}
