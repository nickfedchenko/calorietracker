//
//  Int+AspectCorection.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.01.2023.
//

import UIKit

extension Int {
    private var referenceSize: (width: CGFloat, height: CGFloat) { (414, 896) }
    private var screenSize: CGSize { UIScreen.main.bounds.size }
    
    var fit: CGFloat {
        var ratio: CGFloat = 1
        if screenSize.height > referenceSize.height {
            ratio = screenSize.height / referenceSize.height
        }
        return CGFloat(self) * ratio
    }
    
    var fitY: CGFloat {
        var ratio: CGFloat = 1
        if screenSize.height >= referenceSize.height {
            ratio = screenSize.height / referenceSize.height
        } else {
            ratio = screenSize.height / referenceSize.height / 1.15
        }
        return CGFloat(self) * ratio
    }
    
    var fitW: CGFloat {
        let ratio = screenSize.width / referenceSize.width
        return CGFloat(self) * ratio
    }
    
    var fitH: CGFloat {
        let ratio = screenSize.height / referenceSize.height
        return CGFloat(self) * ratio
    }
    
    var fitWMore: CGFloat {
        let ratio = screenSize.width / referenceSize.width
        return ratio > 1 ? CGFloat(self) * ratio : CGFloat(self)
    }
}
