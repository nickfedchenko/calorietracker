//
//  ImportanceOfWeightLossPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ImportanceOfWeightLossPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class ImportanceOfWeightLossPresenter {
    
    // MARK: - Public properties

    unowned var view: ImportanceOfWeightLossViewControllerInterface
    let router: ImportanceOfWeightLossRouterInterface?
    let interactor: ImportanceOfWeightLossInteractorInterface?
    
    // MARK: - Private properties

    private var importanceOfWeightLoss: [ImportanceOfWeightLoss] = []
    private var importanceOfWeightLossIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: ImportanceOfWeightLossInteractorInterface,
        router: ImportanceOfWeightLossRouterInterface,
        view: ImportanceOfWeightLossViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ImportanceOfWeightLossPresenterInterface

extension ImportanceOfWeightLossPresenter: ImportanceOfWeightLossPresenterInterface {
    func viewDidLoad() {
        importanceOfWeightLoss = interactor?.getAllImportanceOfWeightLoss() ?? []
        
        view.set(importanceOfWeightLoss: importanceOfWeightLoss)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(importanceOfWeightLoss: .itIsVeryImportant)
        router?.openChoseYourGoalRouter()
    }
}
