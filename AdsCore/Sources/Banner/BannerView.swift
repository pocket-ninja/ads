//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol BannerViewDelegate: AnyObject {
    func bannerViewLoaded(_ view: BannerView)
    func bannerView(_ view: BannerView, failedToLoadWithError message: String)
}

public protocol BannerView: UIView {
    var delegate: BannerViewDelegate? { get set }
    var sourceViewController: UIViewController? { get set }
    func load()
}
