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
    weak var viewController: UIViewController?
    
    static func setupModule() -> GetStartedViewController {
        let vc = GetStartedViewController()
        let interactor = GetStartedInteractor()
        let router = GetStartedRouter()
        let presenter = GetStartedPresenter(
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

extension GetStartedRouter: GetStartedRouterInterface {
    func openWelcome() {
        let welcomeViewController = WelcomeRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
}
