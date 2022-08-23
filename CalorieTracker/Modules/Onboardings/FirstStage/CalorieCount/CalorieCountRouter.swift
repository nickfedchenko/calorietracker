//
//  CalorieCountRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol CalorieCountRouterInterface: AnyObject {
    func openPreviousApplication()
}

class CalorieCountRouter: NSObject {
    
    weak var presenter: CalorieCountPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> CalorieCountViewController {
        let vc = CalorieCountViewController()
        let interactor = CalorieCountInteractor()
        let router = CalorieCountRouter()
        let presenter = CalorieCountPresenter(
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

extension CalorieCountRouter: CalorieCountRouterInterface {
    func openPreviousApplication() {
        let previousApplicationRouter = PreviousApplicationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(previousApplicationRouter, animated: true)
    }
}
