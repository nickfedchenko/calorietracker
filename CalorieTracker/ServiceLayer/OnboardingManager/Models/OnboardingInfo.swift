//
//  OnboardingInfo.swift
//  CalorieTracker
//
//  Created by Алексей on 24.08.2022.
//

struct OnboardingInfo {
    var isHaveYouTriedToLoseWeightBefor: Bool?
    var descriptionOfExperience: DescriptionOfExperience?
    var purposeOfTheParish: PurposeOfTheParish?
    var recentWeightChanges: Bool?
    var questionAboutTheChange: QuestionAboutTheChange?
    var achievingDifficultGoal: AchievingDifficultGoal?
    var lastCalorieCount: LastCalorieCount?
    var calorieCount: Bool?
    var previousApplication: PreviousApplication?
    var obsessingOverFood: ObsessingOverFood?
    var theEffectOfWeight: TheEffectOfWeight?
    var formationGoodHabits: FormationGoodHabits?
    var enterYourName: String?
    var whatsYourGender: WhatsYourGender?
    var measurementSystem: MeasurementSystem?
    var dateOfBirth: String?
    var yourHeight: String?
    var yourWeight: String?
    var risksOfDiseases: RisksOfDiseases?
    var presenceOfAllergies: PresenceOfAllergies?
    var allergicRestrictions: AllergicRestrictions?
    var importanceOfWeightLoss: ImportanceOfWeightLoss?
    var thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings?
    var lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss?
    var whatIsYourGoalWeight: String?
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
    
    private var firstStageData: [Any?] {
        return [
            isHaveYouTriedToLoseWeightBefor,
            descriptionOfExperience,
            purposeOfTheParish,
            recentWeightChanges,
            questionAboutTheChange,
            achievingDifficultGoal,
            lastCalorieCount,
            calorieCount,
            previousApplication,
            obsessingOverFood,
            theEffectOfWeight,
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
            presenceOfAllergies,
            allergicRestrictions
        ]
    }
    
    private var thirdStageData: [Any?] {
        return [
            importanceOfWeightLoss,
            thoughtsAboutChangingFeelings,
            lifeChangesAfterWeightLoss,
            whatIsYourGoalWeight
        ]
    }
    
    private var fourthStageData: [Any?] {
        return [
            currentLifestile,
            nutritionImprovement,
            improvingNutrition,
            increasingYourActivityLevel,
            howImproveYourEfficiency,
            representationOfIncreasedActivityLevels,
            sequenceOfHabitFormation,
            descriptionOfCulinarySkills,
            whatImportantToYou,
            thoughtsOnStressEating,
            difficultyChoosingLifestyle,
            interestInUsingTechnology,
            placeOfResidence,
            environmentInfluencesTheChoice,
            bestDescriptionOfTheSituation,
            timeForYourself,
            jointWeightLoss,
            lifestyleOfOthers,
            emotionalSupportSystem
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
