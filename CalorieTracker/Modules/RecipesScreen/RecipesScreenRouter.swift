//
//  RecipesScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesScreenRouterInterface: AnyObject {

}

class RecipesScreenRouter: NSObject {

    weak var presenter: RecipesScreenPresenterInterface?

    static func setupModule() -> RecipesScreenViewController {
        let vc = RecipesScreenViewController()
        let interactor = RecipesScreenInteractor()
        let router = RecipesScreenRouter()
        let presenter = RecipesScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
    
}

extension RecipesScreenRouter: RecipesScreenRouterInterface {

}
