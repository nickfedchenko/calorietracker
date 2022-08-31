//
//  SoundsGoodRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol SoundsGoodRouterInterface: AnyObject {
    func openDescriptionOfCulinarySkills()
}

class SoundsGoodRouter {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsGoodPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> SoundsGoodViewController {
        let vc = SoundsGoodViewController()
        let interactor = SoundsGoodInteractor()
        let router = SoundsGoodRouter()
        let presenter = SoundsGoodPresenter(
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

// MARK: - SoundsGoodRouterInterface

extension SoundsGoodRouter: SoundsGoodRouterInterface {
    func openDescriptionOfCulinarySkills() {
        let descriptionOfCulinarySkillsRouter = DescriptionOfCulinarySkillsRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            descriptionOfCulinarySkillsRouter,
            animated: true
        )
    }
}
