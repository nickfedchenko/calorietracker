//
//  UIView+roundCorners.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.11.2022.
//

import UIKit

extension CACornerMask {
    public static var allCorners: CACornerMask {
        return [
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner
        ]
    }

    public static var topCorners: CACornerMask {
        return [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
    }

    public static var bottomCorners: CACornerMask {
        return [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
    }
    
    public static var topLeft: CACornerMask {
        return .layerMinXMinYCorner
    }
    
    public static var topRight: CACornerMask {
        return .layerMaxXMinYCorner
    }
    
    public static var bottomLeft: CACornerMask {
        return .layerMinXMaxYCorner
    }
    
    public static var bottomRight: CACornerMask {
        return .layerMaxXMaxYCorner
    }
    
    var rectCorners: UIRectCorner {
        switch self {
        case .allCorners:
            return [.allCorners]
        case .topCorners:
            return [.topLeft, .topRight]
        case .bottomCorners:
            return [.bottomLeft, .bottomRight]
        case .bottomLeft:
            return [.bottomLeft]
        case .bottomRight:
            return [.bottomRight]
        case .topLeft:
            return [.topLeft]
        case .topRight:
            return [.topRight]
        default:
            return []
        }
    }
}
