//
//  NutrientGoalSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

protocol NutrientGoalSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func getNutritionGoalStr() -> String?
    func setNutrientGoal(_ value: NutrientGoalType)
    func getKcalPerPercentage() -> Double
    func getNutrientPercent() -> NutrientPercent
    func didTapResetButton()
    func didTapSaveButton()
    func setPersent(_ value: Float, type: NutrientType)
}

class NutrientGoalSettingsPresenter {
    
    private var kcalGoal: Double?

    private var nutrientTypeGoal: NutrientGoalType? {
        didSet {
            guard let nutrientTypeGoal = nutrientTypeGoal,
                  let oldValue = oldValue else {
                return
            }
            
            switch (oldValue, nutrientTypeGoal) {
            case (.default, .default):
                return
            case (.custom, .custom):
                let newSum = nutrientTypeGoal.getNutrientPercent().sum()
                view.updatePercentLabel(by: (nutrientTypeGoal.getNutrientPercent().sum() ?? 0) * 100)
            case (.lowFat, .lowFat):
                return
            case (.lowCarb, .lowCarb):
                return
            case (.highProtein, .highProtein):
                return
            default:
                view.updateCell(.nutrition)
                view.updateCell(.nutritionTitle)
            }
        }
    }
    
    unowned var view: NutrientGoalSettingsViewControllerInterface
    let router: NutrientGoalSettingsRouterInterface?
    
    init(
        router: NutrientGoalSettingsRouterInterface,
        view: NutrientGoalSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
        self.nutrientTypeGoal = UDM.nutrientPercent
        self.kcalGoal = UDM.kcalGoal
    }
    
    private func update() {
        view.updateNutrientCell((nutrientTypeGoal ?? .default).getNutrientPercent())
    }
}

extension NutrientGoalSettingsPresenter: NutrientGoalSettingsPresenterInterface {
    func setPersent(_ value: Float, type: NutrientType) {
        let oldNutrientPercent = (nutrientTypeGoal ?? .default).getNutrientPercent()
        switch type {
        case .fat:
            self.nutrientTypeGoal = .custom(.init(
                fat: Double(value),
                protein: oldNutrientPercent.protein,
                carbs: oldNutrientPercent.carbs
            ))
            if Double(value) + oldNutrientPercent.protein + oldNutrientPercent.carbs > 1 {
                view.setSaveButton(enabled: false)
            } else {
                view.setSaveButton(enabled: true)
            }
            print("New fat value \(value)")
        case .protein:
            self.nutrientTypeGoal = .custom(.init(
                fat: oldNutrientPercent.fat,
                protein: Double(value),
                carbs: oldNutrientPercent.carbs
            ))
            if Double(value) + oldNutrientPercent.fat + oldNutrientPercent.carbs > 1 {
                view.setSaveButton(enabled: false)
            } else {
                view.setSaveButton(enabled: true)
            }
        case .carbs:
            self.nutrientTypeGoal = .custom(.init(
                fat: oldNutrientPercent.fat,
                protein: oldNutrientPercent.protein,
                carbs: Double(value)
            ))
            if Double(value) + oldNutrientPercent.protein + oldNutrientPercent.fat > 1 {
                view.setSaveButton(enabled: false)
            } else {
                view.setSaveButton(enabled: true)
            }
        }
    }
    
    func didTapResetButton() {
        Vibration.warning.vibrate()
        self.nutrientTypeGoal = UDM.nutrientPercent
        update()
    }
    
    func didTapSaveButton() {
        Vibration.success.vibrate()
        UDM.nutrientPercent = nutrientTypeGoal
        view.needUpdateParentVC()
        router?.closeViewController()
    }
    
    func didTapBackButton() {
        Vibration.rigid.vibrate()
        router?.closeViewController()
    }
    
    func getNutritionGoalStr() -> String? {
        return (nutrientTypeGoal ?? .default).getTitle(.long)
    }
    
    func setNutrientGoal(_ value: NutrientGoalType) {
        self.nutrientTypeGoal = value
        self.update()
    }
    
    func getKcalPerPercentage() -> Double {
        return (kcalGoal ?? 0) / 100
    }
    
    func getNutrientPercent() -> NutrientPercent {
        (self.nutrientTypeGoal ?? .default).getNutrientPercent()
    }
}
