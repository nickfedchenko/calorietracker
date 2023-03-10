//
//  NutritionGoalInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol NutritionGoalInteractorInterface: AnyObject {

}

class NutritionGoalInteractor {
    weak var presenter: NutritionGoalPresenterInterface?
}

extension NutritionGoalInteractor: NutritionGoalInteractorInterface {

}
