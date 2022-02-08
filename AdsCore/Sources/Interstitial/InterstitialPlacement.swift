//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public struct InterstitialPlacement: Identifiable {
    public var id: String
    public var allowedLoadingTime: TimeInterval
    public var isEnabled: Bool

    public init(
        id: String,
        allowedLoadingTime: TimeInterval = 5.0,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.allowedLoadingTime = allowedLoadingTime
        self.isEnabled = isEnabled
    }
}
