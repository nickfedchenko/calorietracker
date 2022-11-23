//
//  SearchFoodInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 23.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol SearchFoodInteractorInterface: AnyObject {

}

class SearchFoodInteractor {
    weak var presenter: SearchFoodPresenterInterface?
}

extension SearchFoodInteractor: SearchFoodInteractorInterface {

}
