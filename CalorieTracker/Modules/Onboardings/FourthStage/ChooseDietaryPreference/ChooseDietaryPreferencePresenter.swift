//
//  ChooseDietaryPreferencePresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 02.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol ChooseDietaryPreferencePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton(with selectedDietary: UserDietary)
}

class ChooseDietaryPreferencePresenter {

    unowned var view: ChooseDietaryPreferenceViewControllerInterface
    let router: ChooseDietaryPreferenceRouterInterface?
    let interactor: ChooseDietaryPreferenceInteractorInterface?

    init(
        interactor: ChooseDietaryPreferenceInteractorInterface,
        router: ChooseDietaryPreferenceRouterInterface,
        view: ChooseDietaryPreferenceViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ChooseDietaryPreferencePresenter: ChooseDietaryPreferencePresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton(with selectedDietary: UserDietary) {
        interactor?.setSelectedDietary(dietary: selectedDietary)
        router?.navigateNext()
    }
}
