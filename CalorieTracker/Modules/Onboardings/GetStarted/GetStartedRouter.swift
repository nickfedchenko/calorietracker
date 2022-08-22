//
//  GetStartedRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

protocol GetStartedRouterInterface: AnyObject {
    func openWelcome()
}

class GetStartedRouter: NSObject {
    
    weak var presenter: GetStartedPresenterInterface?
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func setupModule() -> GetStartedViewController {
        let vc = GetStartedViewController()
        let interactor = GetStartedInteractor()
        let router = GetStartedRouter(navigationController: vc.navigationController)
        let presenter = GetStartedPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension GetStartedRouter: GetStartedRouterInterface {
    func openWelcome() {
//        WelcomeRouter.setupModule()
        navigationController?.pushViewController(WelcomeViewController(), animated: true)
    }
}
