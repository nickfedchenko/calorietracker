//
//  TripleDiagramChartViewPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

struct TripleDiagramChartData {
    let data: [Int: (CGFloat, CGFloat, CGFloat)]
    let step: Int
}

protocol TripleDiagramChartViewPresenterInterface: AnyObject {
    func getData(_ period: ChartFormat) -> TripleDiagramChartData?
    func getStartDate(_ period: ChartFormat) -> Date?
}

class TripleDiagramChartViewPresenter {
    unowned var view: TripleDiagramChartViewInterface
    
    var data: [(date: Date, values: (CGFloat, CGFloat, CGFloat))] {
        switch view.getChartType() {
        case .dietary:
            return FDS.shared.getAllNutrition().compactMap {
                guard let date = $0.day.date else { return nil }
                return (
                    date: date,
                    values: (
                        CGFloat($0.nutrition.carbs),
                        CGFloat($0.nutrition.protein),
                        CGFloat($0.nutrition.fat)
                    ))
            }
        }
    }
    
    init(view: TripleDiagramChartViewInterface) {
        self.view = view
    }
    
    private func getDataForPeriod(_ period: ChartFormat) -> [(date: Date, values: (CGFloat, CGFloat, CGFloat))]? {
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
    
    private func getMaxValue(_ data: [(date: Date, values: (CGFloat, CGFloat, CGFloat))]) -> Int {
        return data.map { Int([$0.values.0, $0.values.1, $0.values.2].sum()) }.max() ?? 1000
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

extension TripleDiagramChartViewPresenter: TripleDiagramChartViewPresenterInterface {
    func getStartDate(_ period: ChartFormat) -> Date? {
        guard let data = getDataForPeriod(period) else { return nil }
        return data.min(by: { $0.date < $1.date })?.date
    }
    
    func getData(_ period: ChartFormat) -> TripleDiagramChartData? {
        guard let data = getDataForPeriod(period) else { return nil }
        let maxValue = max(100, (getMaxValue(data) / 100 + 1) * 100)
        
        var newData: [Int: (CGFloat, CGFloat, CGFloat)] = [:]
        var indexData: [Int: Int] = [:]
        
        switch period {
        case .daily:
            data.forEach {
                if let index = Date().days(to: $0.date) {
                    newData[abs(index)] = (
                        CGFloat($0.values.0) / CGFloat(maxValue),
                        CGFloat($0.values.1) / CGFloat(maxValue),
                        CGFloat($0.values.2) / CGFloat(maxValue)
                    )
                }
            }
        case .weekly:
            data.forEach {
                if let index = Date().weeks(to: $0.date) {
                    newData[abs(index)] = (
                        (newData[abs(index)]?.0 ?? 0) + CGFloat($0.values.0) / CGFloat(maxValue),
                        (newData[abs(index)]?.1 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue),
                        (newData[abs(index)]?.2 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue)
                    )
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        case .monthly:
            data.forEach {
                if let index = Date().months(to: $0.date) {
                    newData[abs(index)] = (
                        (newData[abs(index)]?.0 ?? 0) + CGFloat($0.values.0) / CGFloat(maxValue),
                        (newData[abs(index)]?.1 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue),
                        (newData[abs(index)]?.2 ?? 0) + CGFloat($0.values.1) / CGFloat(maxValue)
                    )
                    indexData[abs(index)] = (indexData[abs(index)] ?? 0) + 1
                }
            }
        }
        
        newData.forEach {
            newData[$0.key] = (
                $0.value.0 / CGFloat(indexData[$0.key] ?? 1),
                $0.value.1 / CGFloat(indexData[$0.key] ?? 1),
                $0.value.2 / CGFloat(indexData[$0.key] ?? 1)
            )
        }
        
        return TripleDiagramChartData(
            data: newData,
            step: maxValue / view.getCountHorizontalLines()
        )
    }
}
