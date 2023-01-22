//
//  RecipesFilterScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 27.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesFilterScreenRouterInterface: AnyObject {
    func shouldNavigateBackWith(selected tags: [SelectedTagsCell.TagType])
}

protocol RecipesFilterScreenRouterOutput: AnyObject {
    func filtersDidSelected(with tags: [SelectedTagsCell.TagType])
}

class RecipesFilterScreenRouter: NSObject {

    weak var presenter: RecipesFilterScreenPresenterInterface?
    weak var filtersOutput: RecipesFilterScreenRouterOutput?
    
    static func setupModule(
        with output: RecipesFilterScreenRouterOutput,
        selectedTags: [SelectedTagsCell.TagType] = []
    ) -> RecipesFilterScreenViewController {
        let vc = RecipesFilterScreenViewController()
        let interactor = RecipesFilterScreenInteractor(with: selectedTags)
        let router = RecipesFilterScreenRouter()
        let presenter = RecipesFilterScreenPresenter(interactor: interactor, router: router, view: vc)
        router.filtersOutput = output
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension RecipesFilterScreenRouter: RecipesFilterScreenRouterInterface {
    func shouldNavigateBackWith(selected tags: [SelectedTagsCell.TagType]) {
        filtersOutput?.filtersDidSelected(with: tags)
    }
}
