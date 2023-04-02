//
//  RecipesScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesScreenPresenterInterface: AnyObject {
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func notifySectionsUpdated(sectionUpdated: Int, shouldRemoveActivity: Bool)
    func askForSections()
    func getDishModel(at index: IndexPath) -> LightweightRecipeModel?
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel?
    func didTapSectionHeader(at index: Int)
    func didTapRecipe(at index: IndexPath)
    func updateFavorites()
}

class RecipesScreenPresenter {
    
    unowned var view: RecipesScreenViewControllerInterface
    let router: RecipesScreenRouterInterface?
    let interactor: RecipesScreenInteractorInterface?
    
    init(
        interactor: RecipesScreenInteractorInterface,
        router: RecipesScreenRouterInterface,
        view: RecipesScreenViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RecipesScreenPresenter: RecipesScreenPresenterInterface {
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel? {
        interactor?.getSectionModel(at: indexPath)
    }
    
    func notifySectionsUpdated(sectionUpdated: Int, shouldRemoveActivity: Bool) {
        if Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.view.shouldReloadDishesCollection(in: sectionUpdated, shouldRemoveActivity: shouldRemoveActivity)
            }
        } else {
            DispatchQueue.main.sync { [weak self] in
                self?.view.shouldReloadDishesCollection(in: sectionUpdated, shouldRemoveActivity: shouldRemoveActivity)
            }
        }
    }
    
    func numberOfSections() -> Int {
        interactor?.getNumberOfSections() ?? 0
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return interactor?.getNumberOfItemInSection(section: section) ?? 0
    }
    
    func askForSections() {
        interactor?.requestUpdateSections()
    }
    
    func getDishModel(at index: IndexPath) -> LightweightRecipeModel? {
        interactor?.getDishModel(at: index)
    }
    
    func didTapSectionHeader(at index: Int) {
        if let sectionModel = interactor?.getSectionModel(at: IndexPath(item: 0, section: index)) {
            router?.navigateToRecipesList(for: sectionModel)
        }
    }
    
    func didTapRecipe(at index: IndexPath) {
        guard let dish = interactor?.getDishModel(at: index) else { return }
        if  let dishProper = FDS.shared.getDish(by: String(dish.id)) {
            router?.showRecipeScreen(with: dishProper)
        }
    }
    
    func updateFavorites() {
        interactor?.updateFavoritesSection()
    }
}
