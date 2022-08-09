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
    func numberOfSections() -> Int {
        interactor?.getNumberOfSections() ?? 0
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return interactor?.getNumberOfItemInSection(section: section) ?? 0
    }
}
