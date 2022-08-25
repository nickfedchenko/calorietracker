//
//  LastCalorieCountPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol LastCalorieCountPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectLastCalorieCount(with index: Int)
    func didDeselectLastCalorieCount()
}

class LastCalorieCountPresenter {
    
    // MARK: - Public properties

    unowned var view: LastCalorieCountViewControllerInterface
    let router: LastCalorieCountRouterInterface?
    let interactor: LastCalorieCountInteractorInterface?

    // MARK: - Private properties

    private var lastCalorieCount: [LastCalorieCount] = []
    private var lastCalorieCountIndex: Int?
    
    // MARK: - Initialization

    init(
        interactor: LastCalorieCountInteractorInterface,
        router: LastCalorieCountRouterInterface,
        view: LastCalorieCountViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - LastCalorieCountPresenterInterface

extension LastCalorieCountPresenter: LastCalorieCountPresenterInterface {
    func viewDidLoad() {
        lastCalorieCount = interactor?.getAllLastCalorieCount() ?? []
        
        view.set(lastCalorieCount: lastCalorieCount)
    }

    func didTapNextCommonButton() {
        interactor?.set(lastCalorieCount: .usingAnApp)
        router?.openCalorieCount()
    }
    
    func didSelectLastCalorieCount(with index: Int) {
        lastCalorieCountIndex = index
    }
    
    func didDeselectLastCalorieCount() {
        lastCalorieCountIndex = nil
    }
}
