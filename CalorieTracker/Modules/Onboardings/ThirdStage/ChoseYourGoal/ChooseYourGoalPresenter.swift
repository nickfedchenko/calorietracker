//
//  ChooseYourGoalPresenter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 11.03.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol ChooseYourGoalPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class ChooseYourGoalPresenter {
    
    // MARK: - Public properties
    
    unowned var view: ChooseYourGoalViewControllerInterface
    let router: ChooseYourGoalRouterInterface?
    let interactor: ChoseYourGoalInteractorInterface?
    // MARK: - Private properties
    
    private var choseYourGoal: [ChooseYourGoal] = []
    
    // MARK: - Initialization
    
    init(
        interactor: ChoseYourGoalInteractorInterface,
        router: ChooseYourGoalRouterInterface,
        view: ChooseYourGoalViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ChooseYourGoalPresenter: ChooseYourGoalPresenterInterface {
    func viewDidLoad() {
        choseYourGoal = interactor?.getAllChoseYourGoal() ?? []
        
        view.set(choseYourGoal: choseYourGoal)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(choseYourGoal: .loseWeight)
        router?.openLifeChangesAfterWeightLoss()
    }
}
