//
//  RecipesSearchPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesSearchPresenterInterface: AnyObject {
    func didFinishSearchWork(with dishes: [Dish])
    func getNumberOfItemsInSection() -> Int
    func addFilterTag(tag: AdditionalTag.ConvenientTag)
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag)
    func removeFilterTag(tag: AdditionalTag.ConvenientTag)
    func removeExceptionTag(tag: ExceptionTag.ConvenientExceptionTag)
    func performSearch(with phrase: String?)
}

class RecipesSearchPresenter {

    unowned var view: RecipesSearchViewControllerInterface
    let router: RecipesSearchRouterInterface?
    let interactor: RecipesSearchInteractorInterface?

    init(
        interactor: RecipesSearchInteractorInterface,
        router: RecipesSearchRouterInterface,
        view: RecipesSearchViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RecipesSearchPresenter: RecipesSearchPresenterInterface {
    func addFilterTag(tag: AdditionalTag.ConvenientTag) {
        interactor?.addFilterTag(tag: tag)
    }
    
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        interactor?.addExceptionTag(tag: tag)
    }
    
    func removeFilterTag(tag: AdditionalTag.ConvenientTag) {
        interactor?.removeFilterTag(tag: tag)
    }
    
    func removeExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        interactor?.removeExceptionTag(tag: tag)
    }
    
    func didFinishSearchWork(with dishes: [Dish]) {
        return
    }
    
    func getNumberOfItemsInSection() -> Int {
        return 0
    }
    
    func performSearch(with phrase: String?) {
        interactor?.performSearch(phrase: phrase ?? "")
    }
}
