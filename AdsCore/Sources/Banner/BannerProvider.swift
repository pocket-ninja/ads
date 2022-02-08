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
    public func load(in controller: UIViewController) -> BannerView? {
        return load(for: "default", in: controller)
    }
    
    @discardableResult
    public func load(for placement: String, in controller: UIViewController) -> BannerView? {

        let banner = bannerView ?? mediator.loadBanner()
        banner.placement = placement
        banner.sourceViewController = controller
        if isEnabled {
            banner.load()
        }

        bannerView = banner
        return banner
    }

    public private(set) var bannerView: BannerView?
    private var mediator: AdsMediator
}
