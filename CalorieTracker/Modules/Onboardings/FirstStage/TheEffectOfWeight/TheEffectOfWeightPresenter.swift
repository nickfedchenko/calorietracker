//
//  TheEffectOfWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol TheEffectOfWeightPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectTheEffectOfWeight(with index: Int)
    func didDeselectTheEffectOfWeight()
}

class TheEffectOfWeightPresenter {
    
    // MARK: - Public properties

    unowned var view: TheEffectOfWeightViewControllerInterface
    let router: TheEffectOfWeightRouterInterface?
    let interactor: TheEffectOfWeightInteractorInterface?

    // MARK: - Private properties

    private var theEffectOfWeight: [TheEffectOfWeight] = []
    private var theEffectOfWeightIndex: Int?
    
    // MARK: - Initialization

    init(
        interactor: TheEffectOfWeightInteractorInterface,
        router: TheEffectOfWeightRouterInterface,
        view: TheEffectOfWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ObsessingOverFoodPresenterInterface

extension TheEffectOfWeightPresenter: TheEffectOfWeightPresenterInterface {
    func viewDidLoad() {
        theEffectOfWeight = interactor?.getAllTheEffectOfWeight() ?? []
        
        view.set(theEffectOfWeight: theEffectOfWeight)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapNextCommonButton() {
        interactor?.set(theEffectOfWeight: .noNotReall)
        router?.openFormationGoodHabits()
    }
    
    func didSelectTheEffectOfWeight(with index: Int) {
        theEffectOfWeightIndex = index
    }
    
    func didDeselectTheEffectOfWeight() {
        theEffectOfWeightIndex = nil
    }
}
