//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

final class AdsTimer {
    
    var onCooldown: Bool = false
    var cooldowns: Int = 0

    func limitedLoad(allowedTime: TimeInterval, then block: @escaping () -> Void) {
        loadingTimer = Timer(interval: allowedTime) { _ in block() }
        loadingTimer?.start()
    }
    
    func cooldown(for duration: TimeInterval) {
        if onCooldown {
            return
        }
        
        cooldowns += 1
        onCooldown = true
        cooldownTimer = Timer(interval: duration) { [weak self] _ in self?.onCooldown = false }
        cooldownTimer?.start()
    }
    
    func invalidate() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        onCooldown = false
        cooldowns = 0
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
