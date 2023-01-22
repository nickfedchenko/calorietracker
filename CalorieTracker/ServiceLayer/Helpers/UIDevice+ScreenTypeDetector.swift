//
//  ScreenTypeDetector.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 18.07.2022.
//

import UIKit

extension UIDevice {
    enum ScreenType {
        case h19x430
        case h19x428
        case h19x414
        case h19x393
        case h19x390
        case h19x375
        case h16x414
        case h16x375
        case unknown
    }
    
    static var screenType: ScreenType {
        switch (UIScreen.main.bounds.width, UIScreen.main.bounds.height) {
        case (414, 896):
            return .h19x414
        case (428, 926):
            return .h19x428
        case (375, 812):
            return .h19x375
        case (390, 844):
            return .h19x390
        case (414, 736):
            return .h16x414
        case (375, 667):
            return .h16x375
        case  (430, 932):
            return .h19x430
        case (393, 852):
            return .h19x393
        default:
            return .unknown
        }
    }
}
