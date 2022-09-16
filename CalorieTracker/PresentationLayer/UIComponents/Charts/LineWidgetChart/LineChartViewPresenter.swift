//
//  LineChartViewPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.09.2022.
//

import UIKit

struct LineChartData {
    let data: [Int: CGFloat]
    let titles: [Int]
    let valueNow: CGFloat
    let valueStart: CGFloat
    let goal: CGFloat?
    let goalTitle: String?
}

protocol LineChartViewPresenterInterface: AnyObject {
    func getData(_ period: ChartFormat) -> LineChartData?
    func getStartDate(_ period: ChartFormat) -> Date?
    func getValuesChart(_ values: [CGFloat]) -> (min: Int, max: Int)?
}

class LineChartViewPresenter {
    unowned var view: LineChartViewInterface
    
    var data: [(date: Date, value: CGFloat)] {
        switch view.getChartType() {
        case .weight:
            return UDM.weight.map { (date: $0.date, value: $0.value) }
        case .bmi:
            return UDM.bmi.map { (date: $0.date, value: $0.value) }
        }
    }
    
    var goal: CGFloat? {
        var goal: Double?
        switch view.getChartType() {
        case .weight:
            goal = UDM.weightGoal
        case .bmi:
            goal = UDM.bmiGoal
        }
        guard let goal = goal else { return nil }
        return CGFloat(goal)
    }
    
    init(view: LineChartViewInterface) {
        self.view = view
    }
    
    private func getDataForPeriod(_ period: ChartFormat) -> [(date: Date, value: CGFloat)]? {
        guard let startDate = getDate(period),
              let dateMin = data.map({ $0.date }).min() else { return nil }
        switch period {
        case .daily:
            break
        case .weekly:
            guard abs(Date().weeks(to: dateMin) ?? 0) >= 1 else { return nil }
        case .monthly:
            guard abs(Date().months(to: dateMin) ?? 0) >= 1 else { return nil }
        }
        return data.filter { $0.date > startDate }
    }
    
    private func getDate(_ period: ChartFormat) -> Date? {
        let dateNow = Date()
        let calendar = Calendar.current
        var date: Date?
        
        switch period {
        case .daily:
            date = calendar.date(byAdding: .month, value: -1, to: dateNow)
        case .weekly:
            date = calendar.date(byAdding: .month, value: -6, to: dateNow)
        case .monthly:
            date = calendar.date(byAdding: .year, value: -2, to: dateNow)
        }
        
        return date
    }
    
    private func weightConvert(min: CGFloat, max: CGFloat) -> (min: Int, max: Int)? {
        let minWeightInt = Int(floor(min))
        let maxWeightInt = Int(ceil(max))
        
        switch maxWeightInt - minWeightInt {
        case 0...5:
            return (min: minWeightInt,
                     max: maxWeightInt)
        case 5...10:
            return (min: minWeightInt / 2 * 2,
                     max: Int(ceil(Double(maxWeightInt) / 2.0) * 2))
        case 10...40:
            return (min: minWeightInt / 5 * 5,
                     max: Int(ceil(Double(maxWeightInt) / 5.0) * 5))
        case 40...:
            return (min: minWeightInt / 10 * 10,
                     max: Int(ceil(Double(maxWeightInt) / 10.0) * 10))
        default:
            return nil
        }
    }
    
    func countTheNumberOfHorizontalLines(min: Int, max: Int) -> [Int] {
        let values = Array(min...max)
        switch max - min {
        case 0...5:
            return values.reversed()
        case 5...10:
            return values.filter { $0 % 2 == 0 }.reversed()
        case 10...40:
            return values.filter { $0 % 5 == 0 }.reversed()
        case 40...:
            return values.filter { $0 % 10 == 0 }.reversed()
        default:
            return []
        }
    }
}

extension LineChartViewPresenter: LineChartViewPresenterInterface {
    func getValuesChart(_ values: [CGFloat]) -> (min: Int, max: Int)? {
        guard var maxValue = values.max(),
              var minValue = values.min() else { return nil }
        
        if let goal = goal {
            maxValue = max(goal, maxValue)
            minValue = min(goal, minValue)
        }
        
        return weightConvert(min: minValue, max: maxValue)
    }
    
    func getStartDate(_ period: ChartFormat) -> Date? {
        guard let data = getDataForPeriod(period) else { return nil }
        return data.min(by: { $0.date < $1.date })?.date
    }
    
    func getData(_ period: ChartFormat) -> LineChartData? {
        guard let data = getDataForPeriod(period),
              let values = getValuesChart(data.map { $0.value }) else { return nil }
        let difference = CGFloat(values.max - values.min)
        let goal = self.goal == nil ? nil : (self.goal! - CGFloat(values.min)) / difference
        var newData: [Int: CGFloat] = [:]
        var indexData: [Int: Int] = [:]
        
        switch period {
        case .daily:
            data.forEach {
                if let index = Date().days(to: $0.date) {
                    newData[abs(index)] = ($0.value - CGFloat(values.min)) / difference
                }
            }
        case .weekly:
            data.forEach {
                if let index = Date().weeks(to: $0.date) {
                    newData[abs(index)] = (newData[abs(index)] ?? 0) + ($0.value - CGFloat(values.min)) / difference
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        case .monthly:
            data.forEach {
                if let index = Date().months(to: $0.date) {
                    newData[abs(index)] = (newData[abs(index)] ?? 0) + ($0.value - CGFloat(values.min)) / difference
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        }
        
        newData.forEach {
            newData[$0.key] = $0.value / CGFloat(indexData[$0.key] ?? 1)
        }
        
        return LineChartData(
            data: newData,
            titles: countTheNumberOfHorizontalLines(min: values.min, max: values.max),
            valueNow: data.sorted(by: { $0.date < $1.date }).last?.value ?? 0,
            valueStart: data.sorted(by: { $0.date < $1.date }).first?.value ?? 0,
            goal: goal,
            goalTitle: self.goal == nil ? nil : String(format: "%.1f", self.goal!)
        )
    }
}
