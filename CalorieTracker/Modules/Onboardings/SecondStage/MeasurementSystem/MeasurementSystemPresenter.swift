//
//  MeasurementSystemPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol MeasurementSystemPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
    func didSelectMeasurementSystem(with index: Int)
    func didDeselectMeasurementSystem()
}

class MeasurementSystemPresenter {
    
    // MARK: - Public properties

    unowned var view: MeasurementSystemViewControllerInterface
    let router: MeasurementSystemRouterInterface?
    let interactor: MeasurementSystemInteractorInterface?
    
    // MARK: - Private properties
    
    private var measurementSystem: [MeasurementSystem] = []
    private var measurementSystemIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: MeasurementSystemInteractorInterface,
        router: MeasurementSystemRouterInterface,
        view: MeasurementSystemViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MeasurementSystemPresenterInterface

extension MeasurementSystemPresenter: MeasurementSystemPresenterInterface {
    func viewDidLoad() {
        measurementSystem = interactor?.getAllMeasurementSystem() ?? []
        
        view.set(measurementSystem: measurementSystem)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(measurementSystem: .metricSystem)
        router?.openDateOfBirth()
    }
    
    func didSelectMeasurementSystem(with index: Int) {
        measurementSystemIndex = index
    }
    
    func didDeselectMeasurementSystem() {
        measurementSystemIndex = nil
    }
}
