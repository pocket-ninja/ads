//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class AdsService {
    public let rewardedVideo: RewardedVideoProvider
    public let interstitial: InterstitialProvider
    public let banner: BannerProvider
    public var sourceViewController = UIViewController()
    
    public var isEnabled: Bool = false {
        didSet {
            interstitial.isEnabled = isEnabled
            rewardedVideo.isEnabled = isEnabled
        }
    }
        
    public init(config: AdsConfig, mediator: AdsMediator) {
        self.config = config
        self.mediator = mediator
        self.interstitial = InterstitialProvider(config: config, mediator: mediator)
        self.rewardedVideo = RewardedVideoProvider(config: config, mediator: mediator)
        self.banner = BannerProvider(mediator: mediator)
    }
    
    public func initialize(then completion: @escaping (Bool) -> Void = { _ in}) {
        mediator.initialize(config: config, then: completion)
        interstitial.setup()
        rewardedVideo.setup()
    }
    
    private let config: AdsConfig
    private let mediator: AdsMediator
}
