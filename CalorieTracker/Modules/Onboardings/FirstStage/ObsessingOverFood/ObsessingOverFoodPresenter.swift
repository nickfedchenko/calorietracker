//
//  ObsessingOverFoodPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectObsessingOverFood(with index: Int)
    func didDeselectObsessingOverFood()
}

class ObsessingOverFoodPresenter {
    
    // MARK: - Public properties

    unowned var view: ObsessingOverFoodViewControllerInterface
    let router: ObsessingOverFoodRouterInterface?
    let interactor: ObsessingOverFoodInterctorInterface?

    // MARK: - Private properties

    private var obsessingOverFood: [ObsessingOverFood] = []
    private var obsessingOverFoodIndex: Int?
    
    // MARK: - Initialization

    init(
        interactor: ObsessingOverFoodInterctorInterface,
        router: ObsessingOverFoodRouterInterface,
        view: ObsessingOverFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ObsessingOverFoodPresenterInterface

extension ObsessingOverFoodPresenter: ObsessingOverFoodPresenterInterface {
    func viewDidLoad() {
        obsessingOverFood = interactor?.getAllObsessingOverFood() ?? []
        
        view.set(obsessingOverFood: obsessingOverFood)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapNextCommonButton() {
        interactor?.set(obsessingOverFood: .yesDefinitely)
        router?.openTheEffectOfWeight()
    }
    
    func didSelectObsessingOverFood(with index: Int) {
        obsessingOverFoodIndex = index
    }
    
    func didDeselectObsessingOverFood() {
        obsessingOverFoodIndex = nil
    }
}
