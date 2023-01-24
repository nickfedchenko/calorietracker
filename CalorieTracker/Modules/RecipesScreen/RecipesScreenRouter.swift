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
    func navigateToRecipesList(for section: RecipeSectionModel)
    func showRecipeScreen(with dish: Dish)
}

class RecipesScreenRouter: NSObject {

    weak var presenter: RecipesScreenPresenterInterface?
    var navigationController: UINavigationController?

    static func setupModule() -> UIViewController {
        let vc = RecipesScreenViewController()
        let interactor = RecipesScreenInteractor()
        let router = RecipesScreenRouter()
        let presenter = RecipesScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        let navigationController = UINavigationController(rootViewController: vc)
        router.navigationController = navigationController
        return navigationController
    }
}

extension RecipesScreenRouter: RecipesScreenRouterInterface {
    func navigateToRecipesList(for section: RecipeSectionModel) {
        let vc = RecipesListRouter.setupModule(with: section, navigationController: navigationController)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showRecipeScreen(with dish: Dish) {
        let recipeScreenModule = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Recipes".localized
        )
        recipeScreenModule.modalPresentationStyle = .fullScreen
        navigationController?.present(recipeScreenModule, animated: true)
    }
}
