//
//  YourHeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol YourHeightRouterInterface: AnyObject {
    func openYourWeight()
}

class YourHeightRouter {
    
    // MARK: - Public properties
    
    weak var presenter: YourHeightPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> YourHeightViewController {
        let vc = YourHeightViewController()
        let interactor = YourHeightInteractor()
        let router = YourHeightRouter()
        let presenter = YourHeightPresenter(
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

extension YourHeightRouter: YourHeightRouterInterface {
    func openYourWeight() {
        let yourWeightRouter = YourWeightRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(yourWeightRouter, animated: true)
    }
}
