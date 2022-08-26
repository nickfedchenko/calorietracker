//
//  MeasurementSystemRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import UIKit

protocol MeasurementSystemRouterInterface: AnyObject {}

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

extension MeasurementSystemRouter: MeasurementSystemRouterInterface {}
