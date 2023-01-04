//
//  OnboardingManager.swift
//  CalorieTracker
//
//  Created by Алексей on 24.08.2022.
//

import Foundation

protocol OnboardingManagerInterface {
    func getCurrentOnboardingStage() -> OnboardingStage
    
    func set(isHaveYouTriedToLoseWeightBefor: Bool)
    
    func getAllDescriptionOfExperience() -> [DescriptionOfExperience]
    func set(descriptionOfExperience: DescriptionOfExperience)
    
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish]
    func set(purposeOfTheParish: PurposeOfTheParish)
    
    func set(recentWeightChanges: Bool)
    
    func getAllQuestionAboutTheChange() -> [QuestionAboutTheChange]
    func set(questionAboutTheChange: QuestionAboutTheChange)
    
    func getAllAchievingDifficultGoal() -> [AchievingDifficultGoal]
    func set(achievingDifficultGoal: AchievingDifficultGoal)
    
    func getAllLastCalorieCount() -> [LastCalorieCount]
    func set(lastCalorieCount: LastCalorieCount)
    
    func set(calorieCount: Bool)
    
    func getAllPreviousApplication() -> [PreviousApplication]
    func set(previousApplication: PreviousApplication)
    
    func getAllObsessingOverFood() -> [ObsessingOverFood]
    func set(obsessingOverFood: ObsessingOverFood)
    
    func getAllTheEffectOfWeight() -> [TheEffectOfWeight]
    func set(theEffectOfWeight: TheEffectOfWeight)
    
    func getAllFormationGoodHabits() -> [FormationGoodHabits]
    func set(formationGoodHabits: FormationGoodHabits)
    
    func set(enterYourName: String)
    
    func getAllWhatsYourGender() -> [WhatsYourGender]
    func set(whatsYourGender: WhatsYourGender)
    
    func getAllMeasurementSystem() -> [MeasurementSystem]
    func set(measurementSystem: MeasurementSystem)
    
    func set(dateOfBirth: Date)
    
    func set(yourHeight: Double)
    
    func set(yourWeight: Double)
    func getYourWeight() -> Double?
    
    func set(weightGoal: WeightGoal)
    
    func getAllRisksOfDiseases() -> [RisksOfDiseases]
    func set(risksOfDiseases: RisksOfDiseases)
    
    func getAllPresenceOfAllergies() -> [PresenceOfAllergies]
    func set(presenceOfAllergies: PresenceOfAllergies)
    
    func getAllAllergicRestrictions() -> [AllergicRestrictions]
    func set(allergicRestrictions: AllergicRestrictions)
    
    func getAllImportanceOfWeightLoss() -> [ImportanceOfWeightLoss]
    func set(importanceOfWeightLoss: ImportanceOfWeightLoss)
    
    func getAllThoughtsAboutChangingFeelings() -> [ThoughtsAboutChangingFeelings]
    func set(thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings)
    
    func getAllLifeChangesAfterWeightLoss() -> [LifeChangesAfterWeightLoss]
    func set(lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss)
    
    func set(whatIsYourGoalWeight: Double)
    func getYourGoalWeight() -> Double?
    
    func getAllCurrentLifestile() -> [CurrentLifestile]
    func set(currentLifestile: CurrentLifestile)
    
    func set(nutritionImprovement: Bool)
    
    func getAllImprovingNutrition() -> [ImprovingNutrition]
    func set(improvingNutrition: ImprovingNutrition)
    
    func set(increasingYourActivityLevel: Bool)
    
    func getAllHowImproveYourEfficiency() -> [HowImproveYourEfficiency]
    func set(howImproveYourEfficiency: HowImproveYourEfficiency)
    
    func set(representationOfIncreasedActivityLevels: Bool)
    
    func getAllSequenceOfHabitFormation() -> [SequenceOfHabitFormation]
    func set(sequenceOfHabitFormation: SequenceOfHabitFormation)
    
    func getAllDescriptionOfCulinarySkills() -> [DescriptionOfCulinarySkills]
    func set(descriptionOfCulinarySkills: DescriptionOfCulinarySkills)
    
    func set(whatImportantToYou: Bool)
    
    func set(thoughtsOnStressEating: Bool)
    
    func set(difficultyChoosingLifestyle: Bool)
    
    func set(interestInUsingTechnology: Bool)
    
    func getAllPlaceOfResidence() -> [PlaceOfResidence]
    func set(placeOfResidence: PlaceOfResidence)
    
    func getAllEnvironmentInfluencesTheChoice() -> [EnvironmentInfluencesTheChoice]
    func set(environmentInfluencesTheChoice: EnvironmentInfluencesTheChoice)
    
    func getAllBestDescriptionOfTheSituation() -> [BestDescriptionOfTheSituation]
    func set(bestDescriptionOfTheSituation: BestDescriptionOfTheSituation)
    
    func getAllTimeForYourself() -> [TimeForYourself]
    func set(timeForYourself: TimeForYourself)
    
    func getAllJointWeightLoss() -> [JointWeightLoss]
    func set(jointWeightLoss: JointWeightLoss)
    
    func getAllLifestyleOfOthers() -> [LifestyleOfOthers]
    func set(lifestyleOfOthers: LifestyleOfOthers)
    
    func getAllEmotionalSupportSystem() -> [EmotionalSupportSystem]
    func set(emotionalSupportSystem: EmotionalSupportSystem)
    
    func getOnboardingInfo() -> OnboardingInfo
}

class OnboardingManager {
    
    // MARK: - Shared
    
    static let shared: OnboardingManagerInterface = OnboardingManager()
    
    // MARK: - Private properties
    
    private var onboardingInfo: OnboardingInfo = .init()
    
    // MARK: - Initialization
    
    private init() {}
}

// MARK: - OnboardingManagerInterface

extension OnboardingManager: OnboardingManagerInterface {
    func getOnboardingInfo() -> OnboardingInfo {
        return onboardingInfo
    }
    
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingInfo.currentOnboardingStage
    }
    
    func set(isHaveYouTriedToLoseWeightBefor: Bool) {
        onboardingInfo.isHaveYouTriedToLoseWeightBefor = isHaveYouTriedToLoseWeightBefor
    }
    
    func getAllDescriptionOfExperience() -> [DescriptionOfExperience] {
        return DescriptionOfExperience.allCases
    }
    
    func set(descriptionOfExperience: DescriptionOfExperience) {
        onboardingInfo.descriptionOfExperience = descriptionOfExperience
    }
    
    func getAllPurposeOfTheParish() -> [PurposeOfTheParish] {
        return PurposeOfTheParish.allCases
    }
    
    func set(purposeOfTheParish: PurposeOfTheParish) {
        onboardingInfo.purposeOfTheParish = purposeOfTheParish
    }
    
    func set(recentWeightChanges: Bool) {
        onboardingInfo.recentWeightChanges = recentWeightChanges
    }
    
    func getAllQuestionAboutTheChange() -> [QuestionAboutTheChange] {
        return QuestionAboutTheChange.allCases
    }
    
    func set(questionAboutTheChange: QuestionAboutTheChange) {
        onboardingInfo.questionAboutTheChange = questionAboutTheChange
    }
    
    func getAllAchievingDifficultGoal() -> [AchievingDifficultGoal] {
        return AchievingDifficultGoal.allCases
    }
    
    func set(achievingDifficultGoal: AchievingDifficultGoal) {
        onboardingInfo.achievingDifficultGoal = achievingDifficultGoal
    }
    
    func getAllLastCalorieCount() -> [LastCalorieCount] {
        return LastCalorieCount.allCases
    }
    
    func set(lastCalorieCount: LastCalorieCount) {
        onboardingInfo.lastCalorieCount = lastCalorieCount
    }
    
    func set(calorieCount: Bool) {
        onboardingInfo.calorieCount = calorieCount
    }
    
    func getAllPreviousApplication() -> [PreviousApplication] {
        return PreviousApplication.allCases
    }
    
    func set(previousApplication: PreviousApplication) {
        onboardingInfo.previousApplication = previousApplication
    }
    
    func getAllObsessingOverFood() -> [ObsessingOverFood] {
        return ObsessingOverFood.allCases
    }
    
    func set(obsessingOverFood: ObsessingOverFood) {
        onboardingInfo.obsessingOverFood = obsessingOverFood
    }
    
    func getAllTheEffectOfWeight() -> [TheEffectOfWeight] {
        return TheEffectOfWeight.allCases
    }
    
    func set(theEffectOfWeight: TheEffectOfWeight) {
        onboardingInfo.theEffectOfWeight = theEffectOfWeight
    }
    
    func getAllFormationGoodHabits() -> [FormationGoodHabits] {
        return FormationGoodHabits.allCases
    }
    
    func set(formationGoodHabits: FormationGoodHabits) {
        onboardingInfo.formationGoodHabits = formationGoodHabits
    }
    
    func set(enterYourName: String) {
        onboardingInfo.enterYourName = enterYourName
    }
    
    func getAllWhatsYourGender() -> [WhatsYourGender] {
        return WhatsYourGender.allCases
    }
    
    func set(whatsYourGender: WhatsYourGender) {
        onboardingInfo.whatsYourGender = whatsYourGender
    }
    
    func getAllMeasurementSystem() -> [MeasurementSystem] {
        return MeasurementSystem.allCases
    }
    
    func set(measurementSystem: MeasurementSystem) {
        onboardingInfo.measurementSystem = measurementSystem
    }
    
    func set(dateOfBirth: Date) {
        onboardingInfo.dateOfBirth = dateOfBirth
    }
    
    func set(yourHeight: Double) {
        onboardingInfo.yourHeight = yourHeight
    }
    
    func set(yourWeight: Double) {
        onboardingInfo.yourWeight = yourWeight
    }
    
    func getYourWeight() -> Double? {
        return onboardingInfo.yourWeight
    }
    
    func getAllRisksOfDiseases() -> [RisksOfDiseases] {
        return RisksOfDiseases.allCases
    }
    
    func set(risksOfDiseases: RisksOfDiseases) {
        onboardingInfo.risksOfDiseases = risksOfDiseases
    }
    
    func getAllPresenceOfAllergies() -> [PresenceOfAllergies] {
        return PresenceOfAllergies.allCases
    }
    
    func set(presenceOfAllergies: PresenceOfAllergies) {
        onboardingInfo.presenceOfAllergies = presenceOfAllergies
    }
    
    func getAllAllergicRestrictions() -> [AllergicRestrictions] {
        return AllergicRestrictions.allCases
    }
    
    func set(allergicRestrictions: AllergicRestrictions) {
        onboardingInfo.allergicRestrictions = allergicRestrictions
    }
    
    func getAllImportanceOfWeightLoss() -> [ImportanceOfWeightLoss] {
        return ImportanceOfWeightLoss.allCases
    }
    
    func set(importanceOfWeightLoss: ImportanceOfWeightLoss) {
        onboardingInfo.importanceOfWeightLoss = importanceOfWeightLoss
    }
    
    func getAllThoughtsAboutChangingFeelings() -> [ThoughtsAboutChangingFeelings] {
        return ThoughtsAboutChangingFeelings.allCases
    }
    
    func set(thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings) {
        onboardingInfo.thoughtsAboutChangingFeelings = thoughtsAboutChangingFeelings
    }
    
    func getAllLifeChangesAfterWeightLoss() -> [LifeChangesAfterWeightLoss] {
        return LifeChangesAfterWeightLoss.allCases
    }
    
    func set(lifeChangesAfterWeightLoss: LifeChangesAfterWeightLoss) {
        onboardingInfo.lifeChangesAfterWeightLoss = lifeChangesAfterWeightLoss
    }
    
    func set(whatIsYourGoalWeight: Double) {
        onboardingInfo.whatIsYourGoalWeight = whatIsYourGoalWeight
    }
    
    func getYourGoalWeight() -> Double? {
        return onboardingInfo.whatIsYourGoalWeight
    }
    
    func getAllCurrentLifestile() -> [CurrentLifestile] {
        return CurrentLifestile.allCases
    }
    
    func set(currentLifestile: CurrentLifestile) {
        onboardingInfo.currentLifestile = currentLifestile
    }
    
    func set(nutritionImprovement: Bool) {
        onboardingInfo.nutritionImprovement = nutritionImprovement
    }
    
    func getAllImprovingNutrition() -> [ImprovingNutrition] {
        return ImprovingNutrition.allCases
    }
    
    func set(improvingNutrition: ImprovingNutrition) {
        onboardingInfo.improvingNutrition = improvingNutrition
    }
    
    func set(increasingYourActivityLevel: Bool) {
        onboardingInfo.increasingYourActivityLevel = increasingYourActivityLevel
    }
    
    func getAllHowImproveYourEfficiency() -> [HowImproveYourEfficiency] {
        return HowImproveYourEfficiency.allCases
    }
    
    func set(howImproveYourEfficiency: HowImproveYourEfficiency) {
        onboardingInfo.howImproveYourEfficiency = howImproveYourEfficiency
    }
    
    func set(representationOfIncreasedActivityLevels: Bool) {
        onboardingInfo.representationOfIncreasedActivityLevels = representationOfIncreasedActivityLevels
    }

    func getAllSequenceOfHabitFormation() -> [SequenceOfHabitFormation] {
        return SequenceOfHabitFormation.allCases
    }
    
    func set(sequenceOfHabitFormation: SequenceOfHabitFormation) {
        onboardingInfo.sequenceOfHabitFormation = sequenceOfHabitFormation
    }
    
    func getAllDescriptionOfCulinarySkills() -> [DescriptionOfCulinarySkills] {
        return DescriptionOfCulinarySkills.allCases
    }
    
    func set(descriptionOfCulinarySkills: DescriptionOfCulinarySkills) {
        onboardingInfo.descriptionOfCulinarySkills = descriptionOfCulinarySkills
    }
    
    func set(whatImportantToYou: Bool) {
        onboardingInfo.whatImportantToYou = whatImportantToYou
    }
    
    func set(thoughtsOnStressEating: Bool) {
        onboardingInfo.thoughtsOnStressEating = thoughtsOnStressEating
    }
    
    func set(difficultyChoosingLifestyle: Bool) {
        onboardingInfo.difficultyChoosingLifestyle = difficultyChoosingLifestyle
    }
    
    func set(interestInUsingTechnology: Bool) {
        onboardingInfo.interestInUsingTechnology = interestInUsingTechnology
    }
    
    func getAllPlaceOfResidence() -> [PlaceOfResidence] {
        return PlaceOfResidence.allCases
    }
    
    func set(placeOfResidence: PlaceOfResidence) {
        onboardingInfo.placeOfResidence = placeOfResidence
    }
    
    func getAllEnvironmentInfluencesTheChoice() -> [EnvironmentInfluencesTheChoice] {
        return EnvironmentInfluencesTheChoice.allCases
    }
    
    func set(environmentInfluencesTheChoice: EnvironmentInfluencesTheChoice) {
        onboardingInfo.environmentInfluencesTheChoice = environmentInfluencesTheChoice
    }
    
    func getAllBestDescriptionOfTheSituation() -> [BestDescriptionOfTheSituation] {
        return BestDescriptionOfTheSituation.allCases
    }
    
    func set(bestDescriptionOfTheSituation: BestDescriptionOfTheSituation) {
        onboardingInfo.bestDescriptionOfTheSituation = bestDescriptionOfTheSituation
    }
    
    func getAllTimeForYourself() -> [TimeForYourself] {
        return TimeForYourself.allCases
    }
    
    func set(timeForYourself: TimeForYourself) {
        onboardingInfo.timeForYourself = timeForYourself
    }
    
    func getAllJointWeightLoss() -> [JointWeightLoss] {
        return JointWeightLoss.allCases
    }
    
    func set(jointWeightLoss: JointWeightLoss) {
        onboardingInfo.jointWeightLoss = jointWeightLoss
    }
    
    func getAllLifestyleOfOthers() -> [LifestyleOfOthers] {
        return LifestyleOfOthers.allCases
    }
    
    func set(lifestyleOfOthers: LifestyleOfOthers) {
        onboardingInfo.lifestyleOfOthers = lifestyleOfOthers
    }
    
    func getAllEmotionalSupportSystem() -> [EmotionalSupportSystem] {
        return EmotionalSupportSystem.allCases
    }
    
    func set(emotionalSupportSystem: EmotionalSupportSystem) {
        onboardingInfo.emotionalSupportSystem = emotionalSupportSystem
    }
    
    func set(weightGoal: WeightGoal) {
        onboardingInfo.weightGoal = weightGoal
    }
}
