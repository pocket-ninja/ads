//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public enum AdType {
    case banner
    case interstitial
    case rewardedVideo
}

public protocol InterstitialConfig {
    var cooldown: TimeInterval { get }
    var interstitialsPerSession: Int { get }
}

public protocol AdsConfig: InterstitialConfig {
    var isTesting: Bool { get }
    var isVerbose: Bool { get }
    
    var adTypes: [AdType] { get }
    var autocachedTypes: [AdType] { get }
}

