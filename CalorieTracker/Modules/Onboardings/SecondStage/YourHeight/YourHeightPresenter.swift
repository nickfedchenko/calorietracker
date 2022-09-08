//
//  YourHeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourHeightPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton(with name: String)
}

class YourHeightPresenter {
    
    // MARK: - Public properties

    unowned var view: YourHeightViewControllerInterface
    let router: YourHeightRouterInterface?
    let interactor: YourHeightInteractorInterface?
    
    // MARK: - Initialization
    
    init(
        interactor: YourHeightInteractorInterface,
        router: YourHeightRouterInterface,
        view: YourHeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - YourHeightPresenterInterface

extension YourHeightPresenter: YourHeightPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton(with name: String) {
        interactor?.set(yourHeight: name)
        router?.openYourWeight()
    }
}
