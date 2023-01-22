//
//  RecipePageScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 12.01.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipePageScreenRouterInterface: AnyObject {

}

class RecipePageScreenRouter: NSObject {

    weak var presenter: RecipePageScreenPresenterInterface?

    static func setupModule(with dish: Dish, backButtonTitle: String) -> RecipePageScreenViewController {
        let vc = RecipePageScreenViewController(backButtonTitle: backButtonTitle)
        let interactor = RecipePageScreenInteractor(with: dish)
        let router = RecipePageScreenRouter()
        let presenter = RecipePageScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RecipePageScreenRouter: RecipePageScreenRouterInterface {

}
