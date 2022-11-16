//
//  NutritionFactsCellVM.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

struct NutritionFactsCellVM {
    let title: String
    let subtitle: String?
    let font: CellFont
    let cellWidth: CellWidth
    let separatorLineHeight: SeparatorLineHeight
    
    enum CellWidth: CGFloat {
        case large = 1.0
        case average = 0.95
        case small = 0.9
    }
    
    enum SeparatorLineHeight: CGFloat {
        case large = 8.0
        case average = 4.0
        case small = 2.0
        case none = 0.0
    }
    
    enum CellFont {
        case large
        case average
        case small
        
        var rawValue: UIFont {
            switch self {
            case .large :
                return R.font.sfProDisplayHeavy(size: 18)!
            case .average :
                return R.font.sfProDisplaySemibold(size: 18)!
            case .small :
                return R.font.sfProTextRegular(size: 16)!
            }
        }
    }
  
}
