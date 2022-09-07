//
//  BasicButtonType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

enum BasicButtonType {
    case add
    case save
    case apply
    case custom(CustomType)
}

struct CustomType {
    let image: Image?
    let title: Title?
    let backgroundColorInactive: UIColor?
    let gradientColors: [UIColor?]
    let borderColorInactive: UIColor?
    let borderColorDefault: UIColor?
    
    struct Image {
        let isPressImage: UIImage?
        let defaultImage: UIImage?
        let inactiveImage: UIImage?
    }
    
    struct Title {
        let isPressTitle: String
        let defaultTitle: String
        let isPressTitleColor: UIColor?
        let defaultTitleColor: UIColor?
    }
}
