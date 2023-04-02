//
//  Double+scale.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.12.2022.
//

import UIKit

extension Double {
    func fontScale() -> CGFloat {
        switch UIDevice.screenType {
        case .h19x428:
            return self
        case .h19x414:
            return self
        case .h19x390:
            return self * 0.88889
        case .h19x375:
            return self * 0.88889
        case .h16x414:
            return self
        case .h16x375:
            return self * 0.88889
        case .unknown:
            return self
        case .h19x430:
            return self
        case .h19x393:
            return self
        }
    }
}

extension Double {
    func removeZerosFromEnd(maxPrecision: Int = 3) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxPrecision
        return String(formatter.string(from: number) ?? "")
    }
}
