//
//  RecipesSearchRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol FilterSelectionIncoming {
    func tagsSelected(tags: [SelectedTagsCell.TagType])
}

protocol RecipesSearchRouterInterface: AnyObject {
    func showFiltersScreen()
    func showRecipeScreen(with dish: Dish)
}

class RecipesSearchRouter: NSObject {

    weak var presenter: RecipesSearchPresenterInterface?
    private var navigationController: UINavigationController?
    
    static func setupModule(
        with navigationController: UINavigationController?,
        and dishesPool: [Dish]
    ) -> RecipesSearchViewController {
        let vc = RecipesSearchViewController()
        let interactor = RecipesSearchInteractor(with: dishesPool)
        let router = RecipesSearchRouter()
        let presenter = RecipesSearchPresenter(interactor: interactor, router: router, view: vc)
        router.navigationController = navigationController
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RecipesSearchRouter: RecipesSearchRouterInterface {
    func showFiltersScreen() {
        let filtersVC = RecipesFilterScreenRouter.setupModule(
            with: self,
            selectedTags: presenter?.getSelectedTags() ?? []
        )
        navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    func showRecipeScreen(with dish: Dish) {
        let recipeScreenModule = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Search".localized
        )
        recipeScreenModule.modalPresentationStyle = .fullScreen
        navigationController?.present(recipeScreenModule, animated: true)
        LoggingService.postEvent(event: .recipeopenfromsearch)
    }
}

extension RecipesSearchRouter: RecipesFilterScreenRouterOutput {
    func filtersDidSelected(with tags: [SelectedTagsCell.TagType]) {
        presenter?.setFilterTags(tags: tags)
    }
}
