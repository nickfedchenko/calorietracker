//
//  RecipesSearchInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesSearchInteractorInterface: AnyObject {
    func performSearch(phrase: String)
    func addFilterTag(tag: AdditionalTag.ConvenientTag)
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag)
    func removeFilterTag(tag: AdditionalTag.ConvenientTag)
    func removeExceptionTag(tag: ExceptionTag.ConvenientExceptionTag)
}

class RecipesSearchInteractor {
    weak var presenter: RecipesSearchPresenterInterface?
    private let facade = DSF.shared
    private var allDishes: [Dish] = []
    private let searchQueue = DispatchQueue(label: "searchQueue", qos: .userInitiated)
    
    var searchPhrase = ""
    var selectedEatingTagFilters: Set<AdditionalTag.ConvenientTag> = []
    var exceptionTags: Set<ExceptionTag.ConvenientExceptionTag> = []
    
    init() {
        searchQueue.async { [weak self] in
            self?.allDishes = self?.facade.getAllStoredDishes() ?? []
        }
    }
}

extension RecipesSearchInteractor: RecipesSearchInteractorInterface {
    func addFilterTag(tag: AdditionalTag.ConvenientTag) {
        selectedEatingTagFilters.update(with: tag)
    }
    
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        exceptionTags.update(with: tag)
    }
    
    func removeFilterTag(tag: AdditionalTag.ConvenientTag) {
        selectedEatingTagFilters.remove(tag)
    }
    
    func removeExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        exceptionTags.remove(tag)
    }
    
    func performSearch(phrase: String) {
        let workUnit = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.searchPhrase = phrase
            let tagFilteredDishes = self.filterBySelectedTags()
            if !phrase.isEmpty {
                let filteredDishes = tagFilteredDishes.filter {
                    return $0.title.contains(phrase)
                }
                self.presenter?.didFinishSearchWork(with: filteredDishes)
            } else {
                self.presenter?.didFinishSearchWork(with: tagFilteredDishes)
            }
        }
        searchQueue.async(execute: workUnit)
    }
    
    private func filterBySelectedTags() -> [Dish] {
        guard !allDishes.isEmpty else { return [] }
        var filteredDishes: [Dish] = []
        for dish in allDishes {
            let allTags = dish.processingTypeTags
            + dish.dietTags
            + dish.eatingTags
            + dish.dishTypeTags
            + dish.additionalTags
            let mappedDishTags = allTags.compactMap { $0.convenientTag }
            let mappedExceptionTags = dish.exceptionTags.compactMap { $0.convenientTag }
            if selectedEatingTagFilters.isSubset(of: mappedDishTags) {
                for exceptionTag in exceptionTags {
                    if dish.exceptionTags.contains(where: { $0.convenientTag == exceptionTag }) {
                        continue
                    }
                }
                filteredDishes.append(dish)
            }
        }
        return []
    }
    

}
