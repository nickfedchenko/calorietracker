//
//  OnboardingInfo.swift
//  CalorieTracker
//
//  Created by Алексей on 24.08.2022.
//

import Foundation

struct OnboardingInfo {
    var isHaveYouTriedToLoseWeightBefor: Bool?
    var descriptionOfExperience: DescriptionOfExperience?
    var purposeOfTheParish: PurposeOfTheParish?
    var recentWeightChanges: Bool?
    var questionAboutTheChange: QuestionAboutTheChange?
    var achievingDifficultGoal: AchievingDifficultGoal?
    var lastCalorieCount: LastCalorieCount? = .anotherWay
    var calorieCount: Bool?
    var previousApplication: PreviousApplication? = .anotherApp
    var obsessingOverFood: ObsessingOverFood?
    var theEffectOfWeight: TheEffectOfWeight?
    var formationGoodHabits: FormationGoodHabits?
    var enterYourName: String?
    var whatsYourGender: WhatsYourGender?
    var measurementSystem: MeasurementSystem?
    var dateOfBirth: Date?
    var yourHeight: Double?
    var yourWeight: Double?
    var risksOfDiseases: RisksOfDiseases?
    var presenceOfAllergies: PresenceOfAllergies?
    var allergicRestrictions: AllergicRestrictions?
    var importanceOfWeightLoss: ImportanceOfWeightLoss?
    var thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings?
    var lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss?
    var whatIsYourGoalWeight: Double?
    var currentLifestile: CurrentLifestile?
    var nutritionImprovement: Bool?
    var improvingNutrition: ImprovingNutrition?
    var increasingYourActivityLevel: Bool?
    var howImproveYourEfficiency: HowImproveYourEfficiency?
    var representationOfIncreasedActivityLevels: Bool?
    var sequenceOfHabitFormation: SequenceOfHabitFormation?
    var descriptionOfCulinarySkills: DescriptionOfCulinarySkills?
    var whatImportantToYou: Bool?
    var thoughtsOnStressEating: Bool?
    var difficultyChoosingLifestyle: Bool?
    var interestInUsingTechnology: Bool?
    var placeOfResidence: PlaceOfResidence?
    var environmentInfluencesTheChoice: EnvironmentInfluencesTheChoice?
    var bestDescriptionOfTheSituation: BestDescriptionOfTheSituation?
    var timeForYourself: TimeForYourself?
    var jointWeightLoss: JointWeightLoss?
    var lifestyleOfOthers: LifestyleOfOthers?
    var emotionalSupportSystem: EmotionalSupportSystem?
    var weightGoal: WeightGoal?
    var mail: String?
    var activityLevel: ActivityLevel?
    var dietarySetting: UserDietary?
    var chooseYourGoal: ChooseYourGoal?
    
    private var firstStageData: [Any?] {
        return [
            purposeOfTheParish,
            lastCalorieCount,
            calorieCount,
            previousApplication,
            obsessingOverFood,
            formationGoodHabits
        ]
    }
    
    private var secondStageData: [Any?] {
        return [
            enterYourName,
            whatsYourGender,
            measurementSystem,
            dateOfBirth,
            yourHeight,
            yourWeight,
            risksOfDiseases,
            presenceOfAllergies
        ]
    }
    
    private var thirdStageData: [Any?] {
        return [
            importanceOfWeightLoss,
            chooseYourGoal,
            lifeChangesAfterWeightLoss,
            whatIsYourGoalWeight,
            activityLevel,
            weightGoal
        ]
    }
    
    private var fourthStageData: [Any?] {
        return [
            improvingNutrition,
            whatImportantToYou,
            placeOfResidence,
            environmentInfluencesTheChoice,
            bestDescriptionOfTheSituation,
            lifestyleOfOthers,
            emotionalSupportSystem,
            dietarySetting
        ]
    }
}

// MARK: - Stages data

extension OnboardingInfo {
    var currentOnboardingStage: OnboardingStage {
        if firstStageData.contains(where: { $0 == nil }) {
            let filledDataCount = firstStageData.filter { $0 != nil }.count

            return .first(progress: Double(filledDataCount) / Double(firstStageData.count))
        } else if secondStageData.contains(where: { $0 == nil }) {
            let filledDataCount = secondStageData.filter { $0 != nil }.count
            
            return .second(progress: Double(filledDataCount) / Double(secondStageData.count))
        } else if thirdStageData.contains(where: { $0 == nil }) {
            let filledDataCount = thirdStageData.filter { $0 != nil }.count
            
            return .third(progress: Double(filledDataCount) / Double(thirdStageData.count))
        } else {
            let filledDataCount = fourthStageData.filter { $0 != nil }.count
            
            return .fourth(progress: Double(filledDataCount) / Double(fourthStageData.count))
        }
    }
}
