//
//  Copyright © 2020 sroik. All rights reserved.
//

import Appodeal
import UIKit
import PocketAds

public final class AppodealMediator: NSObject, AdsMediator {
    public weak var interstitialDelegate: AdsMediatorInterstitialDelegate?
    public weak var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate?

    public var bannerSize: CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone ? kAppodealUnitSize_320x50 : kAppodealUnitSize_728x90
    }
    
    public init(apiKey: @escaping () -> String) {
        self.apiKey = apiKey
        super.init()
    }

    public func initialize(config: AdsConfig, then completion: @escaping (Bool) -> Void) {
        guard !Appodeal.isInitalized(for: config.adTypes.appodeal) else {
            completion(false)
            return
        }

        Appodeal.setTestingEnabled(config.isTesting)
        Appodeal.setLogLevel(config.isVerbose ? .verbose : .warning)
        Appodeal.setAutocache(false, types: config.adTypes.appodeal)
        Appodeal.setAutocache(true, types: config.autocachedTypes.appodeal)
        Appodeal.initialize(withApiKey: apiKey(), types: config.adTypes.appodeal, hasConsent: true)
        Appodeal.setInterstitialDelegate(self)
        Appodeal.setRewardedVideoDelegate(self)
        completion(true)
    }
    
    public func loadBanner(in controller: UIViewController, for placement: String?) -> BannerView? {
        let bannerView = AppodealBannerViewDecorator(size: bannerSize)
        bannerView.sourceViewController = controller
        bannerView.placement = placement
        return bannerView
    }

    public func isReadyToShowInterstitial(for placement: String) -> Bool {
        return Appodeal.isReadyForShow(with: .interstitial)
    }

    public func showInterstitial(from controller: UIViewController, for placement: String) -> Bool {
        Appodeal.showAd(.interstitial, forPlacement: placement, rootViewController: controller)
    }

    public func loadInterstitial(for placement: String) {
        Appodeal.cacheAd(.interstitial)
    }

    public func isReadyToShowRewardedVideo(for placement: String) -> Bool {
        return Appodeal.isReadyForShow(with: .rewardedVideo)
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) -> Bool {
        Appodeal.showAd(.rewardedVideo, forPlacement: placement, rootViewController: controller)
    }

    public func loadRewardedVideo(for placement: String) {
        Appodeal.cacheAd(.rewardedVideo)
    }

    private let apiKey: () -> String
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

    public func interstitialDidFailToPresent() {
        DispatchQueue.main.async {
            self.interstitialDelegate?.interstitialFailedToPresent()
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

private extension Array where Element == AdType {
    var appodeal: AppodealAdType {
        var type = AppodealAdType()
        forEach { type.insert($0.appodeal) }
        return type
    }
}

private extension AdType {
    var appodeal: AppodealAdType {
        switch self {
        case .banner: return .banner
        case .interstitial: return .interstitial
        case .rewardedVideo: return .rewardedVideo
        }
    }
}
