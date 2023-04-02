//
//  RecipesScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

struct RecipeSectionModel {
    let title: String
    let dishes: [LightweightRecipeModel]
}

protocol RecipesScreenInteractorInterface: AnyObject {
    func requestUpdateSections()
    func getNumberOfItemInSection(section: Int) -> Int
    func getNumberOfSections() -> Int
    func getDishModel(at indexPath: IndexPath) -> LightweightRecipeModel?
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel
    func updateFavoritesSection()
}

class RecipesScreenInteractor {
    let operationalQueue = DispatchQueue(label: "operations", qos: .userInteractive, attributes: .concurrent)
    let syncQueue = DispatchQueue(label: "sync queue", qos: .userInteractive)
    weak var presenter: RecipesScreenPresenterInterface?
    var facade: DataServiceFacadeInterface = DSF.shared
    var foodService: FoodDataServiceInterface = FDS.shared
    let lock = NSLock()
    var sections: [RecipeSectionModel] = [
        .init(title: "Loading", dishes: []),
        .init(title: "Loading", dishes: []),
        .init(title: "Loading", dishes: []),
        .init(title: "Loading", dishes: [])
    ]
    
    //    private let dataService = DSF.shared
}

extension RecipesScreenInteractor: RecipesScreenInteractorInterface {
    func requestAllDishes(completion: @escaping ([Dish]) -> Void) {
        let dishes = facade.getAllStoredDishes(completion: completion)
    }
    
//    func requestLunchDishes(completion: @escaping ([Dish]) -> Void) {
//        DSF.shared.getBreakfastDishes(completion: completion)
//    }
    
    func getNumberOfItemInSection(section: Int) -> Int {
        print("dishes in section \(section) - \(sections[section].dishes.count)")
        return sections[section].dishes.count
    }
    
    func getNumberOfSections() -> Int {
        return sections.count
    }
    
    func requestUpdateSections() {
        makeSections { [weak self] section in
            self?.syncQueue.async {
                self?.presenter?.notifySectionsUpdated(sectionUpdated: section, shouldRemoveActivity: true)
            }
        }
    }
    
    func getDishModel(at indexPath: IndexPath) -> LightweightRecipeModel? {
        guard indexPath.section < sections.count else { return nil }
        let section = sections[indexPath.section]
        guard !section.dishes.isEmpty else { return nil }
        return sections[indexPath.section].dishes[indexPath.item]
    }
    
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel {
        sections[indexPath.section]
    }
    
    func makeSections(completion: @escaping (Int) -> Void) {
        //        operationalQueue.async { [weak self] in
        //            guard let self = self else { return }
        //            var sections: [RecipeSectionModel] = []
        DSF.shared.getBreakfastDishes { [weak self] dishes in
            guard let self = self else { return }
            if self.sections.count > 4 {
                self.sections[1] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .breakfast })?.title ?? "",
                    dishes: dishes
                )
                completion(1)
            } else {
                self.sections[0] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .breakfast })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(0)
            }
        }
        
        DSF.shared.getLunchDishes { [weak self] dishes in
            guard let self = self else { return }
            if self.sections.count > 4 {
                self.sections[2] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .lunch })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(2)
            } else {
                self.sections[1] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .lunch })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(1)
            }
        }
        
        DSF.shared.getDinnerDishes { [weak self] dishes in
            guard let self = self else { return }
            if self.sections.count > 4 {
                self.sections[3] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .dinner })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(3)
            } else {
                self.sections[2] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .dinner })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(2)
            }
        }
        
        DSF.shared.getSnacksDishes { [weak self] dishes in
            guard let self = self else { return }
            if self.sections.count > 4 {
                self.sections[4] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .snack })?.title ?? "",
                    dishes: dishes
                )
                completion(4)
            } else {
                self.sections[3] = .init(
                    title: dishes
                        .first?
                        .eatingTags
                        .first(where: { $0.convenientTag == .snack })?.title ?? "",
                    dishes: dishes.shuffled()
                )
                completion(3)
            }
            
        }
        self.updateFavoritesSection()
    }
    
    func updateFavoritesSection() {
        let favoritesDishes = foodService.getFavoriteDishes()
        let favorites = favoritesDishes.compactMap { LightweightRecipeModel(from: $0)}
        guard !favorites.isEmpty else {
            if sections.count > 4 {
                _ = sections.removeFirst()
            }
            presenter?.notifySectionsUpdated(sectionUpdated: 0, shouldRemoveActivity: false)
            return
        }
        if sections.count > 4 {
            sections[0] = .init(title: "Favorites".localized, dishes: favorites)
            presenter?.notifySectionsUpdated(sectionUpdated: 0, shouldRemoveActivity: false)
        } else {
            sections.insert(.init(title: "Favorites".localized, dishes: favorites), at: 0)
            presenter?.notifySectionsUpdated(sectionUpdated: 0, shouldRemoveActivity: false)
        }
    }
}
