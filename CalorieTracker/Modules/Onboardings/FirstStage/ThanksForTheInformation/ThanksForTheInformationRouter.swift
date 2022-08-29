//
//  ThanksForTheInformationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol ThanksForTheInformationRouterInterface: AnyObject {
    func openFinalOfTheFirstStage()
}

class ThanksForTheInformationRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: ThanksForTheInformationPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ThanksForTheInformationViewController {
        let vc = ThanksForTheInformationViewController()
        let interactor = ThanksForTheInformationInteractor()
        let router = ThanksForTheInformationRouter()
        let presenter = ThanksForTheInformationPresenter(
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

// MARK: - ThanksForTheInformationRouterInterface

extension ThanksForTheInformationRouter: ThanksForTheInformationRouterInterface {
    func openFinalOfTheFirstStage() {
        let finalOfTheFirstStageRouter = FinalOfTheFirstStageRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(finalOfTheFirstStageRouter, animated: true)
    }
}