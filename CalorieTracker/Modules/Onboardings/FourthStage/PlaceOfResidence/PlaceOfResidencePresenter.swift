//
//  PlaceOfResidencePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol PlaceOfResidencePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class PlaceOfResidencePresenter {
    
    // MARK: - Public properties

    unowned var view: PlaceOfResidenceViewControllerInterface
    let router: PlaceOfResidenceRouterInterface?
    let interactor: PlaceOfResidenceInteractorInterface?
    
    // MARK: - Private properties

    private var placeOfResidence: [PlaceOfResidence] = []

    // MARK: - Initialization
    
    init(
        interactor: PlaceOfResidenceInteractorInterface,
        router: PlaceOfResidenceRouterInterface,
        view: PlaceOfResidenceViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PlaceOfResidencePresenterInterface

extension PlaceOfResidencePresenter: PlaceOfResidencePresenterInterface {
    func viewDidLoad() {
        placeOfResidence = interactor?.getAllPlaceOfResidence() ?? []
        
        view.set(placeOfResidence: placeOfResidence)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(placeOfResidence: .inRuralArea)
        router?.openEnvironmentInfluencesTheChoice()
    }
}
