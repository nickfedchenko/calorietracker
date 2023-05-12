//
//  MessagesTextService.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 05.05.2023.
//

import UIKit

final class MessagesTextService {
    static let shared = MessagesTextService()
    
    private init() {}
    
    private var updateHandler: ((NSAttributedString?) -> Void)?
    
    var didAddSnack: Bool {
        let meals = FDS.shared.getAllStoredDailyMeals()
        return meals.contains(where: { meal in
            meal.date == Date().day && meal.mealTime == .snack
        })
    }
    
    var didAddBreakfast: Bool {
        let meals = FDS.shared.getAllStoredDailyMeals()
        return meals.contains(where: { meal in
            meal.date == Date().day && meal.mealTime == .breakfast
        })
    }
    
    var didAddLunch: Bool {
        let meals = FDS.shared.getAllStoredDailyMeals()
        return meals.contains(where: { meal in
            meal.date == Date().day && meal.mealTime == .lunch
        })
    }
    
    var didAddDinner: Bool {
        let meals = FDS.shared.getAllStoredDailyMeals()
        return meals.contains(where: { meal in
            meal.date == Date().day && meal.mealTime == .dinner
        })
    }
    
    var didAddWater: Bool {
        let waterRecords = DSF.shared.getAllStoredWater()
        guard
            let endOfCurrentDay = Date().endOfDay,
            let threeDaysBefore = Calendar
                .current
                .date(byAdding: .day, value: -3, to: endOfCurrentDay)?.resetDate else {
            return false
        }
        
        return waterRecords.contains(where: { waterRecord in
            return (threeDaysBefore...endOfCurrentDay).contains(waterRecord.day.date ?? Date())
        })
    }
    
    var didAddWeightThisWeek: Bool {
        let weights = WeightWidgetService.shared.getAllWeight()
        if let currentDate = Date().endOfDay,
           let weekAgo = Calendar.current.date(byAdding: .day, value: -6, to: currentDate)?.resetDate {
            return weights.contains(where: { weight in
                return  (weekAgo...currentDate).contains(weight.day.date ?? Date())
            })
        } else {
            return false
        }
    }
    
    private var messagesBuffer: [Text] = []
    
    var shouldUseWaterReminder: Bool {
        let mealData = FDS.shared.getAllStoredDailyMeals()
        if
            let currentEndDay = Date().endOfDay,
            let threeDaysBefore = Calendar.current.date(byAdding: .day, value: -3, to: currentEndDay)?.resetDate {
            let haveMealRecords = mealData.contains(where: {
                (threeDaysBefore...currentEndDay).contains($0.date.date ?? Date())
            })
            
            let waterRecords = WaterWidgetService.shared.getAllWaterData()
            let haveWaterRecords = waterRecords.contains(where: {
                (threeDaysBefore...currentEndDay).contains($0.day.date ?? Date())
            })
            return haveMealRecords && haveWaterRecords
        } else {
            return true
        }
    }
    
    func subscribeToChanges(handler: @escaping (NSAttributedString?) -> Void) {
        updateHandler = handler
    }
    
    func anyEventTriggered() {
        switch whatMealTimeIsNow() {
        case .breakfast:
            switch (didAddBreakfast, didAddWater, didAddSnack, didAddWeightThisWeek) {
            case (false, _, _, _):
                messagesBuffer = [.breakfastReminderCase]
            case (true, _, _, false):
                messagesBuffer = [.weightReminderCase]
            case (true, false, _, true):
                messagesBuffer = [.waterReminderCase]
            case (true, true, false, true):
                messagesBuffer = [.snacksReminderCase]
            case (true, true, true, true):
                messagesBuffer = [.allSet]
            }
      
        case .lunch:
            switch (didAddLunch, didAddWater, didAddSnack, didAddWeightThisWeek) {
            case (false, _, _, _):
                messagesBuffer = [.lunchReminderCase]
            case (true, _, _, false):
                messagesBuffer = [.weightReminderCase]
            case (true, false, _, true):
                messagesBuffer = [.waterReminderCase]
            case (true, true, false, true):
                messagesBuffer = [.snacksReminderCase]
            case (true, true, true, true):
                messagesBuffer = [.allSet]
            }
        case .dinner:
            switch (didAddDinner, didAddWater, didAddSnack, didAddWeightThisWeek) {
            case (false, _, _, _):
                messagesBuffer = [.dinnerReminderCase]
            case (true, _, _, false):
                messagesBuffer = [.weightReminderCase]
            case (true, false, _, true):
                messagesBuffer = [.waterReminderCase]
            case (true, true, false, true):
                messagesBuffer = [.snacksReminderCase]
            case (true, true, true, true):
                messagesBuffer = [.allSet]
            }
        case .snack:
            switch (didAddSnack, didAddWater, didAddWeightThisWeek) {
            case (false, _, _):
                messagesBuffer = [.snacksReminderCase]
            case (true, _, false):
                messagesBuffer = [.weightReminderCase]
            case (true, false, _):
                messagesBuffer = [.waterReminderCase]
            case (true, true, true):
                messagesBuffer = [.allSet]
            }
        }
        
        updateHandler?(messagesBuffer.randomElement()?.attributedString)
    }
    
    func whatMealTimeIsNow() -> MealTime {
        var mealTime: MealTime = .breakfast
        let date = Date()
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        if
            let hours = components.hour,
            let minutes = components.minute {
            switch (hours, minutes) {
            case (4...11, 0...59), (12, 0):
                mealTime = .breakfast
            case (12, 1), (12...15, 0...59), (16, 0) :
                mealTime = .lunch
            case (22, 0), (18...21, 0...59):
                mealTime = .dinner
            default:
                mealTime = .snack
            }
        }
        return mealTime
    }
}

extension MessagesTextService {
    enum Text {
        case breakfastReminderCase
        case lunchReminderCase
        case dinnerReminderCase
        case snacksReminderCase
        case waterReminderCase
        case weightReminderCase
        case allSet
        
        var attributedString: NSAttributedString {
            switch self {
            case .breakfastReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesBreakfastReminderCase1(),
                        R.string.localizable.messagesBreakfastReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .lunchReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesLunchReminderCase1(),
                        R.string.localizable.messagesLunchReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .dinnerReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesDinnerReminderCase1(),
                        R.string.localizable.messagesDinnerReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .snacksReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesSnacksReminderCase1(),
                        R.string.localizable.messagesSnacksReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .waterReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesWaterReminderCase1(),
                        R.string.localizable.messagesWaterReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .weightReminderCase:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesWeightReminderCase1(),
                        R.string.localizable.messagesWeightReminderCase2()
                    ][Int.random(in: 0...1)]
                )
            case .allSet:
                return makeAttributedString(
                    string: [
                        R.string.localizable.messagesAllSetCase1(),
                        R.string.localizable.messagesAllSetCase2()
                    ][Int.random(in: 0...1)]
                )
            }
        }
        
        private func makeAttributedString(string: String) -> NSAttributedString {
            let attrString = NSAttributedString(
                string: string,
                attributes: [
                    .foregroundColor: UIColor(hex: "192621"),
                    .font: R.font.sfProRoundedMedium(size: 18) ?? .systemFont(ofSize: 18)
                ]
            )
            return attrString
        }
    }
}
