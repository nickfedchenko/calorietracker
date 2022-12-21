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
    var string: String { self.getString() }
    
    init(_ value: Double, _ measurement: MeasurementValue) {
        self.measurement = measurement
        self.value = BAMeasurement.bringToStandard(value, measurement: measurement)
    }
    
    static func measurmentSuffix(_ measurement: MeasurementValue) -> String {
        switch measurement {
        case .weight:
            return UDM.weightIsMetric
                ? "kg"
                : "lb"
        case .lenght:
            return UDM.lengthIsMetric
                ? "cm"
                : "in"
        case .energy:
            return UDM.energyIsMetric
                ? "kcal"
                : "kj"
        case .liquid:
            return UDM.liquidCapacityIsMetric
                ? "ml"
                : "fl oz"
        case .serving:
            return UDM.servingIsMetric
                ? "g"
                : "oz"
        }
    }
    
    private func getString() -> String {
        let valueStr = localized.clean
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
    
    private static func convert(value: Double,
                                from: Units,
                                to: Units,
                                measurement: MeasurementValue) -> Double {
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
    var clean: String {
        if self.isNaN { return "0" }
        var string = self.truncatingRemainder(dividingBy: 1) == 0
        ? String(format: "%.0f", self)
        : String(format: "%.2f", self)
        if string.hasSuffix(".00") { string = string.replacingOccurrences(of: ".00", with: "") }
        if string != "0" && string.contains(".") && string.hasSuffix("0") {
            string = String(string.dropLast())
        }
        return string
    }
}
