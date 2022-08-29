//
//  FinalOfTheThirdStagePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol FinalOfTheThirdStagePresenterInterface: AnyObject {}

class FinalOfTheThirdStagePresenter {
    
    // MARK: - Public properties

    unowned var view: FinalOfTheThirdStageViewControllerInterface
    let router: FinalOfTheThirdStageRouterInterface?
    let interactor: FinalOfTheThirdStageInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: FinalOfTheThirdStageInteractorInterface,
        router: FinalOfTheThirdStageRouterInterface,
        view: FinalOfTheThirdStageViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FinalOfTheThirdStagePresenter: FinalOfTheThirdStagePresenterInterface {}
