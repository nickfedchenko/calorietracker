//
//  DateOfBirthPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol DateOfBirthPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class DateOfBirthPresenter {
    // MARK: - Public properties

    unowned var view: DateOfBirthViewControllerInterface
    let router: DateOfBirthRouterInterface?
    let interactor: DateOfBirthInteractorInterface?
    
    // MARK: - Private properties
    
    private var dateOfBirthIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: DateOfBirthInteractorInterface,
        router: DateOfBirthRouterInterface,
        view: DateOfBirthViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DateOfBirthPresenter: DateOfBirthPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openYourHeight()
    }
}
