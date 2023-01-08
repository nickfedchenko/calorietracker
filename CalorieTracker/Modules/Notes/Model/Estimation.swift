//
//  Estimation.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

enum Estimation: Int {
    case verySad = 0
    case sad = 1
    case normal = 2
    case good = 3
    case veryGood = 4
    
    func getEstimationSmile() -> UIImage? {
        switch self {
        case .verySad:
            return R.image.notes.smileVerySad()
        case .sad:
            return R.image.notes.smileSad()
        case .normal:
            return R.image.notes.smileNeutral()
        case .good:
            return R.image.notes.smileGood()
        case .veryGood:
            return R.image.notes.smileVeryGood()
        }
    }
}
