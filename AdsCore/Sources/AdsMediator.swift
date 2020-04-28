//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol AdsMediatorInterstitialDelegate: AnyObject {
    func interstitialLoaded(isPrecached: Bool)
    func interstitialFailedToLoad()
    func interstitialWillPresent()
    func interstitialDismissed()
    func interstitialDidClick()
}

public protocol AdsMediatorRewardedVideoDelegate: AnyObject {
    func rewardedVideoLoaded()
    func rewardedVideoFailedToLoad()
    func rewardedVideoWillDismiss()
    func rewardedVideoWatched()
    func rewardedVideoFailedToPresent()
    func rewardedVideoPresented()
    func rewardedVideoDidClick()
}

public protocol AdsInterstitialMediator {
    var interstitialDelegate: AdsMediatorInterstitialDelegate? { get set }
    func isReadyToShowInterstitial(for placement: String) -> Bool
    func canShowInterstitial(for placement: String) -> Bool
    func showInterstitial(from controller: UIViewController, for placement: String)
    func loadInterstitial(for placement: String)
}

public protocol AdsRewardedVideoMediator {
    var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate? { get set }
    func isReadyToShowRewardedVideo(for placement: String) -> Bool
    func canShowRewardedVideo(for placement: String) -> Bool
    func showRewardedVideo(from controller: UIViewController, for placement: String)
    func loadRewardedVideo(for placement: String)
}

public protocol AdsBannerMediator {
    var bannerSize: CGSize { get }
    func loadBanner(in controller: UIViewController, for placement: String?) -> BannerView?
}

public protocol AdsMediator: AdsRewardedVideoMediator, AdsInterstitialMediator, AdsBannerMediator {
    @discardableResult
    func initialize(config: AdsConfig) -> Bool
}
