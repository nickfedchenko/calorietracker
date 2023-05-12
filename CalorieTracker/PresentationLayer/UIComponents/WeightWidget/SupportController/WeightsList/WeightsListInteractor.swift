//
//  WeightsListInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
protocol WeightsListInteractorInterface: AnyObject {
    func makeModelsFor(mode: WeightsListPresenter.SelectedMode, isFromHK: Bool) -> [WeightsListCellType]
    func deleteModel(model: WeightsListCellType)
}

class WeightsListInteractor {
    weak var presenter: WeightsListPresenterInterface?
    private let weightService = WeightWidgetService.shared
    
}

extension WeightsListInteractor: WeightsListInteractorInterface {
    func makeModelsFor(mode: WeightsListPresenter.SelectedMode, isFromHK: Bool) -> [WeightsListCellType] {
        
        var allWeights = getWeights()
        allWeights = allWeights.filter { $0.isFromHK == isFromHK }.sorted(by: { $0.day < $1.day })
      
        allWeights.sort { $0.day < $1.day }
        switch mode {
        case .daily:
            let formatter = DateFormatter()
            return allWeights.compactMap { dailyData in
                if dailyData.day.year != Date().day.year {
                    formatter.dateFormat = "LLLL dd - yyyy"
                } else {
                    formatter.dateFormat = "LLLL dd"
                }
                let model = WeightsListCellModel(
                    dateString: formatter.string(from: dailyData.day.date ?? Date()).capitalized,
                    descriptionString: "",
                    valueLabel: BAMeasurement(dailyData.value, .weight).string(with: 1),
                    preciseDate: dailyData.day.date
                )
                return .daily(model: model)
            }
        case .weekly:
           guard
            let minDate = allWeights.min(by: { $0.day < $1.day })?.day.date?.resetDate,
            let maxDate = allWeights.max(by: { $0.day < $1.day })?.day.date?.endOfDay else {
               return []
           }
            var dataSet: [ClosedRange<Date>: Double] = [:]
            var anchorDate: Date = maxDate
            while anchorDate > minDate {
                guard let backWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: anchorDate) else {
                    return []
                }
                guard dataSet[backWeekDate...anchorDate] == nil else {
                    continue
                }
                let targetData = allWeights.filter {
                    if let date = $0.day.date {
                        if (backWeekDate...anchorDate).contains(date) {
                            return true
                        } else {
                            return  false
                        }
                    } else {
                        return false
                    }
                }
                guard !targetData.isEmpty else {
                    anchorDate = backWeekDate
                    continue
                }
                let average = targetData
                    .reduce(0) { $0 + $1.value } / Double(!targetData.isEmpty ? targetData.count : 1)
                dataSet[backWeekDate...anchorDate] = average
                anchorDate = backWeekDate
            }
            return dataSet.compactMap { dateRange, averageValue in
                let lowerDate = dateRange.lowerBound
                let upperDate = dateRange.upperBound
                let formatter = DateFormatter()
                formatter.dateFormat = "LLL dd, yyyy"
                let lowerDateString = formatter.string(from: lowerDate)
                let upperDateString = formatter.string(from: upperDate)
                let model = WeightsListCellModel(
                    dateString: "\(lowerDateString) - \(upperDateString)" ,
                    descriptionString: R.string.localizable.chartRightBottomTitle().uppercased(),
                    valueLabel: BAMeasurement(averageValue, .weight).string(with: 1),
                    preciseDate: lowerDate
                )
                return .weekly(model: model)
            }.sorted(by: {
                switch ($0, $1) {
                    
                case (.weekly(model: let lhsModel), .weekly(model: let rhsModel)):
                    if let lhsDate = lhsModel.preciseDate, let rhsDate = rhsModel.preciseDate {
                        return lhsDate < rhsDate
                    } else {
                        return false
                    }
                default:
                    return false
                }
                
            })
        case .monthly:
            guard
                let minDate = allWeights.min(by: { $0.day < $1.day })?.day.date?.resetDate,
                let maxDate = allWeights.max(by: { $0.day < $1.day })?.day.date,
                let realMinDate = Calendar
                    .current
                    .date(
                        from: Calendar.current.dateComponents(
                            [.year, .month],
                            from: Calendar.current.startOfDay(for: minDate)
                        )
                    ),
            let realMaxMonthStartOfMonth = Calendar
                    .current
                    .date(
                        from: Calendar.current.dateComponents(
                            [.year, .month],
                            from: Calendar.current.startOfDay(for: maxDate)
                        )
                    ),
            let realMaxDate = Calendar
                    .current.date(byAdding: DateComponents(month: 1, day: -1), to: realMaxMonthStartOfMonth) else {
                return []
            }
            var dataSet: [ClosedRange<Date>: Double] = [:]
            var anchorDate: Date = realMinDate
            
            while anchorDate < realMaxDate {
               guard let currentStartDate = Calendar
                    .current
                    .date(
                        from: Calendar.current.dateComponents(
                            [.year, .month],
                            from: Calendar.current.startOfDay(for: anchorDate)
                        )
                    ),
                let endOfMonth = Calendar
                .current.date(byAdding: DateComponents(month: 1, day: -1), to: currentStartDate) else {
                   return []
               }
                guard dataSet[anchorDate...endOfMonth] == nil else { continue }
                
                let targetData = allWeights.filter {
                    if let date = $0.day.date {
                        if (anchorDate...endOfMonth).contains(date) {
                            return true
                        } else {
                            return  false
                        }
                    } else {
                        return false
                    }
                }
                
                guard !targetData.isEmpty else {
                    anchorDate = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth) ?? Date()
                    continue
                }
                let average = targetData
                    .reduce(0) { $0 + $1.value } / Double(!targetData.isEmpty ? targetData.count : 1)
                dataSet[anchorDate...endOfMonth] = average
                anchorDate = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth) ?? Date()
                
            }
            return dataSet.compactMap { dateRange, averageValue in
                let lowerDate = dateRange.lowerBound
                let formatter = DateFormatter()
                formatter.dateFormat = "LLLL yyyy"
                let monthDate = formatter.string(from: lowerDate)
                let model = WeightsListCellModel(
                    dateString: monthDate.capitalized,
                    descriptionString: R.string.localizable.chartRightBottomTitle().uppercased(),
                    valueLabel: BAMeasurement(averageValue, .weight).string(with: 1),
                    preciseDate: lowerDate
                )
                return .monthly(model: model)
            }.sorted(by: {
                switch ($0, $1) {
                    
                case (.monthly(model: let lhsModel), .monthly(model: let rhsModel)):
                    if let lhsDate = lhsModel.preciseDate, let rhsDate = rhsModel.preciseDate {
                        return lhsDate < rhsDate
                    } else {
                        return false
                    }
                default:
                    return false
                }
            })
        }
    }
    
    func getWeights() -> [DailyData] {
        weightService.getAllWeight()
    }
    
    func deleteModel(model: WeightsListCellType) {
        var modelToDelete: WeightsListCellModel?
        switch model {
        case .daily(let model):
            modelToDelete = model
        case .weekly:
            return
        case .monthly:
            return
        }
        
        guard let modelToDelete = modelToDelete else { return }
        let dateString = modelToDelete.dateString
        guard let preciseDate = modelToDelete.preciseDate else { return }
        weightService.deleteRecordAt(day: preciseDate.day)
        HealthKitDataManager.shared.deleteWeights(at: preciseDate.day)
    }
}
