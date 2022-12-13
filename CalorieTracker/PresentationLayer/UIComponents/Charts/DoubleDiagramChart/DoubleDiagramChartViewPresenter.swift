//
//  DoubleDiagramChartViewPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

struct DoubleDiagramChartData {
    let data: [Int: (CGFloat, CGFloat)]
    let step: Int
    let goal: Int?
}

protocol DoubleDiagramChartViewPresenterInterface: AnyObject {
    func getData(_ period: ChartFormat) -> DoubleDiagramChartData?
    func getStartDate(_ period: ChartFormat) -> Date?
}

class DoubleDiagramChartViewPresenter {
    unowned var view: DoubleDiagramChartViewInterface
    
    var data: [(date: Date, values: (Int, Int))] {
        var data: [DoubleWidgetData]
        switch view.getChartType() {
        case .exercises:
            data = []
        }
        return data.map {
            (
                date: $0.date,
                values: (
                    Int($0.valueFirst),
                    Int($0.valueSecond)
                )
            )
        }
    }
    
    var goal: Int? {
        var goal: Double?
        switch view.getChartType() {
        case .exercises:
            goal = 0
        }
        guard let goal = goal else { return nil }
        return Int(goal)
    }
    
    init(view: DoubleDiagramChartViewInterface) {
        self.view = view
    }
    
    private func getDataForPeriod(_ period: ChartFormat) -> [(date: Date, values: (Int, Int))]? {
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
    
    private func getMaxValue(_ data: [(date: Date, values: (Int, Int))] ) -> Int {
        return data.map { max($0.values.0, $0.values.1) }.max() ?? 1000
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

extension DoubleDiagramChartViewPresenter: DoubleDiagramChartViewPresenterInterface {
    func getStartDate(_ period: ChartFormat) -> Date? {
        guard let data = getDataForPeriod(period) else { return nil }
        return data.min(by: { $0.date < $1.date })?.date
    }
    
    func getData(_ period: ChartFormat) -> DoubleDiagramChartData? {
        guard let data = getDataForPeriod(period) else { return nil }
        let maxValue = max(1000, (getMaxValue(data) / 1000 + 1) * 1000, ((goal ?? 0) / 1000 + 1) * 1000)
        
        var newData: [Int: (CGFloat, CGFloat)] = [:]
        var indexData: [Int: Int] = [:]
        
        switch period {
        case .daily:
            data.forEach {
                if let index = Date().days(to: $0.date) {
                    newData[abs(index)] = (
                        CGFloat($0.values.0) / CGFloat(maxValue),
                        CGFloat($0.values.1) / CGFloat(maxValue)
                    )
                }
            }
        case .weekly:
            data.forEach {
                if let index = Date().weeks(to: $0.date) {
                    newData[abs(index)] = (
                        (newData[abs(index)]?.0 ?? 0) + CGFloat($0.values.0) / CGFloat(maxValue),
                        (newData[abs(index)]?.1 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue)
                    )
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        case .monthly:
            data.forEach {
                if let index = Date().months(to: $0.date) {
                    newData[abs(index)] = (
                        (newData[abs(index)]?.0 ?? 0) + CGFloat($0.values.0) / CGFloat(maxValue),
                        (newData[abs(index)]?.1 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue)
                    )
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        }
        
        newData.forEach {
            newData[$0.key] = (
                $0.value.0 / CGFloat(indexData[$0.key] ?? 1),
                $0.value.1 / CGFloat(indexData[$0.key] ?? 1)
            )
        }
        
        return DoubleDiagramChartData(
            data: newData,
            step: maxValue / view.getCountHorizontalLines(),
            goal: goal
        )
    }
}
