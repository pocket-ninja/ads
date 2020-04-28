//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class AdsService {
    public let rewardedVideo: RewardedVideoProvider
    public let interstitial: InterstitialProvider
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
    }
    
    public func initialize() {
        mediator.initialize(config: config)
        interstitial.setup()
        rewardedVideo.setup()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func appDidEnterBackground() {
        interstitial.invalidate()
    }
    
    private let config: AdsConfig
    private let mediator: AdsMediator
}
