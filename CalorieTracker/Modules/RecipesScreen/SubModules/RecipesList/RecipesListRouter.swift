//
//  RecipesListRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesListRouterInterface: AnyObject {
    func backButtonTapped()
    func showSearchController()
    func showRecipeScreen(with dish: Dish)
}

class RecipesListRouter: NSObject {

    weak var presenter: RecipesListPresenterInterface?
    var navigationController: UINavigationController?
    
    static func setupModule(
        with section: RecipeSectionModel,
        navigationController: UINavigationController?
    ) -> RecipesListViewController {
        let vc = RecipesListViewController()
        let interactor = RecipesListInteractor(with: section)
        let router = RecipesListRouter()
        let presenter = RecipesListPresenter(interactor: interactor, router: router, view: vc)
        router.navigationController = navigationController
        navigationController?.delegate = router
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RecipesListRouter: RecipesListRouterInterface {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSearchController() {
        let dishes = presenter?.getAllDishes() ?? []
        let searchVC = RecipesSearchRouter.setupModule(
            with: navigationController,
            and: dishes
        )
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension RecipesListRouter: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            guard fromVC is RecipesListViewController else { return nil }
            let animator = PushAnimationTransitioningController(fromViewController: fromVC, toViewController: toVC)
            return animator
        } else {
            guard fromVC is RecipesSearchViewController else { return nil }
            let animator = PopAnimationTransitioningController(fromViewController: fromVC, toViewController: toVC)
            return animator
        }
    }
    
    func showRecipeScreen(with dish: Dish) {
        let recipeScreenModule = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: presenter?.getTitleForHeader() ?? ""
        )
        recipeScreenModule.modalPresentationStyle = .fullScreen
        navigationController?.present(recipeScreenModule, animated: true)
    }
}
