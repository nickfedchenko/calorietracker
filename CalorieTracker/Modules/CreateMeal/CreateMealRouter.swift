//
//  CreateMealRouter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation
import UIKit

protocol CreateMealRouterInterface: AnyObject {

}

class CreateMealRouter: NSObject {

    weak var presenter: CreateMealPresenterInterface?

    static func setupModule() -> CreateMealViewController {
        let vc = CreateMealViewController()
        let interactor = CreateMealInteractor()
        let router = CreateMealRouter()
        let presenter = CreateMealPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension CreateMealRouter: CreateMealRouterInterface {

}