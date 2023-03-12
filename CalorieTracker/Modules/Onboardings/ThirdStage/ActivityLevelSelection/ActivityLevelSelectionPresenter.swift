//
//  ActivityLevelSelectionPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.02.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol ActivityLevelSelectionPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton(with selectedActivityLevel: ActivityLevel)
}

class ActivityLevelSelectionPresenter {

    unowned var view: ActivityLevelSelectionViewControllerInterface
    let router: ActivityLevelSelectionRouterInterface?
    let interactor: ActivityLevelSelectionInteractorInterface?
    private var activityLevels: [ActivityLevel] = []
    
    init(
        interactor: ActivityLevelSelectionInteractorInterface,
        router: ActivityLevelSelectionRouterInterface,
        view: ActivityLevelSelectionViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ActivityLevelSelectionPresenter: ActivityLevelSelectionPresenterInterface {
    func viewDidLoad() {
        activityLevels = interactor?.getPossibleActivityLevels() ?? []
        
        view.set(activityLevels: activityLevels)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton(with selectedActivityLevel: ActivityLevel) {
        interactor?.set(selectedActivityLevel: selectedActivityLevel)
        router?.navigateNext()
    }
}
