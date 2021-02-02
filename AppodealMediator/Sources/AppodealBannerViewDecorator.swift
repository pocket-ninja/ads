//
//  Copyright © 2020 sroik. All rights reserved.
//

import Appodeal
import UIKit
import PocketAds

final class AppodealBannerViewDecorator: UIView, BannerView {
    weak var delegate: BannerViewDelegate?

    var isReady: Bool {
        return bannerView.isReady
    }

    var sourceViewController: UIViewController? {
        get { return bannerView.rootViewController }
        set { bannerView.rootViewController = newValue }
    }

    var placement: String? {
        get { return bannerView.placement }
        set { bannerView.placement = newValue }
    }

    convenience init(size: CGSize) {
        let bannerView = AppodealBannerView(size: size)
        bannerView.usesSmartSizing = true
        self.init(bannerView: bannerView)
    }

    init(bannerView: APDBannerView) {
        self.bannerView = bannerView
        super.init(frame: bannerView.bounds)
        setup()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(size: .zero)
    }

    func load() {
        bannerView.loadAd()
    }
    
    override func layoutSubviews() {
        bannerView.frame = bounds
    }

    private func setup() {
        bannerView.delegate = self
        addSubview(bannerView)
    }

    private let bannerView: APDBannerView
}

extension AppodealBannerViewDecorator: AppodealBannerViewDelegate {
    public func bannerViewDidLoadAd(_ bannerView: APDBannerView, isPrecache precache: Bool) {
        delegate?.bannerViewLoaded(self)
    }

    public func bannerView(_ bannerView: APDBannerView, didFailToLoadAdWithError error: Error) {
        delegate?.bannerView(self, failedToLoadWithError: error)
    }
}
