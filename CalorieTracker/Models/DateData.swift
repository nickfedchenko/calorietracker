//
//  DateData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.08.2022.
//

import Foundation

struct DateData {
    let date: Date
    let calorieCorridor: CalorieCorridor
}

enum CalorieCorridor {
    case hit
    case exceeded
}

enum CalorieCorridorPart {
    case left
    case right
    case middle
}
