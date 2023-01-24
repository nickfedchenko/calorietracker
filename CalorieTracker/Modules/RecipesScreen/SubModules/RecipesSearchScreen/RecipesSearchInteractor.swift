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
    func removeTagFromSelected(tag: SelectedTagsCell.TagType)
    func getNumberOfItems(in section: Int) -> Int
    func getSelectedTags() -> [SelectedTagsCell.TagType]
    func getDishModel(at indexPath: IndexPath) -> Dish?
    func setSelectedTags(tags: [SelectedTagsCell.TagType])
}

class RecipesSearchInteractor {
    weak var presenter: RecipesSearchPresenterInterface?
    private let facade = DSF.shared
    private var allDishes: [Dish] = []
    private let searchQueue = DispatchQueue(label: "searchQueue", qos: .userInitiated)
    private var currentSearchUnit: DispatchWorkItem?
    
    var searchPhrase = ""
    var selectedEatingTagFilters: Set<AdditionalTag.ConvenientTag> = []
    var exceptionTags: Set<ExceptionTag.ConvenientExceptionTag> = []
    var specialTags: [ExtraSearchTags] = []
    var selectedExceptionTags: Set<ExceptionTag.ConvenientExceptionTag> = []

    var selectedTags: [SelectedTagsCell.TagType] = []
    
    private lazy var resultArray: [Dish] = allDishes
    
    init(with dishes: [Dish]) {
        self.allDishes = dishes
    }
}

extension RecipesSearchInteractor: RecipesSearchInteractorInterface {
    func removeTagFromSelected(tag: SelectedTagsCell.TagType) {
        selectedTags.removeAll(where: {
            switch $0 {
            case .additionalTag(title: _, tag: let sourceTag):
                if case let .additionalTag(title: _, tag: tagToRemove) = tag {
                    return sourceTag == tagToRemove
                } else {
                    return false
                }
            case .exceptionTag(title: _, tag: let sourceTag, shouldUseAsCommonTag: let shouldUseAsCommonTag):
                if case let .exceptionTag(title: _, tag: tagToRemove, shouldUseAsCommonTag: shouldUse) = tag {
                    return sourceTag == tagToRemove && shouldUseAsCommonTag == shouldUse
                } else {
                    return false
                }
            case .extraTag(let sourceTag):
                if case let .extraTag(tagToRemove) = tag {
                    return sourceTag == tagToRemove
                } else {
                    return false
                }
            }
            
        })
        performSearch(phrase: searchPhrase)
    }
    
    func addFilterTag(tag: AdditionalTag.ConvenientTag) {
        selectedEatingTagFilters.update(with: tag)
    }
    
    func addExceptionTag(tag: ExceptionTag.ConvenientExceptionTag) {
        exceptionTags.update(with: tag)
    }
    
    func performSearch(phrase: String) {
        currentSearchUnit?.cancel()
        let workUnit = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.searchPhrase = phrase
            let tagFilteredDishes = self.filterBySelectedTags()
            if !phrase.isEmpty {
                let filteredDishes = tagFilteredDishes.filter {
                    return $0.title.lowercased().contains(phrase.lowercased())
                }
                self.resultArray = filteredDishes
                self.presenter?.didFinishSearchWork()
            } else {
                self.resultArray = tagFilteredDishes
                self.presenter?.didFinishSearchWork()
            }
        }
        currentSearchUnit = workUnit
        searchQueue.async(execute: workUnit)
    }
    
    private func filterBySelectedTags() -> [Dish] {
        guard !allDishes.isEmpty else {
            return []
        }
        clearAllTags()
        fillInnerTags()
        var filteredDishes: [Dish] = []
        
        for dish in allDishes {
            let allTags = dish.processingTypeTags
            + dish.dietTags
            + dish.eatingTags
            + dish.dishTypeTags
            + dish.additionalTags
            
            let mappedDishTags = Set(allTags.compactMap { $0.convenientTag })
            if selectedEatingTagFilters.isSubset(of: mappedDishTags) {
                let dishExceptions = dish.exceptionTags.compactMap { $0.convenientTag }
                if selectedExceptionTags.isSubset(of: dishExceptions) {
                    guard !exceptionTags.isEmpty else {
                        filteredDishes.append(dish)
                        continue
                    }
                    var shouldAdd = true
                    for exceptionTag in dishExceptions {
                        if exceptionTags.contains(exceptionTag) {
                            shouldAdd = false
                            break
                        }
                    }
                    if shouldAdd {
                        filteredDishes.append(dish)
                    }
                }
            }
        }
        filteredDishes = filterByExtraTags(dishes: filteredDishes)
        return filteredDishes.sorted(by: { $0.title < $1.title })
    }
    
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    private func filterByExtraTags(dishes: [Dish]) -> [Dish] {
        guard !specialTags.isEmpty else { return dishes }
        let filteringDishes = dishes
        var cal50to100Dishes: [Dish] = []
        var cal100to200Dishes: [Dish] = []
        var cal200to300Dishes: [Dish] = []
        var cal300to400Dishes: [Dish] = []
        var cal400to500Dishes: [Dish] = []
        var cal500to600Dishes: [Dish] = []
        var cal600to700Dishes: [Dish] = []
        var calMoreThan700Dishes: [Dish] = []
        var lessThan5Ingredients: [Dish] = []
        var lessThan10Minutes: [Dish] = []
        var lessThan20Minutes: [Dish] = []
        var lessThan30Minutes: [Dish] = []
        
        for specialTag in specialTags {
            switch specialTag {
            case .calorie50to100:
                let range: ClosedRange<Double> = (50...100)
                cal50to100Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calories100to200:
                let range: ClosedRange<Double> = (100...200)
                cal100to200Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie200to300:
                let range: ClosedRange<Double> = (200...300)
                cal200to300Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie300to400:
                let range: ClosedRange<Double> = (300...400)
                cal300to400Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie400to500:
                let range: ClosedRange<Double> = (400...500)
                cal400to500Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie500to600:
                let range: ClosedRange<Double> = (500...600)
                cal500to600Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie600to700:
                let range: ClosedRange<Double> = (600...700)
                cal600to700Dishes = filteringDishes.filter { range.contains($0.kcal) }
            case .calorie700plus:
                calMoreThan700Dishes = filteringDishes.filter { $0.kcal > 700 }
            case .lessThan5Ingredients:
                lessThan5Ingredients = filteringDishes.filter { $0.ingredients.count < 5 }
            case .lessThan10Min:
                lessThan10Minutes = filteringDishes.filter { $0.cookTime <= 10 }
            case .lessThan20Min:
                lessThan20Minutes = filteringDishes.filter { $0.cookTime <= 20 }
            case .lessThan30Min:
                lessThan30Minutes = filteringDishes.filter { $0.cookTime <= 30 }
            }
        }
        let filteredDishes = cal50to100Dishes +
        cal100to200Dishes +
        cal200to300Dishes +
        cal300to400Dishes +
        cal400to500Dishes +
        cal500to600Dishes +
        cal600to700Dishes +
        calMoreThan700Dishes +
        lessThan5Ingredients +
        lessThan10Minutes +
        lessThan20Minutes +
        lessThan30Minutes
        return !filteredDishes.isEmpty ? filteredDishes : filteredDishes
    }
    
    private func fillInnerTags() {
        for tag in selectedTags {
            switch tag {
            case .additionalTag( _, let tag):
                selectedEatingTagFilters.update(with: tag)
            case .exceptionTag( _, let tag, shouldUseAsCommonTag: let isCommon):
                if !isCommon {
                    exceptionTags.update(with: tag)
                } else {
                    selectedExceptionTags.update(with: tag)
                }
            case .extraTag(let extraSearchTag):
                specialTags.append(extraSearchTag)
            }
        }
    }
    
    private func clearAllTags() {
        selectedEatingTagFilters = []
        exceptionTags = []
        specialTags = []
        selectedExceptionTags = []
    }
    
    func getNumberOfItems(in section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return resultArray.count
        }
    }
    
    func getSelectedTags() -> [SelectedTagsCell.TagType] {
        selectedTags
    }
    
    func getDishModel(at indexPath: IndexPath) -> Dish? {
        guard indexPath.item < resultArray.count else { return nil }
        return resultArray[indexPath.item]
    }
    
    func setSelectedTags(tags: [SelectedTagsCell.TagType]) {
        self.selectedTags = tags
        performSearch(phrase: searchPhrase)
    }
}
