//
//  FoodViewingInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol FoodViewingInteractorInterface: AnyObject {

}

class FoodViewingInteractor {
    weak var presenter: FoodViewingPresenterInterface?
}

extension FoodViewingInteractor: FoodViewingInteractorInterface {

}
