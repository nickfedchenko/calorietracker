//
//  PurposeOfTheParishPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectPurposeOfTheParish(with index: Int)
    func didDeselectPurposeOfTheParish()
}

class PurposeOfTheParishPresenter {
    
    unowned var view: PurposeOfTheParishViewControllerInterface
    let router: PurposeOfTheParishRouterInterface?
    let interactor: PurposeOfTheParishInteractorInterface?
    
    private var purposeOfTheParish: [PurposeOfTheParish] = []
    private var purposeOfTheParishIndex: Int?

    init(
        interactor: PurposeOfTheParishInteractorInterface,
        router: PurposeOfTheParishRouterInterface,
        view: PurposeOfTheParishViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension PurposeOfTheParishPresenter: PurposeOfTheParishPresenterInterface {
    func viewDidLoad() {
        purposeOfTheParish = interactor?.getAllPurposeOfTheParish() ?? []
        
        view.set(purposeOfTheParish: purposeOfTheParish)
    }
    
    func didTapNextCommonButton() {
        interactor?.set(purposeOfTheParish: .thisTimeToGetBackToHealthyHabits)
        router?.openRecentWeightChanges()
    }
    
    func didSelectPurposeOfTheParish(with index: Int) {
        purposeOfTheParishIndex = index
    }
    
    func didDeselectPurposeOfTheParish() {
        purposeOfTheParishIndex = nil
    }
}
