//
//  BAMeasurement.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.12.2022.
//

import Foundation

struct BAMeasurement {
    let value: Double
    let measurement: MeasurementValue
    
    var localized: Double { self.getLocalized() }
    func string(with precision: Int) -> String { return getString(with: precision) }
    
    init(_ value: Double, _ measurement: MeasurementValue, isMetric: Bool = false) {
        self.measurement = measurement
        if isMetric {
            self.value = value
        } else {
            self.value = BAMeasurement.bringToStandard(value, measurement: measurement)
        }
    }
    
    static func measurmentSuffix(_ measurement: MeasurementValue) -> String {
        measurmentSuffix(
            measurement,
            isMetric: {
                switch measurement {
                case .weight:
                    return UDM.weightIsMetric
                case .lenght:
                    return UDM.lengthIsMetric
                case .energy:
                    return UDM.energyIsMetric
                case .liquid:
                    return UDM.liquidCapacityIsMetric
                case .serving:
                    return UDM.servingIsMetric
                case .milliNutrients:
                    return UDM.servingIsMetric
                case .microNutrients:
                    return UDM.servingIsMetric
                case .lengthLong:
                    return UDM.lengthIsMetric
                }
            }()
        )
    }
    
    static func measurmentSuffix(_ measurement: MeasurementValue, isMetric: Bool) -> String {
        switch measurement {
        case .weight:
            return isMetric
            ? "measurement.kg".localized
            : "measurement.lb".localized
        case .lenght:
            return isMetric
            ? "measurement.cm".localized
            : "measurement.in".localized
        case .energy:
            return isMetric
            ? "measurement.kcal".localized
            : "measurement.kj".localized
        case .liquid:
            return isMetric
            ? "measurement.ml".localized
            : "measurement.floz".localized
        case .serving:
            return isMetric
            ? "measurement.g".localized
            : "measurement.oz".localized
        case .milliNutrients:
            return isMetric
            ? "measurement.mg".localized
            : "measurement.mg".localized
        case .microNutrients:
            return isMetric
            ? "measurement.mcg".localized
            : "measurement.mcg".localized
        case .lengthLong:
            return isMetric
            ? "measurements.m".localized
            : "measurements.ft".localized
        }
    }
    
    private func getString(with precision: Int = 2) -> String {
        let valueStr = localized.clean(with: precision)
        let suffix = getMeasurementSuffix()
        return [valueStr, suffix].joined(separator: " ")
    }
    
    private func getMeasurementSuffix() -> String {
        BAMeasurement.measurmentSuffix(measurement)
    }
    
    private func getLocalized() -> Double {
        Measurement(value: value, unit: measurement.getMetricUnit())
            .converted(
                to: {
                    switch BAMeasurement.getUnitForMeasurement(measurement) {
                    case .metric:
                        return measurement.getMetricUnit()
                    case .imperial:
                        return measurement.getImperialUnit()
                    }
                }()
            )
            .value
    }
    
    private static func convert(
        value: Double,
        from: Units,
        to: Units,
        measurement: MeasurementValue
    ) -> Double {
        Measurement(
            value: value,
            unit: from == .metric
            ? measurement.getMetricUnit()
            : measurement.getImperialUnit()
        ).converted(
            to: to == .metric
            ? measurement.getMetricUnit()
            : measurement.getImperialUnit()
        ).value
    }
    
    private static func getUnitForMeasurement(_ measurement: MeasurementValue) -> Units {
        switch measurement {
        case .weight:
            return UDM.weightIsMetric ? .metric : .imperial
        case .lenght:
            return UDM.lengthIsMetric ? .metric : .imperial
        case .energy:
            return UDM.energyIsMetric ? .metric : .imperial
        case .liquid:
            return UDM.liquidCapacityIsMetric ? .metric : .imperial
        case .serving:
            return UDM.servingIsMetric ? .metric : .imperial
        case .milliNutrients:
            return UDM.servingIsMetric ? .metric : .imperial
        case .microNutrients:
            return UDM.servingIsMetric ? .metric : .imperial
        case .lengthLong:
            return UDM.lengthIsMetric ? .metric : .imperial
        }
    }
    
    private static func bringToStandard(_ value: Double, measurement: MeasurementValue) -> Double {
        return convert(
            value: value,
            from: getUnitForMeasurement(measurement),
            to: .metric,
            measurement: measurement
        )
    }
}

extension Double {
    func clean(with precision: Int = 2) -> String {
        if self.isNaN { return "0" }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        let string = formatter.string(from: NSNumber(value: self)) ?? String(format: "%.1f", self)
//        ? String(format: "%.0f", self)
//        : String(format: "%.\(precision)f", self)
//        : self.truncatingRemainder(dividingBy: 1) > -0.049
//        ? String(format: "%.0f", self)
//        : String(format: "%.\(precision)f", self)
//        if string.hasSuffix(".0") { string = string.replacingOccurrences(of: ".0", with: "") }
//        if string != "0" && string.contains(".") && string.hasSuffix("00") {
//            string = String(string.dropLast(2))
//        }
        return string
    }
}
