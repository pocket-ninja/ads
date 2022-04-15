//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import Combine

final class AdsTimer {
    @Published private(set) var cooldowns: Bool = false

    func limitedLoad(allowedTime: TimeInterval, then block: @escaping () -> Void) {
        loadingTimer = Timer(interval: allowedTime) { _ in block() }
        loadingTimer?.start()
    }
    
    func cooldown(for duration: TimeInterval) {
        if cooldowns {
            return
        }
        
        cooldowns = true
        cooldownTimer = Timer(interval: duration) { [weak self] _ in self?.cooldowns = false }
        cooldownTimer?.start()
    }
    
    func invalidateLoading() {
        loadingTimer?.invalidate()
        loadingTimer = nil
    }
    
    private var loadingTimer: Timer?
    private var cooldownTimer: Timer?
}

private extension Timer {
    convenience init(interval: TimeInterval, block: @escaping (Timer) -> Void) {
        self.init(timeInterval: interval, repeats: false, block: block)
    }

    func start() {
        RunLoop.main.add(self, forMode: .default)
    }
}
