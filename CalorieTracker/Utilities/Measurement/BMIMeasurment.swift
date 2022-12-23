//
//  BMIMeasurment.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.12.2022.
//

import Foundation

struct BMIMeasurment {
    let weight: Double
    let height: Double
    
    var bmi: Double {
        let heightM = height / 100.0
        return weight / pow(heightM, 2)
    }
    
    init(weight: Double, height: Double) {
        self.weight = weight
        self.height = height
    }
}
