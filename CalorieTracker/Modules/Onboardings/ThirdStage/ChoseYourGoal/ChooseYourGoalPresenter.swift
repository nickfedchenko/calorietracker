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
    func didSelectChooseYourGoal(with index: Int)
    func didDeselectChooseYourGoal()
}

class ChooseYourGoalPresenter {
    
    // MARK: - Public properties
    
    unowned var view: ChooseYourGoalViewControllerInterface
    let router: ChooseYourGoalRouterInterface?
    let interactor: ChooseYourGoalInteractorInterface?
    // MARK: - Private properties
    
    private var chooseYourGoal: [ChooseYourGoal] = []
    private var chooseYourGoalIndex: Int?
    
    // MARK: - Initialization
    
    init(
        interactor: ChooseYourGoalInteractorInterface,
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
        chooseYourGoal = interactor?.getAllChooseYourGoal() ?? []
        
        view.set(chooseYourGoal: chooseYourGoal)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(chooseYourGoal: chooseYourGoal[chooseYourGoalIndex ?? 0])
        router?.openLifeChangesAfterWeightLoss()
    }
    
    func didSelectChooseYourGoal(with index: Int) {
        chooseYourGoalIndex = index
    }
    
    func didDeselectChooseYourGoal() {
        chooseYourGoalIndex = nil
    }
}
