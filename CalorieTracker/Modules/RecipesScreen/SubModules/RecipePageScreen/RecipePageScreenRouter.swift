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
    func dismissToCreateMeal()
}

class RecipePageScreenRouter: NSObject {

    weak var view: RecipePageScreenViewController?
    weak var presenter: RecipePageScreenPresenterInterface?
    var addToDiaryHandler: ((Food) -> Void)?
    
    static func setupModule(
        with dish: Dish,
        backButtonTitle: String,
        openController: RecipePageScreenViewController.OpenController? = .addToDiary,
        addToDiaryHandler: ((Food) -> Void)? = nil
    ) -> RecipePageScreenViewController {
        let vc = RecipePageScreenViewController(backButtonTitle: backButtonTitle, openController: openController)
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
        if let dish = presenter?.getDish(),
           let handler = addToDiaryHandler {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                handler(.dishes(dish, customAmount: self?.presenter?.getPossibleEatenAmount()))
                LoggingService.postEvent(event: .recipeaddtodiary)
            }
        } else {
            presenter?.shouldAddToEatenSelectedPortions()
        }
        if view?.navigationController != nil {
            view?.navigationController?.popViewController(animated: true)
        } else {
            view?.dismiss(animated: true)
        }
    }
    
    func dismissToCreateMeal() {
        view?.dismiss(animated: false) { [weak self] in
            guard let dish = self?.presenter?.getDish() else { return }
            self?.addToDiaryHandler?(.dishes(dish, customAmount: self?.presenter?.getPossibleEatenAmount()))
        }
    }
}
