//
//  FoodCellProtocol.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

import UIKit

protocol FoodCellProtocol: UICollectionViewCell {
    var foodType: Food? { get }
}
