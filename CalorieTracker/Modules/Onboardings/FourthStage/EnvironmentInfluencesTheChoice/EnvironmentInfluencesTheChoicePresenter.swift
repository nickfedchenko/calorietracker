//
//  EnvironmentInfluencesTheChoicePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol EnvironmentInfluencesTheChoicePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class EnvironmentInfluencesTheChoicePresenter {
    
    // MARK: - Public properties

    unowned var view: EnvironmentInfluencesTheChoiceViewControllerInterface
    let router: EnvironmentInfluencesTheChoiceRouterInterface?
    let interactor: EnvironmentInfluencesTheChoiceInteractorInterface?
    
    // MARK: - Private properties

    private var environmentInfluencesTheChoice: [EnvironmentInfluencesTheChoice] = []

    // MARK: - Initialization
    
    init(
        interactor: EnvironmentInfluencesTheChoiceInteractorInterface,
        router: EnvironmentInfluencesTheChoiceRouterInterface,
        view: EnvironmentInfluencesTheChoiceViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - EnvironmentInfluencesTheChoicePresenterInterface

extension EnvironmentInfluencesTheChoicePresenter: EnvironmentInfluencesTheChoicePresenterInterface {
    func viewDidLoad() {
        environmentInfluencesTheChoice = interactor?.getAllEnvironmentInfluencesTheChoice() ?? []
        
        view.set(environmentInfluencesTheChoice: environmentInfluencesTheChoice)
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(environmentInfluencesTheChoice: .stockUpOnFruitsAndVeggies)
        router?.openBestDescriptionOfTheSituation()
    }
}
