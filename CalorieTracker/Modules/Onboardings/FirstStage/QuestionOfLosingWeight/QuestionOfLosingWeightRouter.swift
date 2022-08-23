//
//  QuestionOfLosingWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

protocol QuestionOfLosingWeightRouterInterface: AnyObject {
    func openDescriptionOfExperience()
}

class QuestionOfLosingWeightRouter: NSObject {
    
    weak var presenter: QuestionOfLosingWeightPresenterInterface?
    weak var viewController: UIViewController?
    
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
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension QuestionOfLosingWeightRouter: QuestionOfLosingWeightRouterInterface {
    func openDescriptionOfExperience() {
        let descriptionOfExperienceRouter = DescriptionOfExperienceRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(descriptionOfExperienceRouter, animated: true)
    }
}
