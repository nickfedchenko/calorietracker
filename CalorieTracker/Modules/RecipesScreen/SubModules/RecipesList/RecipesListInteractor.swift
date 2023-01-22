//
//  RecipesListInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipesListInteractorInterface: AnyObject {
    func getTitleForHeader() -> String
    func getNumberOfItems() -> Int
    func getDishModel(at indexPath: IndexPath) -> Dish
    func getAllDishes() -> [Dish]
}

class RecipesListInteractor {
    weak var presenter: RecipesListPresenterInterface?
    private let section: RecipeSectionModel
    
    init(with section: RecipeSectionModel) {
        self.section = section
    }
}

extension RecipesListInteractor: RecipesListInteractorInterface {
    func getAllDishes() -> [Dish] {
        section.dishes
    }
    
    func getNumberOfItems() -> Int {
        section.dishes.count
    }
    
    func getTitleForHeader() -> String {
        section.title
    }
    
    func getDishModel(at indexPath: IndexPath) -> Dish {
        section.dishes[indexPath.item]
    }
    
}
