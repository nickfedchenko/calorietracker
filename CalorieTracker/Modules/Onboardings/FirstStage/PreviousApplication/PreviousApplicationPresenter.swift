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
    
    unowned var view: PreviousApplicationViewControllerInterface
    let router: PreviousApplicationRouterInterface?
    let interactor: PreviousApplicationInteractorInterface?

    private var previousApplication: [PreviousApplication] = []
    private var previousApplicationIndex: Int?
    
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

extension PreviousApplicationPresenter: PreviousApplicationPresenterInterface {
    func viewDidLoad() {
        previousApplication = interactor?.getAllPreviousApplication() ?? []
        
        view.set(previousApplication: previousApplication)
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
