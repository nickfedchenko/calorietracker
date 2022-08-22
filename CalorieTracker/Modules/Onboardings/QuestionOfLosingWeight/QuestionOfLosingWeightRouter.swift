//
//  QuestionOfLosingWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol QuestionOfLosingWeightRouterInterface: AnyObject {
    func openDescriptionOfExperience()
}

class QuestionOfLosingWeightRouter: NSObject {
    
    weak var presenter: QuestionOfLosingWeightPresenterInterface?
    
    static func setupModule() -> QuestionOfLosingWeightViewController {
        let vc = QuestionOfLosingWeightViewController()
        let interactor = QuestionOfLosingWeightInteractor()
        let router = QuestionOfLosingWeightRouter()
        let presenter = QuestionOfLosingWeightPresenter(
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

extension QuestionOfLosingWeightRouter: QuestionOfLosingWeightRouterInterface {
    func openDescriptionOfExperience() {}
}
