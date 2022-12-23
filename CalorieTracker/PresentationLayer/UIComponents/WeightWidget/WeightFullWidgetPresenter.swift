//
//  WeightFullWidgetPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

protocol WeightFullWidgetPresenterInterface: AnyObject {
    func getGoalWeight() -> CGFloat?
    func getStartDate(period: HistoryHeaderButtonType) -> Date?
    func getChartData(period: HistoryHeaderButtonType) -> [(date: Date, weight: CGFloat)]
    func getStartWeight(period: HistoryHeaderButtonType) -> CGFloat?
    func getNowWeight() -> CGFloat?
    func updateData()
}

class WeightFullWidgetPresenter {
    unowned var view: WeightFullWidgetInterface
    
    private lazy var chartData: [(date: Date, weight: CGFloat)] = []
    
    init(view: WeightFullWidgetInterface) {
        self.view = view
    }
    
    private func getAllChartData() -> [(date: Date, weight: CGFloat)] {
        let weightData = WeightWidgetService.shared.getAllWeight()
        let chartData: [(date: Date, weight: CGFloat)] = weightData.compactMap {
            guard let date = $0.day.date else { return nil }
            return (
                date: date,
                weight: CGFloat(BAMeasurement($0.value, .weight, isMetric: true).localized)
            )
        }
        return chartData
    }
}

extension WeightFullWidgetPresenter: WeightFullWidgetPresenterInterface {
    func updateData() {
        self.chartData = getAllChartData()
    }
    
    func getGoalWeight() -> CGFloat? {
        guard let goal = WeightWidgetService.shared.getWeightGoal() else {
            return nil
        }
        return CGFloat(BAMeasurement(goal, .weight, isMetric: true).localized)
    }
    
    func getNowWeight() -> CGFloat? {
        guard let weightNow = WeightWidgetService.shared.getWeightNow() else {
            return nil
        }
        return CGFloat(BAMeasurement(weightNow, .weight, isMetric: true).localized)
    }
    
    func getStartWeight(period: HistoryHeaderButtonType) -> CGFloat? {
        let newChartData = getChartData(period: period)
        return newChartData.min(by: { $0.date < $1.date })?.weight
    }
    
    func getStartDate(period: HistoryHeaderButtonType) -> Date? {
        let dateNow = Date()
        let calendar = Calendar.current
        var date: Date?
        
        switch period {
        case .weak:
            let newDate = calendar.date(byAdding: .day, value: -6, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .months:
            let newDate = calendar.date(byAdding: .month, value: -1, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .twoMonths:
            let newDate = calendar.date(byAdding: .month, value: -2, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .threeMonths:
            let newDate = calendar.date(byAdding: .month, value: -3, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .sixMonths:
            let newDate = calendar.date(byAdding: .month, value: -6, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .year:
            let newDate = calendar.date(byAdding: .year, value: -1, to: dateNow)
            date = newDate?.resetDate ?? Date()
        case .allTheTime:
            let newDate = chartData.min(by: { $0.date < $1.date })?.date
            date = newDate?.resetDate ?? Date()
        }
        
        return date
    }
    
    func getChartData(period: HistoryHeaderButtonType) -> [(date: Date, weight: CGFloat)] {
        let newChartData = chartData
        
        guard let startDate = getStartDate(period: period) else { return chartData }
        return newChartData.filter { $0.date >= startDate }.map {
            (date: $0.date.resetDate ?? Date(), weight: $0.weight)
        }
    }
}
