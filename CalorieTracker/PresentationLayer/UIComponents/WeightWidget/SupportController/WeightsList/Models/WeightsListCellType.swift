//
//  WeightsListCelltype.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 27.04.2023.
//

import UIKit

struct WeightsListCellModel: Hashable {
    let dateString: String
    let descriptionString: String
    let valueLabel: String
    let preciseDate: Date?
}

enum WeightsListCellType: Hashable {
    case daily(model: WeightsListCellModel)
    case weekly(model: WeightsListCellModel)
    case monthly(model: WeightsListCellModel)
}
