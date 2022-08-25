//
//  RecentWeightChangesPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol RecentWeightChangesPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class RecentWeightChangesPresenter {
    
    // MARK: - Public properties
    
    unowned var view: RecentWeightChangesViewControllerInterface
    let router: RecentWeightChangesRouterInterface?
    let interactor: RecentWeightChangesInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: RecentWeightChangesInteractorInterface,
        router: RecentWeightChangesRouterInterface,
        view: RecentWeightChangesViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - RecentWeightChangesPresenterInterface

extension RecentWeightChangesPresenter: RecentWeightChangesPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(recentWeightChanges: true)
        router?.openCallToAchieveGoal()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(recentWeightChanges: false)
        router?.openCallToAchieveGoal()
    }
}
