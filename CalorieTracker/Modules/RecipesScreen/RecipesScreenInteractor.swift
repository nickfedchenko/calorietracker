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
}

class RecipesScreenInteractor {
    let operationalQueue = DispatchQueue(label: "operations", qos: .userInitiated, attributes: .concurrent)
    weak var presenter: RecipesScreenPresenterInterface?
    var facade: DataServiceFacadeInterface = DSF.shared
    var sections: [RecipeSectionModel] = []
//    private let dataService = DSF.shared
}

extension RecipesScreenInteractor: RecipesScreenInteractorInterface {
    func requestAllDishes() -> [Dish] {
        let dishes = facade.getAllStoredDishes()
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
            self?.presenter?.notifySectionsUpdated()
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
            //        var possibleTags: Set<AdditionalTag.EatingTime> = []
            let dishes = self.requestAllDishes()
            //        dishes.forEach {
            //            print("Eating tags count \($0.eatingTags.count)")
            //
            //            $0.eatingTags.forEach {
            //                print($0)
            //                if let type = $0.eatingType {
            //                    possibleTags.update(with: type)
            //                }
            //            }
            //        }
            
            let breakFastDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .breakfast }) }
            let dinnerDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .dinner }) }
            let lunchDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .lunch }) }
            let snacksDishes = dishes.filter { $0.eatingTags.contains(where: { $0.convenientTag == .snack }) }
            sections.append(
                .init(
                    title: breakFastDishes.first?.eatingTags.first(
                        where: { $0.convenientTag == .breakfast }
                    )?.title ?? "",
                    dishes: breakFastDishes
                )
            )
            sections.append(
                .init(
                    title: lunchDishes.first?.eatingTags.first(where: { $0.convenientTag == .lunch })?.title ?? "",
                    dishes: lunchDishes
                )
            )
            sections.append(
                .init(
                    title: dinnerDishes.first?.eatingTags.first(where: { $0.convenientTag == .dinner })?.title ?? "",
                    dishes: dinnerDishes
                )
            )
            sections.append(
                .init(
                    title: snacksDishes.first?.eatingTags.first(where: { $0.convenientTag == .snack })?.title ?? "",
                    dishes: snacksDishes
                )
            )
            self.sections = sections
            completion()
        }
    }
}
