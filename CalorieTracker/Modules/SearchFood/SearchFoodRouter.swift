//
//  SearchFoodRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 23.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation
import UIKit

protocol SearchFoodRouterInterface: AnyObject {

}

class SearchFoodRouter: NSObject {

    weak var presenter: SearchFoodPresenterInterface?

    static func setupModule() -> SearchFoodViewController {
        let vc = SearchFoodViewController()
        let interactor = SearchFoodInteractor()
        let router = SearchFoodRouter()
        let presenter = SearchFoodPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension SearchFoodRouter: SearchFoodRouterInterface {}
