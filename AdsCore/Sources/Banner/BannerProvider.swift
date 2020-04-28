//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class BannerProvider {
    public var isEnabled: Bool = false

    public var bannerSize: CGSize {
        return mediator.bannerSize
    }

    public init(mediator: AdsMediator) {
        self.mediator = mediator
    }

    @discardableResult
    public func load(for placement: String? = nil, in controller: UIViewController) -> BannerView? {
        bannerView?.sourceViewController = controller

        let banner = bannerView ?? mediator.loadBanner(in: controller, for: placement)
        if isEnabled {
            banner?.load()
        }

        bannerView = banner
        return banner
    }

    public private(set) var bannerView: BannerView?
    private var mediator: AdsMediator
}
