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
}

protocol DiagramChartViewPresenterInterface: AnyObject {
    func getData(_ period: ChartFormat) -> ChartData?
    func getStartDate(_ period: ChartFormat) -> Date?
}

class DiagramChartViewPresenter {
    unowned var view: DiagramChartViewInterface
    
    let data = [
        (date: Date(), value: 1200),
        (date: Date() - 84000 * 1, value: 2100),
        (date: Date() - 84000 * 2, value: 890),
        (date: Date() - 84000 * 3, value: 1450),
        (date: Date() - 84000 * 5, value: 1010),
        (date: Date() - 84000 * 6, value: 1201),
        (date: Date() - 84000 * 7, value: 2340),
        (date: Date() - 84000 * 9, value: 789),
        (date: Date() - 84000 * 10, value: 350),
        (date: Date() - 84000 * 11, value: 820),
        (date: Date() - 84000 * 12, value: 2040),
        (date: Date() - 84000 * 14, value: 250),
        (date: Date() - 84000 * 16, value: 2100),
        (date: Date() - 84000 * 17, value: 2100),
        (date: Date() - 84000 * 18, value: 2100),
        (date: Date() - 84000 * 20, value: 2100),
        (date: Date() - 84000 * 21, value: 2100),
        (date: Date() - 84000 * 22, value: 1904),
        (date: Date() - 84000 * 25, value: 2100),
        (date: Date() - 84000 * 27, value: 2100),
        (date: Date() - 84000 * 32, value: 2100),
        (date: Date() - 84000 * 33, value: 1460),
        (date: Date() - 84000 * 35, value: 2100),
        (date: Date() - 84000 * 40, value: 2100),
        (date: Date() - 84000 * 48, value: 2100),
        (date: Date() - 84000 * 64, value: 3100),
        (date: Date() - 84000 * 70, value: 3200)
    ]
    
    init(view: DiagramChartViewInterface) {
        self.view = view
    }
    
    private func getDataForPeriod(_ period: ChartFormat) -> [(date: Date, value: Int)]? {
        guard let startDate = getDate(period) else { return nil }
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
        let maxValue = max(3000, (getMaxValue(data) / 1000 + 1) * 1000)
        
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
            step: maxValue / view.getCountHorizontalLines()
        )
    }
}
