//
//  Copyright © 2023 sroik. All rights reserved.
//

import AppLovinSDK
import PocketAds
import UIKit

public struct ApplovinAdUnits {
    public var inter: String
    public var banner: String
    public var rewarded: String
    
    public init(inter: String, banner: String, rewarded: String) {
        self.inter = inter
        self.banner = banner
        self.rewarded = rewarded
    }
}

public final class ApplovinMediator: NSObject, AdsMediator {
    private lazy var rewarded = ApplovinRewardedAdDecorator(adUnitID: adUnits.rewarded)
    private lazy var interstitial = ApplovinInterstitialAdDecorator(adUnitID: adUnits.inter)
    private let adUnits: ApplovinAdUnits
    
    public var interstitialDelegate: AdsMediatorInterstitialDelegate? {
        didSet {
            interstitial.delegate = interstitialDelegate
        }
    }

    public var rewardedVideoDelegate: AdsMediatorRewardedVideoDelegate? {
        didSet {
            rewarded.delegate = rewardedVideoDelegate
        }
    }

    public var bannerSize: CGSize {
        UIDevice.current.userInterfaceIdiom == .phone ?
            CGSize(width: 320, height: 50) :
            CGSize(width: 728, height: 90)
    }

    public init(adUnits: ApplovinAdUnits) {
        self.adUnits = adUnits
        super.init()
    }
    
    public func initialize(
        config: AdsConfig,
        then completion: @escaping (Bool) -> Void
    ) {
        guard let sdk = ALSdk.shared() else {
            completion(false)
            return
        }

        ALPrivacySettings.setHasUserConsent(true)
        rewarded.verbose = config.isVerbose
        sdk.mediationProvider = ALMediationProviderMAX
        sdk.settings.isVerboseLoggingEnabled = config.isVerbose
        sdk.initializeSdk { configuration in
            completion(true)
        }
    }

    public func loadBanner() -> BannerView {
        ApplovinBannerDecorator(adUnitId: adUnits.banner)
    }

    public func isReadyToShowInterstitial() -> Bool {
        interstitial.ad.isReady
    }

    public func showInterstitial(from controller: UIViewController, for placement: String) -> Bool {
        interstitial.ad.show(forPlacement: placement)
        return true
    }

    public func loadInterstitial() {
        interstitial.ad.load()
    }

    public func isReadyToShowRewardedVideo() -> Bool {
        rewarded.ad.isReady
    }

    public func showRewardedVideo(from controller: UIViewController, for placement: String) -> Bool {
        rewarded.ad.show(forPlacement: placement)
        return true
    }

    public func loadRewardedVideo() {
        rewarded.ad.load()
    }
}

// MARK: Interstitial

private final class ApplovinInterstitialAdDecorator: NSObject, MAAdDelegate {
    weak var delegate: AdsMediatorInterstitialDelegate?
    let ad: MAInterstitialAd
    var retryAttempts: Int = 0

    init(adUnitID: String) {
        ad = MAInterstitialAd(adUnitIdentifier: adUnitID)
        super.init()
        ad.delegate = self
    }

    func didLoad(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.interstitialLoaded()
        }

        retryAttempts = 0
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        DispatchQueue.main.async {
            self.delegate?.interstitialFailedToLoad()
        }

        retryAttempts += 1
        let delay: Double = pow(2.0, min(6, Double(retryAttempts)))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.ad.load()
        }
    }

    func didDisplay(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.interstitialPresented()
        }
    }

    func didHide(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.interstitialDismissed()
            self.ad.load()
        }
    }

    func didClick(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.interstitialDidClick()
        }
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        DispatchQueue.main.async {
            self.delegate?.interstitialFailedToPresent()
            self.ad.load()
        }
    }
}

// MARK: Rewarded

private final class ApplovinRewardedAdDecorator: NSObject, MARewardedAdDelegate {
    weak var delegate: AdsMediatorRewardedVideoDelegate?
    let ad: MARewardedAd
    var verbose: Bool = false

    init(adUnitID: String) {
        ad = MARewardedAd.shared(withAdUnitIdentifier: adUnitID)
        super.init()
        ad.delegate = self
    }

    private func log(_ message: String) {
        if verbose {
            print(message)
        }
    }

    func didStartRewardedVideo(for ad: MAAd) {
        log("[Applovin Mediator] did start rewarded")
    }

    func didCompleteRewardedVideo(for ad: MAAd) {
        log("[Applovin Mediator] did complete rewarded")
    }

    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        log("[Applovin Mediator] did reward user")

        DispatchQueue.main.async {
            self.delegate?.rewardedVideoWatched()
        }
    }

    func didLoad(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.rewardedVideoLoaded()
        }
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        DispatchQueue.main.async {
            self.delegate?.rewardedVideoFailedToLoad()
        }
    }

    func didDisplay(_ ad: MAAd) {
        log("[Applovin Mediator] did display ad")

        DispatchQueue.main.async {
            self.delegate?.rewardedVideoPresented()
        }
    }

    func didHide(_ ad: MAAd) {
        log("[Applovin Mediator] did hide ad")

        DispatchQueue.main.async {
            self.delegate?.rewardedVideoDismissed()
        }
    }

    func didClick(_ ad: MAAd) {
        DispatchQueue.main.async {
            self.delegate?.rewardedVideoDidClick()
        }
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        DispatchQueue.main.async {
            self.delegate?.rewardedVideoFailedToPresent()
        }
    }
}

// MARK: Banner

final class ApplovinBannerDecorator: UIView, BannerView {
    weak var delegate: BannerViewDelegate?
    var sourceViewController: UIViewController?

    var placement: String? {
        get {
            adView.placement
        }
        set {
            adView.placement = newValue
        }
    }

    convenience init(adUnitId: String) {
        let adView = MAAdView(adUnitIdentifier: adUnitId)
        self.init(adView: adView)
    }

    init(adView: MAAdView) {
        self.adView = adView
        super.init(frame: adView.bounds)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func load() {
        adView.loadAd()
    }

    func startAutoRefresh() {
        adView.startAutoRefresh()
    }

    func stopAutoRefresh() {
        adView.stopAutoRefresh()
    }

    private func setup() {
        addSubview(adView)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.widthAnchor.constraint(equalTo: widthAnchor),
            adView.heightAnchor.constraint(equalTo: heightAnchor),
            adView.centerXAnchor.constraint(equalTo: centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private let adView: MAAdView
}

extension ApplovinBannerDecorator: MAAdViewAdDelegate {
    func didExpand(_ ad: MAAd) {}
    func didCollapse(_ ad: MAAd) {}
    func didDisplay(_ ad: MAAd) {}
    func didHide(_ ad: MAAd) {}
    func didClick(_ ad: MAAd) {}
    func didFail(toDisplay ad: MAAd, withError error: MAError) {}

    func didLoad(_ ad: MAAd) {
        delegate?.bannerViewLoaded(self)
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        delegate?.bannerView(self, failedToLoadWithError: error.message)
    }
}
