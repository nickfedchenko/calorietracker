//
//  DateOfBirthPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol DateOfBirthPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton(with date: Date)
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

// MARK: - DateOfBirthPresenterInterface

extension DateOfBirthPresenter: DateOfBirthPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton(with date: Date) {
        interactor?.set(dateOfBirth: date)
        router?.openYourHeight()
    }
}
