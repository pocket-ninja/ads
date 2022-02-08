//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public struct RewardedVideoPlacement {
    public var id: String
    public var allowedLoadingTime: TimeInterval
    
    public init(id: String, allowedLoadingTime: TimeInterval) {
        self.id = id
        self.allowedLoadingTime = allowedLoadingTime
    }
}
