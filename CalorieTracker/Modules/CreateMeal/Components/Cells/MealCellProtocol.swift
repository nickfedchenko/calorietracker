//
//  MealCellProtocol.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 05.03.2023.
//

import Foundation

protocol MealCellProtocol {
    var title: String { get }
    var tag: String { get }
    var kcal: String { get }
    var weight: String { get }
}
