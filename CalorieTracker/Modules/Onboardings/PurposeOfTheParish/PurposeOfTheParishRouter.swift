//
//  PurposeOfTheParishRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishRouterInterface: AnyObject {
    func openRecentWeightChanges()
}

class PurposeOfTheParishRouter: NSObject {
    
    weak var presenter: PurposeOfTheParishPresenterInterface?
    
    static func setupModule() -> PurposeOfTheParishViewController {
        let vc = PurposeOfTheParishViewController()
        let interactor = PurposeOfTheParishInteractor()
        let router = PurposeOfTheParishRouter()
        let presenter = PurposeOfTheParishPresenter(
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

extension PurposeOfTheParishRouter: PurposeOfTheParishRouterInterface {
    func openRecentWeightChanges() {}
}
