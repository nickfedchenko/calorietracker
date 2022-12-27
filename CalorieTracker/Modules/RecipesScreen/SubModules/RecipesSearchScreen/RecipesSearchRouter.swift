//
//  RecipesSearchRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesSearchRouterInterface: AnyObject {

}

class RecipesSearchRouter: NSObject {

    weak var presenter: RecipesSearchPresenterInterface?

    static func setupModule() -> RecipesSearchViewController {
        let vc = RecipesSearchViewController()
        let interactor = RecipesSearchInteractor()
        let router = RecipesSearchRouter()
        let presenter = RecipesSearchPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RecipesSearchRouter: RecipesSearchRouterInterface {

}
