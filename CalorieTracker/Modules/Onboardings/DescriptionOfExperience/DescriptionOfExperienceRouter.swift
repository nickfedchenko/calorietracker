//
//  DescriptionOfExperienceRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol DescriptionOfExperienceRouterInterface: AnyObject {
    func openPurposeOfTheParish()
}

class DescriptionOfExperienceRouter: NSObject {
    
    weak var presenter: DescriptionOfExperiencePresenterInterface?
    
    static func setupModule() -> DescriptionOfExperienceViewController {
        let vc = DescriptionOfExperienceViewController()
        let interactor = DescriptionOfExperienceInteractor()
        let router = DescriptionOfExperienceRouter()
        let presenter = DescriptionOfExperiencePresenter(
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

extension DescriptionOfExperienceRouter: DescriptionOfExperienceRouterInterface {
    func openPurposeOfTheParish() {}
}
