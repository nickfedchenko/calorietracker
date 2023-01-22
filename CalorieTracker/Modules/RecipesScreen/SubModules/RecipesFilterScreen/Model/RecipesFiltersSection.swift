//
//  RecipesFiltersSection.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 27.12.2022.
//

import UIKit
enum ExtraSearchTags: CaseIterable {
    case calorie50to100
    case calories100to200
    case calorie200to300
    case calorie300to400
    case calorie400to500
    case calorie500to600
    case calorie600to700
    case calorie700plus
    case lessThan5Ingredients
    case lessThan10Min
    case lessThan20Min
    case lessThan30Min
    
    var localizedTitle: String {
        switch self {
        case .calorie50to100:
            return "50...100"
        case .calories100to200:
            return "100...200"
        case .calorie200to300:
            return "200...300"
        case .calorie300to400:
            return "300...400"
        case .calorie400to500:
            return "400...500"
        case .calorie500to600:
            return "500...600"
        case .calorie600to700:
            return "600...700"
        case .calorie700plus:
            return "700 +"
        case .lessThan5Ingredients:
            return "Less than 5 ingredients".localized
        case .lessThan10Min:
            return "≤ 10 minutes".localized
        case .lessThan20Min:
            return "≤ 20 minutes".localized
        case .lessThan30Min:
            return "≤ 30 minutes".localized
        }
    }
}

enum RecipesFiltersSectionType {
    case filterTags(tags: [AdditionalTag.ConvenientTag])
    case exceptionTags(tags: [ExceptionTag.ConvenientExceptionTag])
    case extraTags(tags: [ExtraSearchTags])
}

struct RecipesFiltersSection {
    var title: String
    var sectionType: RecipesFiltersSectionType
}
