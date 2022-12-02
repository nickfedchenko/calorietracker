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
}

class WeightFullWidgetPresenter {
    unowned var view: WeightFullWidgetInterface
    
    private let chartData: [(date: Date, weight: CGFloat)] = {
        let weightData = WeightWidgetService.shared.getAllWeight()
        let chartData: [(date: Date, weight: CGFloat)] = weightData.compactMap {
            guard let date = $0.day.date else { return nil }
            return (date: date, weight: CGFloat($0.value))
        }
        return chartData
    }()
    
    init(view: WeightFullWidgetInterface) {
        self.view = view
    }
}

extension WeightFullWidgetPresenter: WeightFullWidgetPresenterInterface {
    func getGoalWeight() -> CGFloat? {
        guard let goal = WeightWidgetService.shared.getWeightGoal() else {
            return nil
        }
        return CGFloat(goal)
    }
    
    func getNowWeight() -> CGFloat? {
        guard let weightNow = WeightWidgetService.shared.getWeightNow() else {
            return nil
        }
        return CGFloat(weightNow)
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
