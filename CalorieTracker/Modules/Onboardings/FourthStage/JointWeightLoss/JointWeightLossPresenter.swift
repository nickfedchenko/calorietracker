//
//  JointWeightLossPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol JointWeightLossPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class JointWeightLossPresenter {
    
    // MARK: - Public properties

    unowned var view: JointWeightLossViewControllerInterface
    let router: JointWeightLossRouterInterface?
    let interactor: JointWeightLossInteractorInterface?
    
    // MARK: - Private properties

    private var jointWeightLoss: [JointWeightLoss] = []

    // MARK: - Initialization
    
    init(
        interactor: JointWeightLossInteractorInterface,
        router: JointWeightLossRouterInterface,
        view: JointWeightLossViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - JointWeightLossPresenterInterface

extension JointWeightLossPresenter: JointWeightLossPresenterInterface {
    func viewDidLoad() {
        jointWeightLoss = interactor?.getAllJointWeightLoss() ?? []
        
        view.set(jointWeightLoss: jointWeightLoss)
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(jointWeightLoss: .yes)
        router?.openDifficultyOfMakingHealthyChoices()
    }
}
