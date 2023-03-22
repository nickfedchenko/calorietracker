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
    let dishes: [Dish]
}

protocol RecipesScreenInteractorInterface: AnyObject {
    func requestUpdateSections()
    func getNumberOfItemInSection(section: Int) -> Int
    func getNumberOfSections() -> Int
    func getDishModel(at indexPath: IndexPath) -> Dish
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel
    func updateFavoritesSection()
}

class RecipesScreenInteractor {
    let operationalQueue = DispatchQueue(label: "operations", qos: .userInteractive, attributes: .concurrent)
    weak var presenter: RecipesScreenPresenterInterface?
    var facade: DataServiceFacadeInterface = DSF.shared
    var foodService: FoodDataServiceInterface = FDS.shared
    var sections: [RecipeSectionModel] = []
//    private let dataService = DSF.shared
}

extension RecipesScreenInteractor: RecipesScreenInteractorInterface {
    func requestAllDishes() -> [Dish] {
        let secondsStart = Date().timeIntervalSince1970
        let dishes = facade.getAllStoredDishes()
        let secondsDoneFetch = Date().timeIntervalSince1970
        print("Dishes fetch time \(secondsDoneFetch - secondsStart)")
        return dishes
    }
    
    func getNumberOfItemInSection(section: Int) -> Int {
        return sections[section].dishes.count
    }
    
    func getNumberOfSections() -> Int {
        return sections.count
    }
    
    func requestUpdateSections() {
        makeSections { [weak self] in
            self?.presenter?.notifySectionsUpdated(shouldRemoveActivity: true)
        }
    }
    
    func getDishModel(at indexPath: IndexPath) -> Dish {
        sections[indexPath.section].dishes[indexPath.item]
    }
    
    func getSectionModel(at indexPath: IndexPath) -> RecipeSectionModel {
        sections[indexPath.section]
    }
    
    func makeSections(completion: @escaping () -> Void) {
        operationalQueue.async { [weak self] in
            guard let self = self else { return }
            var sections: [RecipeSectionModel] = []
            let dishes = self.requestAllDishes().sorted(by: { $0.title < $1.title })
            let breakFastDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .breakfast }) }
            let dinnerDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .dinner }) }
            let lunchDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .lunch }) }
            let snacksDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .snack }) }
            sections.append(
                .init(
                    title: breakFastDishes.first?.eatingTags.first(
                        where: { $0.convenientTag == .breakfast }
                    )?.title ?? "",
                    dishes: breakFastDishes.shuffled()
                )
            )
            sections.append(
                .init(
                    title: lunchDishes.first?.eatingTags.first(where: { $0.convenientTag == .lunch })?.title ?? "",
                    dishes: lunchDishes.shuffled()
                )
            )
            sections.append(
                .init(
                    title: dinnerDishes.first?.eatingTags.first(where: { $0.convenientTag == .dinner })?.title ?? "",
                    dishes: dinnerDishes.shuffled()
                )
            )
            sections.append(
                .init(
                    title: snacksDishes.first?.eatingTags.first(where: { $0.convenientTag == .snack })?.title ?? "",
                    dishes: snacksDishes.shuffled()
                )
            )
            self.sections = sections
            self.updateFavoritesSection()
            completion()
        }
    }
    
    func updateFavoritesSection() {
        let favorites = foodService.getFavoriteDishes()
        guard !favorites.isEmpty else {
            if sections.count > 4 {
                _ = sections.removeFirst()
            }
            presenter?.notifySectionsUpdated(shouldRemoveActivity: false)
            return
        }
        if sections.count > 4 {
            sections[0] = .init(title: "Favorites".localized, dishes: favorites)
        } else {
            sections.insert(.init(title: "Favorites".localized, dishes: favorites), at: 0)
        }
        presenter?.notifySectionsUpdated(shouldRemoveActivity: false)
    }
}
