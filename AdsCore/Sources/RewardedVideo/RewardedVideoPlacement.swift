//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public struct RewardedVideoPlacement {
    public var name: String
    public var allowedLoadingTime: TimeInterval
    
    public init(name: String, allowedLoadingTime: TimeInterval) {
        self.name = name
        self.allowedLoadingTime = allowedLoadingTime
    }
}
