//
//  DescriptionOfExperiencePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol DescriptionOfExperiencePresenterInterface: AnyObject {}

class DescriptionOfExperiencePresenter {
    
    unowned var view: DescriptionOfExperienceViewControllerInterface
    let router: DescriptionOfExperienceRouterInterface?
    let interactor: DescriptionOfExperienceInteractorInterface?

    init(
        interactor: DescriptionOfExperienceInteractorInterface,
        router: DescriptionOfExperienceRouterInterface,
        view: DescriptionOfExperienceViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension  DescriptionOfExperiencePresenter: DescriptionOfExperiencePresenterInterface {}
