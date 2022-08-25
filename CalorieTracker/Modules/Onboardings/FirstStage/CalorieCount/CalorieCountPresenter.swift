//
//  CalorieCountPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CalorieCountPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class CalorieCountPresenter {
    
    // MARK: - Public properties

    unowned var view: CalorieCountViewControllerInterface
    let router: CalorieCountRouterInterface?
    let interactor: CalorieCountInteractorInterface?

    // MARK: - Initialization

    init(
        interactor: CalorieCountInteractorInterface,
        router: CalorieCountRouterInterface,
        view: CalorieCountViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - CalorieCountPresenterInterface

extension CalorieCountPresenter: CalorieCountPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(calorieCount: true)
        router?.openPreviousApplication()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(calorieCount: false)
        router?.openPreviousApplication()
    }
}
