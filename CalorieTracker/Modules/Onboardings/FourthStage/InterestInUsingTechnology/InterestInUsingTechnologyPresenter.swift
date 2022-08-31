//
//  InterestInUsingTechnologyPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol InterestInUsingTechnologyPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class InterestInUsingTechnologyPresenter {
    
    // MARK: - Public properties
    
    unowned var view: InterestInUsingTechnologyViewControllerInterface
    let router: InterestInUsingTechnologyRouterInterface?
    let interactor: InterestInUsingTechnologyInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: InterestInUsingTechnologyInteractorInterface,
        router: InterestInUsingTechnologyRouterInterface,
        view: InterestInUsingTechnologyViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - InterestInUsingTechnologyPresenterInterface

extension InterestInUsingTechnologyPresenter: InterestInUsingTechnologyPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(interestInUsingTechnology: true)
        router?.openPlaceOfResidence()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(interestInUsingTechnology: false)
        router?.openPlaceOfResidence()
    }
}
