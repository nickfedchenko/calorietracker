//
//  PreviousApplicationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol PreviousApplicationPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectPreviousApplication(with index: Int)
    func didDeselectPreviousApplication()
}

class PreviousApplicationPresenter {
    
    // MARK: - Public properties

    unowned var view: PreviousApplicationViewControllerInterface
    let router: PreviousApplicationRouterInterface?
    let interactor: PreviousApplicationInteractorInterface?

    // MARK: - Private properties

    private var previousApplication: [PreviousApplication] = []
    private var previousApplicationIndex: Int?
    
    // MARK: - Initialization

    init(
        interactor: PreviousApplicationInteractorInterface,
        router: PreviousApplicationRouterInterface,
        view: PreviousApplicationViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PreviousApplicationPresenter

extension PreviousApplicationPresenter: PreviousApplicationPresenterInterface {
    func viewDidLoad() {
        previousApplication = interactor?.getAllPreviousApplication() ?? []
        
        view.set(previousApplication: previousApplication)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapNextCommonButton() {
        interactor?.set(previousApplication: .myFitnessPal)
        router?.openObsessingOverFood()
    }
    
    func didSelectPreviousApplication(with index: Int) {
        previousApplicationIndex = index
    }
    
    func didDeselectPreviousApplication() {
        previousApplicationIndex = nil
    }
}
