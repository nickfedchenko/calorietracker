//
//  EmotionalSupportSystemPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol EmotionalSupportSystemPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class EmotionalSupportSystemPresenter {
    
    // MARK: - Public properties

    unowned var view: EmotionalSupportSystemViewControllerInterface
    let router: EmotionalSupportSystemRouterInterface?
    let interactor: EmotionalSupportSystemInteractorInterface?
    
    // MARK: - Private properties

    private var emotionalSupportSystem: [EmotionalSupportSystem] = []

    // MARK: - Initialization
    
    init(
        interactor: EmotionalSupportSystemInteractorInterface,
        router: EmotionalSupportSystemRouterInterface,
        view: EmotionalSupportSystemViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - EmotionalSupportSystemPresenterInterface

extension EmotionalSupportSystemPresenter: EmotionalSupportSystemPresenterInterface {
    func viewDidLoad() {
        emotionalSupportSystem = interactor?.getAllEmotionalSupportSystem() ?? []
        
        view.set(emotionalSupportSystem: emotionalSupportSystem)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(emotionalSupportSystem: .dontUsuallyNeedSupportSystem)
        router?.openlifestyleOfOthers()
    }
}
