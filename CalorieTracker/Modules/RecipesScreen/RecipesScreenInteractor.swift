//
//  RecipesScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

struct MockModel {
    struct MockViewModel {
        struct MockItem {}
        var items = Array(repeating: MockItem(), count: 8)
    }
    
    var sections = Array(repeating: MockViewModel(), count: 6)
    
}

protocol RecipesScreenInteractorInterface: AnyObject {
    func getNumberOfItemInSection(section: Int) -> Int
    func getNumberOfSections() -> Int
}

class RecipesScreenInteractor {
    weak var presenter: RecipesScreenPresenterInterface?
    var dataModel = MockModel()
}

extension RecipesScreenInteractor: RecipesScreenInteractorInterface {
    func getNumberOfItemInSection(section: Int) -> Int {
        return dataModel.sections[section].items.count
    }
    
    func getNumberOfSections() -> Int {
        return dataModel.sections.count
    }
}
