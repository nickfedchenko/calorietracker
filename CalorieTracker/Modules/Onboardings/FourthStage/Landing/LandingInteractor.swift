//
//  LandingInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol LandingInteractorInterface: AnyObject {
    func makeSectionsModel() -> [LandingSectionType]
}

class LandingInteractor {
    weak var presenter: LandingPresenterInterface?
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension LandingInteractor: LandingInteractorInterface {
    // MARK: - all sections model
    
    func makeSectionsModel() -> [LandingSectionType] {
        return [
            .topSection(model: makeTopSectionModel()),
            .chartSection(chartSnapshot: makeChartSectionImage()),
            .checkmarksSection(model: makeCheckmarksSectionModel()),
            .circlesSection(model: makeCirclesModel()),
            .benefitsSection(model: makeBenefitsSectionModel()),
            .activityIntegration(model: makeActivitySection()),
            .recipesSection(model: makeRecipesSection()),
            .measurementsSection(model: makeMeasurementsSection()),
            .waterSection(model: makeWaterSection()),
            .reviewsSection(model: makeReviewsSection()),
            .finalSection(model: makeFinalSectionModel())
        ]
    }
    
    // MARK: - Top section model making
    private func makeTopSectionModel() -> LandingTopSectionModel {
        let targetDate = UDM.reachTargetDate
        let targetWeight = UDM.weightGoal ?? 50
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = Locale.current.languageCode == "ru" ? "MMMM dd" : "MMMM dd"
        let dateString = formatter.string(from: targetDate)
        let targetWeightString = BAMeasurement(targetWeight, .weight).string(with: 0)
        let model: LandingTopSectionModel = .init(
            titleMainString: R.string.localizable.landingTopSectionTitleMainText(),
            targetWeightString: targetWeightString,
            targetDateString: dateString,
            targetsFont: R.font.sfProDisplayHeavy(size: 32),
            commonTextFont: R.font.sfCompactDisplayMedium(size: 32),
            textColor: .white,
            descriptionText: R.string.localizable.landingTopSectionDescription(),
            descriptionFont: R.font.sfProDisplaySemibold(size: 24)
        )
        return model
    }
    
    // MARK: - Chart section model making
    private func makeChartSectionImage() -> UIImage? {
        loadChartImage(fileName: "chartImage.png")
    }
    
    private func loadChartImage(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    // MARK: - Checkmarks section model making
    private func makeCheckmarksSectionModel() -> CheckmarkSectionModel {
        let model = CheckmarkSectionModel(
            headerTitle: R.string.localizable.landingCheckmarksSectionTitle(),
            headerTitleFont: R.font.sfProDisplayBold(size: 32),
            allTextColor: R.color.grayBasicDark(),
            checkMarkTextFont: R.font.sfCompactDisplayMedium(size: 18),
            allergicRestrictions: UDM.restrictions.compactMap { $0.description },
            activityLifestyle: UDM.activityLevel?.getTitle(.long) ?? "moderate",
            weeklyGoal: BAMeasurement(UDM.weeklyGoal ?? 0.1, .weight).string(with: 2)
        )
        return model
    }
    
    private func makeCirclesModel() -> CirclesSectionModel {
     
        let nutritionGoals = FDS.shared.getNutritionGoals()
        let kcalGoal = BAMeasurement(nutritionGoals?.kcal ?? 1000, .energy).string(with: 0).uppercased()
        let carbsGoalString = BAMeasurement(nutritionGoals?.carbs ?? 100, .serving)
            .string(with: 0)
            .trimmingCharacters(in: .letters)
        let carbsGoalStringPrepared = carbsGoalString + " \(R.string.localizable.carbsShort().uppercased())"
        let fatsGoalString = BAMeasurement(nutritionGoals?.fat ?? 100, .serving)
            .string(with: 0)
            .trimmingCharacters(in: .letters)
        let fatsGoalStringPrepared = fatsGoalString + " \(R.string.localizable.fatShort().uppercased())"
        let proteinGoalString = BAMeasurement(nutritionGoals?.protein ?? 100, .serving)
            .string(with: 0)
            .trimmingCharacters(in: .letters)
        let proteinGoalStringPrepared = proteinGoalString + " \(R.string.localizable.proteinShort().uppercased())"
        let descriptionPlainText = R.string.localizable.landingCirclesSectionDescription()
        let mockLabel = UILabel()
        let font = R.font.sfProDisplayRegular(size: 18)
        let attrString = NSAttributedString(
            string: descriptionPlainText,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.white
            ]
        )
        mockLabel.attributedText = attrString
        
        mockLabel.changeFontFor(
            textPart: R.string.localizable.landingCirclesSectionDescriptionFontPart(),
            font: R.font.sfProDisplaySemibold(size: 18)
        )
        
        let model = CirclesSectionModel(
            titleString: R.string.localizable.landingCirclesSectionTitle(),
            titleFont: R.font.sfProDisplayBold(size: 32),
            circlesImage: R.image.landing.circlesSection.circlesImage(),
            kcalGoal: kcalGoal,
            carbsGoal: carbsGoalStringPrepared,
            fatsGoal: fatsGoalStringPrepared,
            proteinGoal: proteinGoalStringPrepared,
            kcalLabelColor: UIColor(hex: "FF9877"),
            carbsLabelColor: UIColor(hex: "FFE769"),
            proteinLabelColor: UIColor(hex: "4BFF52"),
            fatsLabelColor: UIColor(hex: "4BE9FF"),
            descriptionText: mockLabel.attributedText ?? NSAttributedString(string: "")
        )
        return model
    }
    
    private func makeBenefitsSectionModel() -> BenefitsSectionModel {
        let model = BenefitsSectionModel(
            headerTitle: R.string.localizable.landingBenefitsSectionHeaderTitle(),
            headerFont: R.font.sfProDisplayBold(size: 32),
            headerTitleColor: .black,
            titleString: R.string.localizable.landingBenefitsSectionTitle(),
            titleColor: UIColor(hex: "262E2C"),
            titleFont: R.font.sfProDisplayBold(size: 24),
            mainImage: R.image.landing.benefitsSection.mainImage()
        )
        return model
    }
    
    private func makeActivitySection() -> ActivitySectionModel {
        let model = ActivitySectionModel(
            titleString: R.string.localizable.landingActivitySectionTitle(),
            titleFont: R.font.sfProDisplayBold(size: 24),
            titleColor: UIColor(hex: "262E2C"),
            mainImage: R.image.landing.activitySection.mainIMage(),
            sportsImage: R.image.landing.activitySection.sportsLineIcons()
        )
        return model
    }
    
    private func makeRecipesSection() -> RecipesSectionModel {
        let model = RecipesSectionModel(
            titleString: R.string.localizable.landingRecipesSectionTitle(),
            titleFont: R.font.sfProDisplayBold(size: 24),
            titleColor: UIColor(hex: "262E2C"),
            mainImage: R.image.landing.recipesSection.mainImage()
        )
        return model
    }
    
    private func makeMeasurementsSection() -> MeasurementsSectionModel {
        let model = MeasurementsSectionModel(
            titleString: R.string.localizable.landingMeasurementsSectionTitle(),
            titleFont: R.font.sfProDisplayBold(size: 24),
            titleColor: UIColor(hex: "262E2C"),
            mainImage: R.image.landing.measurementsSection.mainImage(),
            weightsImage: R.image.landing.measurementsSection.weightsImage()
        )
        return model
    }
    
    private func makeWaterSection() -> WaterSectionModel {
        let descriptionFirstPartText = NSMutableAttributedString(
            string: R.string.localizable.landingWaterSectionDescriptionFull(),
            attributes: [
                .font: R.font.sfProDisplayMedium(size: 18) ?? .systemFont(ofSize: 18),
                .foregroundColor: UIColor(hex: "05B8B8")
            ]
        )
        
        let plainString = BAMeasurement(UDM.dailyWaterGoal ?? 2000, .liquid).string(with: 0)
        let additionalString = NSAttributedString(
            string: plainString,
            attributes: [
                .font: R.font.sfProDisplayBold(size: 18) ?? .systemFont(ofSize: 18),
                .foregroundColor: UIColor(hex: "00A7CB")
            ]
        )
        descriptionFirstPartText.append(additionalString)
        
        let model = WaterSectionModel(
            headerTitle: R.string.localizable.landingWaterSectionTitle(),
            headerFont: R.font.sfProDisplayBold(size: 24),
            headerTitleColor: UIColor(hex: "262E2C"),
            titleString: descriptionFirstPartText,
            mainImage: R.image.landing.waterSection.mainImage()
        )
        return model
    }
    
    private func makeReviewsSection() -> ReviewsSectionModel {
        let model = ReviewsSectionModel(
            reviewsImages: [
                R.image.landing.reviewsSection.review_1(),
                R.image.landing.reviewsSection.review_2(),
                R.image.landing.reviewsSection.review_3(),
                R.image.landing.reviewsSection.review_4(),
                R.image.landing.reviewsSection.review_5()
            ]
        )
        return model
    }
    
    private func makeFinalSectionModel() -> FinalSectionModel {
        let model = FinalSectionModel(
            titleString: R.string.localizable.landingFinalSectionTitle(),
            titleColor: .white,
            titleFont: R.font.sfProDisplayBold(size: 32),
            descriptionString: R.string.localizable.landingFinalSectionDescriptionFull(),
            descriptionColor: .white,
            descriptionFont: R.font.sfProDisplayRegular(size: 18)
        )
        return model
    }
}
