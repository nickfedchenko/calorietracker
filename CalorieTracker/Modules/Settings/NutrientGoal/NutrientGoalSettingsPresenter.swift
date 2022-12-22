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
                return
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
        case .protein:
            self.nutrientTypeGoal = .custom(.init(
                fat: Double(value),
                protein: oldNutrientPercent.protein,
                carbs: oldNutrientPercent.carbs
            ))
        case .carbs:
            self.nutrientTypeGoal = .custom(.init(
                fat: Double(value),
                protein: oldNutrientPercent.protein,
                carbs: oldNutrientPercent.carbs
            ))
        }
    }
    
    func didTapResetButton() {
        self.nutrientTypeGoal = UDM.nutrientPercent
        update()
    }
    
    func didTapSaveButton() {
        UDM.nutrientPercent = nutrientTypeGoal
        view.needUpdateParentVC()
        router?.closeViewController()
    }
    
    func didTapBackButton() {
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
