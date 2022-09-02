//
//  YourWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourWeightPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class YourWeightPresenter {
    
    // MARK: - Public properties

    unowned var view: YourWeightViewControllerInterface
    let router: YourWeightRouterInterface?
    let interactor: YourWeightInteractorInterface?
    
    // MARK: - Initialization
    
    init(
        interactor: YourWeightInteractorInterface,
        router: YourWeightRouterInterface,
        view: YourWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - YourWeightPresenterInterface

extension YourWeightPresenter: YourWeightPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(yourWeight: "name")
        router?.openRisksOfDiseases()
    }
}
