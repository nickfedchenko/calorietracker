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
    func dismiss()
}

class RecipePageScreenRouter: NSObject {

    weak var view: RecipePageScreenViewController?
    weak var presenter: RecipePageScreenPresenterInterface?
    var addToDiaryHandler: ((Food) -> Void)?
    
    static func setupModule(
        with dish: Dish,
        backButtonTitle: String,
        addToDiaryHandler: ((Food) -> Void)? = nil
    ) -> RecipePageScreenViewController {
        let vc = RecipePageScreenViewController(backButtonTitle: backButtonTitle)
        let interactor = RecipePageScreenInteractor(with: dish)
        let router = RecipePageScreenRouter()
        let presenter = RecipePageScreenPresenter(interactor: interactor, router: router, view: vc)
        vc.presenter = presenter
        router.presenter = presenter
        router.view = vc
        router.addToDiaryHandler = addToDiaryHandler
        interactor.presenter = presenter
        return vc
    }
}

extension RecipePageScreenRouter: RecipePageScreenRouterInterface {
    func dismiss() {
        // TODO: //
        if let dish = presenter?.getDish(),
           let handler = addToDiaryHandler {
            handler(.dishes(dish, customAmount: presenter?.getPossibleEatenAmount()))
        } else {
            presenter?.shouldAddToEatenSelectedPortions()
        }
        if view?.navigationController != nil {
            view?.navigationController?.popViewController(animated: true)
        } else {
            view?.dismiss(animated: true)
        }
    }
}
