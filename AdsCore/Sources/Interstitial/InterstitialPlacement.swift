//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public struct InterstitialPlacement {
    public var name: String
    public var allowedLoadingTime: TimeInterval
    public var isEnabled: Bool

    public init(
        name: String,
        allowedLoadingTime: TimeInterval = 5.0,
        isEnabled: Bool = true
    ) {
        self.name = name
        self.allowedLoadingTime = allowedLoadingTime
        self.isEnabled = isEnabled
    }
}
