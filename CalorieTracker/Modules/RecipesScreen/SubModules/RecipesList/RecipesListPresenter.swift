//
//  RecipesListPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesListPresenterInterface: AnyObject {
    func getTitleForHeader() -> String
    func getNumberOfItemsInSection() -> Int
    func getDishModel(at indexPath: IndexPath) -> Dish?
    func backButtonTapped()
    func searchButtonTapped()
    func getAllDishes() -> [Dish]
    func didSelectRecipe(at indexPath: IndexPath)
}

class RecipesListPresenter {

    unowned var view: RecipesListViewControllerInterface
    let router: RecipesListRouterInterface?
    let interactor: RecipesListInteractorInterface?

    init(
        interactor: RecipesListInteractorInterface,
        router: RecipesListRouterInterface,
        view: RecipesListViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RecipesListPresenter: RecipesListPresenterInterface {
    func didSelectRecipe(at indexPath: IndexPath) {
        guard let dish = interactor?.getDishModel(at: indexPath) else { return }
        router?.showRecipeScreen(with: dish)
    }
    
    func getAllDishes() -> [Dish] {
        interactor?.getAllDishes() ?? []
    }
    
    func getTitleForHeader() -> String {
        interactor?.getTitleForHeader() ?? ""
    }
    
    func getNumberOfItemsInSection() -> Int {
        interactor?.getNumberOfItems() ?? 0
    }
    
    func getDishModel(at indexPath: IndexPath) -> Dish? {
        interactor?.getDishModel(at: indexPath)
    }
    
    func backButtonTapped() {
        router?.backButtonTapped()
    }
    
    func searchButtonTapped() {
        router?.showSearchController()
    }
}