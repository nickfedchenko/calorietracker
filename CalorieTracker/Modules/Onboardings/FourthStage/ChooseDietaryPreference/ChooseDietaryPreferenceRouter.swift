//
//  ChooseDietaryPreferenceRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 02.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseDietaryPreferenceRouterInterface: AnyObject {
    func navigateNext()
}

class ChooseDietaryPreferenceRouter: NSObject {

    weak var presenter: ChooseDietaryPreferencePresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ChooseDietaryPreferenceViewController {
        let vc = ChooseDietaryPreferenceViewController()
        let interactor = ChooseDietaryPreferenceInteractor(onboardingManager: OnboardingManager.shared)
        let router = ChooseDietaryPreferenceRouter()
        let presenter = ChooseDietaryPreferencePresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension ChooseDietaryPreferenceRouter: ChooseDietaryPreferenceRouterInterface {
    func navigateNext() {
        let soundsGoodRouter = SoundsGoodRouter.setupModule()
        viewController?.navigationController?.pushViewController(
            soundsGoodRouter,
            animated: true
        )
    }
}
