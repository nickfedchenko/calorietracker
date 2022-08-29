//
//  RisksOfDiseasesPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol RisksOfDiseasesPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class RisksOfDiseasesPresenter {
    
    // MARK: - Public properties

    unowned var view: RisksOfDiseasesViewControllerInterface
    let router: RisksOfDiseasesRouterInterface?
    let interactor: RisksOfDiseasesInteractorInterface?
    
    // MARK: - Private properties
    
    private var risksOfDiseases: [RisksOfDiseases] = []
    private var risksOfDiseasesIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: RisksOfDiseasesInteractorInterface,
        router: RisksOfDiseasesRouterInterface,
        view: RisksOfDiseasesViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RisksOfDiseasesPresenter: RisksOfDiseasesPresenterInterface {
    func viewDidLoad() {
        risksOfDiseases = interactor?.getAllRisksOfDiseases() ?? []
        
        view.set(risksOfDiseases: risksOfDiseases)
    }
    
    func didTapContinueCommonButton() {
        router?.openPresenceOfAllergies()
    }
}
