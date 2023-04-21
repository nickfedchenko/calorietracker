//
//  SectionsModel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 19.04.2023.
//

import UIKit
struct LandingTopSectionModel {
    let titleMainString: String
    let targetWeightString: String
    let targetDateString: String
    let targetsFont: UIFont?
    let commonTextFont: UIFont?
    let textColor: UIColor?
    let descriptionText: String
    let descriptionFont: UIFont?
}

struct CheckmarkSectionModel {
    let headerTitle: String
    let headerTitleFont: UIFont?
    let allTextColor: UIColor?
    let checkMarkTextFont: UIFont?
    let allergicRestrictions: [String]
    let activityLifestyle: String
    let weeklyGoal: String
}

struct CirclesSectionModel {
    let titleString: String
    let titleFont: UIFont?
    let circlesImage: UIImage?
    let kcalGoal: String
    let carbsGoal: String
    let fatsGoal: String
    let proteinGoal: String
    let kcalLabelColor: UIColor?
    let carbsLabelColor: UIColor?
    let proteinLabelColor: UIColor?
    let fatsLabelColor: UIColor?
    let descriptionText: NSAttributedString
}

struct BenefitsSectionModel {
    let headerTitle: String
    let headerFont: UIFont?
    let headerTitleColor: UIColor?
    let titleString: String
    let titleColor: UIColor?
    let titleFont: UIFont?
    let mainImage: UIImage?
}

struct ActivitySectionModel {
    let titleString: String
    let titleFont: UIFont?
    let titleColor: UIColor?
    let mainImage: UIImage?
    let sportsImage: UIImage?
}

struct RecipesSectionModel {
    let titleString: String
    let titleFont: UIFont?
    let titleColor: UIColor?
    let mainImage: UIImage?
}

struct MeasurementsSectionModel {
    let titleString: String
    let titleFont: UIFont?
    let titleColor: UIColor?
    let mainImage: UIImage?
    let weightsImage: UIImage?
}

struct WaterSectionModel {
    let headerTitle: String
    let headerFont: UIFont?
    let headerTitleColor: UIColor?
    let titleString: NSAttributedString
    let mainImage: UIImage?
}

struct ReviewsSectionModel {
    let reviewsImages: [UIImage?]
}

struct FinalSectionModel {
    let titleString: String
    let titleColor: UIColor?
    let titleFont: UIFont?
    let descriptionString: String
    let descriptionColor: UIColor?
    let descriptionFont: UIFont?
}

enum LandingSectionType {
    case topSection(model: LandingTopSectionModel)
    case chartSection(chartSnapshot: UIImage?)
    case checkmarksSection(model: CheckmarkSectionModel)
    case circlesSection(model: CirclesSectionModel)
    case benefitsSection(model: BenefitsSectionModel)
    case activityIntegration(model: ActivitySectionModel)
    case recipesSection(model: RecipesSectionModel)
    case measurementsSection(model: MeasurementsSectionModel)
    case waterSection(model: WaterSectionModel)
    case reviewsSection(model: ReviewsSectionModel)
    case finalSection(model: FinalSectionModel)
}
