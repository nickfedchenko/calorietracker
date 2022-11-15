//
//  FoodViewingRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation
import UIKit

protocol FoodViewingRouterInterface: AnyObject {

}

class FoodViewingRouter: NSObject {

    weak var presenter: FoodViewingPresenterInterface?

    static func setupModule() -> FoodViewingViewController {
        let vc = FoodViewingViewController()
        let interactor = FoodViewingInteractor()
        let router = FoodViewingRouter()
        let presenter = FoodViewingPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension FoodViewingRouter: FoodViewingRouterInterface {

}