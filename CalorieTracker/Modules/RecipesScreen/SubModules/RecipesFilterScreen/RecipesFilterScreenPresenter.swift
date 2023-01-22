//
//  RecipesFilterScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 27.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesFilterScreenPresenterInterface: AnyObject {
    func getNumberOfSection() -> Int
    func getNumberOfItems(at index: Int) -> Int
    func getTagTitle(at indexPath: IndexPath) -> String
    func shouldUpdateCollection()
    func getTitleForSection(at indexPath: IndexPath) -> String
    func didSelectTag(at indexPath: IndexPath)
    func didDeselectTag(at indexPath: IndexPath)
    func applyButtonTapped()
    func getIndicesOfSelectedTags() -> [IndexPath]
}

class RecipesFilterScreenPresenter {
    
    unowned var view: RecipesFilterScreenViewControllerInterface
    let router: RecipesFilterScreenRouterInterface?
    let interactor: RecipesFilterScreenInteractorInterface?
    
    init(
        interactor: RecipesFilterScreenInteractorInterface,
        router: RecipesFilterScreenRouterInterface,
        view: RecipesFilterScreenViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RecipesFilterScreenPresenter: RecipesFilterScreenPresenterInterface {
    
    func applyButtonTapped() {
        if let selectedTags = interactor?.getAllSelectedTags() {
            router?.shouldNavigateBackWith(selected: selectedTags)
        } else {
            router?.shouldNavigateBackWith(selected: [])
        }
    }
    
    func getNumberOfSection() -> Int {
        interactor?.getNumberOfSections() ?? 0
    }
    
    func getNumberOfItems(at index: Int) -> Int {
        interactor?.getNumberOfItems(at: index) ?? 0
    }
    
    func getTagTitle(at indexPath: IndexPath) -> String {
        return interactor?.getTagTitle(at: indexPath) ?? ""
    }
    
    func shouldUpdateCollection() {
            view.updateCollection()
    }
    
    func getTitleForSection(at indexPath: IndexPath) -> String {
        interactor?.getTitleForSection(at: indexPath) ?? ""
    }
    
    func didSelectTag(at indexPath: IndexPath) {
        interactor?.didSelectTag(at: indexPath)
    }
    
    func didDeselectTag(at indexPath: IndexPath) {
        interactor?.didDeselectTag(at: indexPath)
    }
    
    func getIndicesOfSelectedTags() -> [IndexPath] {
        interactor?.getIndicesOfSelectedTags() ?? []
    }
}
