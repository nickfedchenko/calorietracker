//
//  YourWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourWeightPresenterInterface: AnyObject {
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

extension YourWeightPresenter: YourWeightPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openRisksOfDiseases()
    }
}
