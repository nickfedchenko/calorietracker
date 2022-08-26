//
//  OnboardingManager.swift
//  CalorieTracker
//
//  Created by Алексей on 24.08.2022.
//

protocol OnboardingManagerInterface {
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
}

class OnboardingManager {
    
    // MARK: - Shared
    
    static let shared: OnboardingManagerInterface = OnboardingManager()
    
    // MARK: - Private properties
    
    private var onboardingInfo: OnboardingInfo = .init() {
        didSet {
            print(onboardingInfo)
        }
    }
    
    // MARK: - Initialization
    
    private init() {}
}

// MARK: - OnboardingManagerInterface

extension OnboardingManager: OnboardingManagerInterface {
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
}
