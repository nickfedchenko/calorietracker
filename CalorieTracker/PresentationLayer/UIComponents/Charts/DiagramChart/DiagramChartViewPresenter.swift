//
//  DiagramChartViewPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

struct ChartData {
    let data: [Int: CGFloat]
    let step: Int
    let goal: Int?
}

protocol DiagramChartViewPresenterInterface: AnyObject {
    func getData(_ period: ChartFormat) -> ChartData?
    func getStartDate(_ period: ChartFormat) -> Date?
}

class DiagramChartViewPresenter {
    unowned var view: DiagramChartViewInterface
    
    var data: [(date: Date, value: Int)] {
        var data: [WidgetData]
        switch view.getChartType() {
        case .calories:
            data = UDM.calories
        case .carb:
            data = UDM.carb
        case .steps:
            data = UDM.steps
        case .water:
            data = UDM.water
        case .activity:
            data = UDM.active
        }
        return data.map { (date: $0.date, value: Int($0.value)) }
    }
    
    var goal: Int? {
        var goal: Double?
        switch view.getChartType() {
        case .calories:
            goal = UDM.caloriesGoal
        case .carb:
            goal = UDM.carbGoal
        case .steps:
            goal = UDM.stepsGoal
        case .water:
            goal = UDM.waterGoal
        case .activity:
            goal = UDM.activeGoal
        }
        guard let goal = goal else { return nil }
        return Int(goal)
    }
    
    init(view: DiagramChartViewInterface) {
        self.view = view
    }
    
    private func getDataForPeriod(_ period: ChartFormat) -> [(date: Date, value: Int)]? {
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
    
    private func getMaxValue(_ data: [(date: Date, value: Int)]) -> Int {
        return data.map { $0.value }.max() ?? 3000
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
}

extension DiagramChartViewPresenter: DiagramChartViewPresenterInterface {
    func getStartDate(_ period: ChartFormat) -> Date? {
        guard let data = getDataForPeriod(period) else { return nil }
        return data.min(by: { $0.date < $1.date })?.date
    }
    
    func getData(_ period: ChartFormat) -> ChartData? {
        guard let data = getDataForPeriod(period) else { return nil }
        let maxValue = max(3000, (getMaxValue(data) / 1000 + 1) * 1000, ((goal ?? 0) / 1000 + 1) * 1000)
        
        var newData: [Int: CGFloat] = [:]
        var indexData: [Int: Int] = [:]
        
        switch period {
        case .daily:
            data.forEach {
                if let index = Date().days(to: $0.date) {
                    newData[abs(index)] = CGFloat($0.value) / CGFloat(maxValue)
                }
            }
        case .weekly:
            data.forEach {
                if let index = Date().weeks(to: $0.date) {
                    newData[abs(index)] = (newData[abs(index)] ?? 0) + CGFloat($0.value) / CGFloat(maxValue)
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        case .monthly:
            data.forEach {
                if let index = Date().months(to: $0.date) {
                    newData[abs(index)] = (newData[abs(index)] ?? 0) + CGFloat($0.value) / CGFloat(maxValue)
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        }
        
        newData.forEach {
            newData[$0.key] = $0.value / CGFloat(indexData[$0.key] ?? 1)
        }
        
        return ChartData(
            data: newData,
            step: maxValue / view.getCountHorizontalLines(),
            goal: goal
        )
    }
}
