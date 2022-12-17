//
//  Measurement.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.12.2022.
//

import Foundation

enum MeasurementValue {
    case weight
    case lenght
    case energy
    case liquid
    case serving
    
    func getMetricUnit() -> Dimension {
        switch self {
        case .weight:
            return UnitMass.kilograms
        case .lenght:
            return UnitLength.centimeters
        case .energy:
            return UnitEnergy.kilocalories
        case .liquid:
            return UnitVolume.milliliters
        case .serving:
            return UnitMass.grams
        }
    }
    
    func getImperialUnit() -> Dimension {
        switch self {
        case .weight:
            return UnitMass.pounds
        case .lenght:
            return UnitLength.inches
        case .energy:
            return UnitEnergy.kilojoules
        case .liquid:
            return UnitVolume.imperialFluidOunces
        case .serving:
            return UnitMass.ounces
        }
    }
}
