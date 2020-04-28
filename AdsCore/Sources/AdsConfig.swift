//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol InterstitialConfig {
    var cooldown: TimeInterval { get }
    var interstitialsPerSession: Int { get }
}

public protocol AdsConfig: InterstitialConfig {
    var isTesting: Bool { get }
    var isVerbose: Bool { get }
}
