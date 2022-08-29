//
//  MeasurementSystemRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import UIKit

protocol MeasurementSystemRouterInterface: AnyObject {
    func openDateOfBirth()
}

class MeasurementSystemRouter {
    
    // MARK: - Public properties
    
    weak var presenter: MeasurementSystemPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> MeasurementSystemViewController {
        let vc = MeasurementSystemViewController()
        let interactor = MeasurementSystemInteractor(onboardingManager: OnboardingManager.shared)
        let router = MeasurementSystemRouter()
        let presenter = MeasurementSystemPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - MeasurementSystemRouterInterface

extension MeasurementSystemRouter: MeasurementSystemRouterInterface {
    func openDateOfBirth() {
        let dateOfBirthRouter = DateOfBirthRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(dateOfBirthRouter, animated: true)
    }
}
