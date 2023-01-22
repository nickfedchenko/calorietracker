//
//  RecipesSearchPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol RecipesSearchPresenterInterface: AnyObject {
    func didFinishSearchWork()
    func getNumberOfItems(in section: Int) -> Int
    func setFilterTags(tags: [SelectedTagsCell.TagType])
    func removeTagFormSelected(tag: SelectedTagsCell.TagType)
    func performSearch(with phrase: String?)
    func filterButtonTapped()
    func calculateTopCellHeight() -> CGFloat
    func getSelectedTags() -> [SelectedTagsCell.TagType]
    func getDishModel(at indexPath: IndexPath) -> Dish?
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
 
    func filterButtonTapped() {
        router?.showFiltersScreen()
    }
    
    func addFilterTag(tag: AdditionalTag.ConvenientTag) {
        interactor?.addFilterTag(tag: tag)
    }
    
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        interactor?.addExceptionTag(tag: tag)
    }
    
    func didFinishSearchWork() {
        view.searchFinished()
    }
    
    func getNumberOfItems(in section: Int) -> Int {
        interactor?.getNumberOfItems(in: section) ?? 1
    }
    
    func performSearch(with phrase: String?) {
        interactor?.performSearch(phrase: phrase ?? "")
    }
    
    func calculateTopCellHeight() -> CGFloat {
        guard
            let selectedTags = interactor?.getSelectedTags(),
            !selectedTags.isEmpty
        else { return 0 }
        var currentRows: CGFloat = 1
        var maxWidth: CGFloat = UIScreen.main.bounds.width - 40
        var currentWidth: CGFloat = 0
        var interItemSpacing: CGFloat = 8
        for tag in selectedTags {
            var currentTitle = ""
            switch tag {
            case .additionalTag(let title, _ ):
                currentTitle = title
            case .exceptionTag(let title, _, _):
                currentTitle = title
            case .extraTag(let extraSearchTags):
                currentTitle = extraSearchTags.localizedTitle
            }
            let label = UILabel()
            label.font = R.font.sfProTextMedium(size: 15)
            label.textAlignment = .left
            label.text = currentTitle
            label.sizeToFit()
            let textWidth = label.bounds.width
            let fullwidth = textWidth + 48
            if currentWidth + fullwidth + interItemSpacing < maxWidth {
                currentWidth += fullwidth + interItemSpacing
            } else {
                currentWidth = fullwidth + interItemSpacing
                currentRows += 1
            }
        }
        return currentRows * 32 + ((currentRows) * 8)
    }
    
    func getSelectedTags() -> [SelectedTagsCell.TagType] {
        interactor?.getSelectedTags() ?? []
    }
    
    func getDishModel(at indexPath: IndexPath) -> Dish? {
        interactor?.getDishModel(at: indexPath)
    }
    
    func setFilterTags(tags: [SelectedTagsCell.TagType]) {
        interactor?.setSelectedTags(tags: tags)
    }
    
    func removeTagFormSelected(tag: SelectedTagsCell.TagType) {
        interactor?.removeTagFromSelected(tag: tag)
    }
}
