//
//  Copyright © 2020 sroik. All rights reserved.
//

import Appodeal
import UIKit
import PocketAds

final class AppodealBannerViewDecorator: UIView, BannerView {
    weak var delegate: BannerViewDelegate?

    var sourceViewController: UIViewController? {
        get {
            return bannerView.rootViewController
        }
        set {
            bannerView.rootViewController = newValue
        }
    }

    convenience init(size: CGSize, placement: String) {
        let bannerView = AppodealBannerView(size: size)
        bannerView.usesSmartSizing = true
        bannerView.placement = placement
        self.init(bannerView: bannerView)
    }

    init(bannerView: APDBannerView) {
        self.bannerView = bannerView
        super.init(frame: bannerView.bounds)
        setup()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(size: .zero, placement: "")
    }

    func load() {
        bannerView.loadAd()
    }

    private func setup() {
        addSubview(bannerView)
        bannerView.delegate = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalTo: widthAnchor),
            bannerView.heightAnchor.constraint(equalTo: heightAnchor),
            bannerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private let bannerView: APDBannerView
}

extension AppodealBannerViewDecorator: AppodealBannerViewDelegate {
    public func bannerViewDidLoadAd(_ bannerView: APDBannerView, isPrecache precache: Bool) {
        delegate?.bannerViewLoaded(self)
    }

    public func bannerView(_ bannerView: APDBannerView, didFailToLoadAdWithError error: Error) {
        delegate?.bannerView(self, failedToLoadWithError: error.localizedDescription)
    }
}
