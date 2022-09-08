//
//  WhatsYourGenderPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import Foundation

protocol WhatsYourGenderPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
    func didSelectWhatsYourGender(with index: Int)
    func didDeselectWhatsYourGender()
}

class WhatsYourGenderPresenter {
    
    // MARK: - Public properties

    unowned var view: WhatsYourGenderViewControllerInterface
    let router: WhatsYourGenderRouterInterface?
    let interactor: WhatsYourGenderInteractorInterface?
    
    // MARK: - Private properties

    private var whatsYourGender: [WhatsYourGender] = []
    private var whatsYourGenderIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: WhatsYourGenderInteractorInterface,
        router: WhatsYourGenderRouterInterface,
        view: WhatsYourGenderViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - WhatsYourGenderPresenterInterface

extension WhatsYourGenderPresenter: WhatsYourGenderPresenterInterface {
    func viewDidLoad() {
        whatsYourGender = interactor?.getAllWhatsYourGender() ?? []
        
        view.set(whatsYourGender: whatsYourGender)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(whatsYourGender: .male)
        router?.openMeasurementSystem()
    }
    
    func didSelectWhatsYourGender(with index: Int) {
        whatsYourGenderIndex = index
    }
    
    func didDeselectWhatsYourGender() {
        whatsYourGenderIndex = nil
    }
}
