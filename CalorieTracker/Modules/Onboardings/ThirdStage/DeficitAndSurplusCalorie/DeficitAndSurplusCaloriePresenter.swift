//
//  DeficitAndSurplusCaloriePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 05.09.2022.
//

import Foundation

protocol DeficitAndSurplusCaloriePresenterInterface: AnyObject {
    func viewDidLoad()
    func didChangeRate(on value: Double)
    func didTapContinueCommonButton(with weightGoal: WeightGoal)
    func getGoal() -> WeightGoal
}

class DeficitAndSurplusCaloriePresenter {
    
    // MARK: - Public properties

    unowned var view: DeficitAndSurplusCalorieViewControllerInterface
    let router: DeficitAndSurplusCalorieRouterInterface?
    let interactor: DeficitAndSurplusCalorieInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: DeficitAndSurplusCalorieInteractorInterface,
        router: DeficitAndSurplusCalorieRouterInterface,
        view: DeficitAndSurplusCalorieViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DeficitAndSurplusCaloriePresenter: DeficitAndSurplusCaloriePresenterInterface {
    func getGoal() -> WeightGoal {
        interactor?.getWeightGoal(rate: 0) ?? .loss(calorieDeficit: 0)
    }
    
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
        
        if let yourWeight = interactor?.getYourWeight() {
            view.set(yourWeight: yourWeight)
        }
        
        if let yourGoalWeight = interactor?.getYourGoalWeight() {
            view.set(yourGoalWeight: yourGoalWeight)
        }
                
        if let weightGoal = interactor?.getWeightGoal(rate: 0.1) {
            view.set(weightGoal: weightGoal)
        }
        
        if let date = interactor?.getDate(rate: 0.1) {
            view.set(date: date)
        }
    }
    
    func didTapContinueCommonButton(with weightGoal: WeightGoal) {
        interactor?.set(weightGoal: weightGoal)
        router?.openThanksForTheInformation()
    }
    
    func didChangeRate(on value: Double) {
        if let weightGoal = interactor?.getWeightGoal(rate: value) {
            view.set(weightGoal: weightGoal)
        }
//        
        if let date = interactor?.getDate(rate: value) {
            view.set(date: date)
        }
    }
}
