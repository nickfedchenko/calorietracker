//
//  RecipesFilterScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 27.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesFilterScreenInteractorInterface: AnyObject {
    func getNumberOfSections() -> Int
    func getNumberOfItems(at index: Int) -> Int
    func getTagTitle(at indexPath: IndexPath) -> String
    func getTitleForSection(at indexPath: IndexPath) -> String
    func didSelectTag(at indexPath: IndexPath)
    func didDeselectTag(at indexPath: IndexPath)
    func getAllSelectedTags() -> [SelectedTagsCell.TagType]
    func getIndicesOfSelectedTags() -> [IndexPath]
}

class RecipesFilterScreenInteractor {
    weak var presenter: RecipesFilterScreenPresenterInterface?
    private var sections: [RecipesFiltersSection] = []
    var titlesForFilterTags: [AdditionalTag.ConvenientTag: String] = [:]
    var titlesForExceptionTags: [ExceptionTag.ConvenientExceptionTag: String] = [:]
    
//    var possibleFilterTags: Set<AdditionalTag> = []
    var possibleExceptionTags: Set<ExceptionTag> = []
    
    var selectedTags: [SelectedTagsCell.TagType] = []
    
    init(with previouslySelectedTags: [SelectedTagsCell.TagType]) {
        self.selectedTags = previouslySelectedTags
        //        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        generateTitles()
        makeSections()
        let selectedItemsIndices = getIndicesOfSelectedTags() ?? []
        //            DispatchQueue.main.sync { [weak self] in
        presenter?.shouldUpdateCollection()
        //            }
        //        }
    }
    
    private func makeSections() {
        let categoriesSectionTags: [AdditionalTag.ConvenientTag] = [
            .salad, .microwaving, .soup, .appetiser, .bakery, .pizza, .drink, .bakery, .sandwich, .sauce
        ]
        
        let categoriesSectionModel: RecipesFiltersSection = .init(
            title: "Categories".localized,
            sectionType: .filterTags(tags: categoriesSectionTags)
        )
        
        let mealsSectionTags: [AdditionalTag.ConvenientTag] = [
            .breakfast, .lunch, .dinner, .snack
        ]
        
        let mealsSectionModel: RecipesFiltersSection = .init(
            title: "Meals".localized,
            sectionType: .filterTags(tags: mealsSectionTags)
        )
        
        let caloriesTags: [ExtraSearchTags] = [
            .calorie50to100, .calories100to200, .calorie200to300,
            .calorie300to400, .calorie400to500, .calorie500to600, .calorie600to700, .calorie700plus
        ]
        
        let caloriesSectionModel: RecipesFiltersSection  = .init(
            title: "Calories".localized,
            sectionType: .extraTags(tags: caloriesTags)
        )
        
        let exceptionTags: [ExceptionTag.ConvenientExceptionTag] = Array(possibleExceptionTags)
            .sorted(by: { $0.title < $1.title })
            .compactMap { $0.convenientTag }
        
        let exceptionSectionModel: RecipesFiltersSection = .init(
            title: "Exception".localized,
            sectionType: .exceptionTags(tags: exceptionTags)
        )
        
        let complexityTags: [ExtraSearchTags] = [
            .lessThan5Ingredients, .lessThan10Min, .lessThan20Min, .lessThan30Min
        ]
        
        let complexitySectionModel: RecipesFiltersSection = .init(
            title: "Complexity".localized,
            sectionType: .extraTags(tags: complexityTags)
        )
        
        let ingredientsTags: [ExceptionTag.ConvenientExceptionTag] = exceptionTags
        
        let ingredientsSectionModel: RecipesFiltersSection = .init(
            title: "Ingredients".localized,
            sectionType: .exceptionTags(tags: ingredientsTags)
        )
        
        sections = [
            categoriesSectionModel,
            mealsSectionModel,
            caloriesSectionModel,
            exceptionSectionModel,
            complexitySectionModel,
            ingredientsSectionModel
        ]
    }
    
    private func generateTitles() {
        titlesForFilterTags = UDM.titlesForFilterTags
        titlesForExceptionTags = UDM.titlesForExceptionTags
        possibleExceptionTags = UDM.possibleIngredientsTags
    }
}

extension RecipesFilterScreenInteractor: RecipesFilterScreenInteractorInterface {
    func getAllSelectedTags() -> [SelectedTagsCell.TagType] {
        return selectedTags
    }
    
    func getNumberOfSections() -> Int {
        sections.count + 1
    }
    
    func getNumberOfItems(at index: Int) -> Int {
        guard !sections.isEmpty else { return 0 }
        if index == 0 {
            return 1
        } else {
            let section = sections[index - 1]
            switch section.sectionType {
            case .exceptionTags(tags: let tags):
                return tags.count
            case .extraTags(tags: let tags):
                return tags.count
            case .filterTags(tags: let tags):
                return tags.count
            }
        }
    }
    
    func getTagTitle(at indexPath: IndexPath) -> String {
        guard !sections.isEmpty else { return " " }
        let section = sections[indexPath.section - 1]
        switch section.sectionType {
        case .filterTags(tags: let tags):
            return titlesForFilterTags[tags[indexPath.item]] ?? ""
        case .exceptionTags(tags: let tags):
            return titlesForExceptionTags[tags[indexPath.item]] ?? ""
        case .extraTags(tags: let tags):
            return tags[indexPath.item].localizedTitle
        }
    }
    
    func getTitleForSection(at indexPath: IndexPath) -> String {
        guard !sections.isEmpty else { return "" }
        if indexPath.section == 0 {
            return ""
        } else {
            return sections[indexPath.section - 1].title
        }
    }
    
    func didSelectTag(at indexPath: IndexPath) {
        let section = sections[indexPath.section - 1]
        switch section.sectionType {
        case .filterTags(tags: let tags):
            let tag = tags[indexPath.item]
            selectedTags.append(.additionalTag(
                title: titlesForFilterTags[tag] ?? "",
                tag: tag)
            )
        case .exceptionTags(tags: let tags):
            let tag = tags[indexPath.item]
            selectedTags.append(
                .exceptionTag(
                    title: titlesForExceptionTags[tag] ?? "",
                    tag: tag,
                    shouldUseAsCommonTag: indexPath.section == 6
                )
            )
        case .extraTags(tags: let tags):
            let tag = tags[indexPath.item]
            selectedTags.append(.extraTag(tag))
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func didDeselectTag(at indexPath: IndexPath) {
        let tags = sections[indexPath.section - 1].sectionType
        switch tags {
        case .filterTags(tags: let tags):
            let targetTag = tags[indexPath.item]
            selectedTags.removeAll(where: {
                switch $0 {
                case .additionalTag(title: _, tag: let tag):
                    return targetTag == tag
                case .extraTag:
                    return false
                case .exceptionTag:
                    return false
                }
            })
        case .exceptionTags(tags: let tags):
            let targetTag = tags[indexPath.item]
            selectedTags.removeAll(where: {
                switch $0 {
                case .additionalTag:
                    return false
                case .extraTag:
                    return false
                case .exceptionTag(title: _, tag: let tag, shouldUseAsCommonTag: _):
                    return targetTag == tag
                }
            })
        case .extraTags(tags: let tags):
            let targetTag = tags[indexPath.item]
            selectedTags.removeAll(where: {
                switch $0 {
                case .additionalTag(title: _, tag: _):
                    return false
                case .extraTag(let tag):
                    return targetTag == tag
                case .exceptionTag(title: _, tag: _, shouldUseAsCommonTag: _):
                    return false
                }
            })
        }
    }
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable:next function_body_length
    func getIndicesOfSelectedTags() -> [IndexPath] {
        var indices: [IndexPath] = []
        for selectedTag in selectedTags {
            var sectionIndex = -1
            var itemIndex = -1
            switch selectedTag {
            case .additionalTag(_, let tag):
                if let sectIndex = sections.firstIndex(where: {
                    switch $0.sectionType {
                    case .filterTags(tags: let tags):
                        return tags.contains(tag)
                    case .exceptionTags(tags: _):
                        return false
                    case .extraTags(tags: _):
                        return false
                    }
                }) {
                    sectionIndex = sectIndex
                    let sectionType = sections[sectionIndex].sectionType
                    switch sectionType {
                    case .filterTags(tags: let tags):
                        if let itIndex = tags.firstIndex(of: tag) {
                            itemIndex = itIndex
                        }
                    case .exceptionTags(tags: _):
                        continue
                    case .extraTags(tags: _):
                        continue
                    }
                }
            case .exceptionTag(_, let tag, _):
                if let sectIndex = sections.firstIndex(where: {
                    switch $0.sectionType {
                    case .filterTags(tags: _):
                        return false
                    case .exceptionTags(tags: let tags):
                        return tags.contains(tag)
                    case .extraTags(tags: _):
                        return false
                    }
                }) {
                    sectionIndex = sectIndex
                    let sectionType = sections[sectionIndex].sectionType
                    switch sectionType {
                    case .filterTags(tags: _):
                        continue
                    case .exceptionTags(tags: let tags):
                        if let itIndex = tags.firstIndex(of: tag) {
                            itemIndex = itIndex
                        }
                    case .extraTags(tags: _):
                        continue
                    }
                }
            case .extraTag(let extraSearchTags):
                if let sectIndex = sections.firstIndex(where: {
                    switch $0.sectionType {
                    case .filterTags(tags: _):
                        return false
                    case .exceptionTags(tags: _):
                        return false
                    case .extraTags(tags: let tags):
                        return tags.contains(extraSearchTags)
                    }
                }) {
                    sectionIndex = sectIndex
                    let sectionType = sections[sectionIndex].sectionType
                    switch sectionType {
                    case .filterTags(tags: _):
                        continue
                    case .exceptionTags(tags: _):
                        continue
                    case .extraTags(tags: let tags):
                        if let itIndex = tags.firstIndex(of: extraSearchTags) {
                            itemIndex = itIndex
                        }
                    }
                }
            }
            
            if sectionIndex >= 0 && itemIndex >= 0 {
                indices.append(IndexPath(item: itemIndex, section: sectionIndex + 1))
            }
        }
        return indices
    }
}
