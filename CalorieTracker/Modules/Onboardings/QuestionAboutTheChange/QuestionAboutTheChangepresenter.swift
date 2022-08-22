//
//  QuestionAboutTheChangepresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol QuestionAboutTheChangePresenterInterface: AnyObject {}

class QuestionAboutTheChangePresenter {
    
    unowned var view: QuestionAboutTheChangeViewControllerInterface
    let router: QuestionAboutTheChangeRouterInterface?
    let interactor: QuestionAboutTheChangeInteractorInterface?

    init(
        interactor: QuestionAboutTheChangeInteractorInterface,
        router: QuestionAboutTheChangeRouterInterface,
        view: QuestionAboutTheChangeViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension QuestionAboutTheChangePresenter: QuestionAboutTheChangePresenterInterface {}
