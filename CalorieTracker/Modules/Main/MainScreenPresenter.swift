//
//  MainScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol MainScreenPresenterInterface: AnyObject {
    func didTapAddButton()
    func didTapMenuButton()
    func didTapBarcodeScannerButton()
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType)
    func updateWaterWidgetModel()
    func updateStepsWidget()
    func updateWeightWidget()
    func updateCalendarWidget(_ date: Date?)
    func updateMessageWidget()
    func updateActivityWidget()
    func updateExersiceWidget()
    func updateNoteWidget()
    func checkOnboarding()
    func didTapExerciseWidget()
    func didTapNotesWidget()
    func setPointDate(_ date: Date)
    func didTapMainWidget()
    func getPointDate() -> Date
}

class MainScreenPresenter {

    unowned var view: MainScreenViewControllerInterface
    let router: MainScreenRouterInterface?
    let interactor: MainScreenInteractorInterface?
    
    private var pointDate: Date? {
        didSet {
            didChangePointDate()
        }
    }

    init(
        interactor: MainScreenInteractorInterface,
        router: MainScreenRouterInterface,
        view: MainScreenViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func didChangePointDate() {
        updateNoteWidget()
        updateStepsWidget()
        updateWeightWidget()
        updateActivityWidget()
        updateExersiceWidget()
        updateWaterWidgetModel()
    }
}

extension MainScreenPresenter: MainScreenPresenterInterface {
    func checkOnboarding() {
        router?.openOnboarding()
    }
    
    func didTapMenuButton() {
        router?.openSettingsVC()
    }
    
    func didTapAddButton() {
        router?.openAddFoodVC()
    }
    
    func didTapMainWidget() {
        router?.openOpenMainWidget(pointDate ?? Date())
    }
    
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType) {
        router?.openWidget(type)
    }
    
    func updateWaterWidgetModel() {
        let date = pointDate ?? Date()
        
        let goal = BAMeasurement(
            WaterWidgetService.shared.getDailyWaterGoal(),
            .liquid,
            isMetric: true
        ).localized
        let waterNow = BAMeasurement(
            WaterWidgetService.shared.getWaterForDate(date),
            .liquid,
            isMetric: true
        ).localized
        let suffix = BAMeasurement.measurmentSuffix(.liquid)
        
        let model = WaterWidgetNode.Model(
            progress: CGFloat(waterNow / goal),
            waterMl: "\(Int(waterNow)) / \(Int(goal)) \(suffix)"
        )
        
        view.setWaterWidgetModel(model)
    }
    
    func updateStepsWidget() {
        let date = pointDate ?? Date()
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = StepsWidgetService.shared.getStepsForDate(date)
        
        view.setStepsWidget(now: Int(now), goal: goal)
    }
    
    func updateWeightWidget() {
        let date = pointDate ?? Date()
        guard let weightNow = WeightWidgetService.shared.getWeightForDate(date) else {
            view.setWeightWidget(weight: nil)
            return
        }
        view.setWeightWidget(weight: CGFloat(BAMeasurement(weightNow, .weight, isMetric: true).localized))
    }
    
    func updateCalendarWidget(_ date: Date? = UDM.currentlyWorkingDay.date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let calendarModel: CalendarWidgetNode.Model = .init(
            dateString: dateFormatter.string(from: date ?? Date()).uppercased(),
            date: date,
            daysStreak: CalendarWidgetService.shared.getStreakDays()
        )
        view.setCalendarWidget(calendarModel)
    }
    
    func updateMessageWidget() {
        let message: String = "Have a nice day! Don't forget to track your breakfast "
        
        view.setMessageWidget(message)
    }
    
    func updateNoteWidget() {
        guard let lastNote = NotesWidgetService.shared.getLastNote() else {
            view.setNoteWidget(nil)
            return
        }
        
        view.setNoteWidget(.init(
            estimation: lastNote.estimation,
            text: lastNote.text,
            photo: {
                guard let url = lastNote.imageUrl else { return nil }
                return UIImage(fileURLWithPath: url)
            }()
        ))
    }
    
    // swiftlint:disable:next function_body_length
    func updateActivityWidget() {
        let date = pointDate ?? Date()
        let nutritionDailyGoal = FDS.shared.getNutritionGoals() ?? .zero
        let nutritionToday = FDS.shared.getNutritionForDate(date).nutrition
        let kcalGoal = nutritionDailyGoal.kcal
        let carbsGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.carbs,
            type: .carbs,
            from: .kcal,
            to: .gram
        )
        let proteinGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.protein,
            type: .protein,
            from: .kcal,
            to: .gram
        )
        let fatGoal = NutrientMeasurment.convert(
            value: nutritionDailyGoal.fat,
            type: .fat,
            from: .kcal,
            to: .gram
        )
        let carbsToday = nutritionToday.carbs
        let proteinToday = nutritionToday.protein
        let fatToday = nutritionToday.fat
        let kcalToday = nutritionToday.kcal
        let burnedKcalFromExercises = ExerciseWidgetServise.shared.getBurnedKcalForDate(date)
        let burnedKCalFromSteps = StepsWidgetService.shared.getStepsNow() * 0.0608
        let includingBurned = kcalGoal + burnedKCalFromSteps + burnedKcalFromExercises - kcalToday
        let includingBurnedInt: Int = includingBurned < 0 ? 0 : Int(includingBurned)
        let model: MainWidgetViewNode.Model = .init(
            text: MainWidgetViewNode.Model.Text(
                firstLine: "\(Int(kcalToday)) / \(Int(kcalGoal)) " + R.string.localizable.kcalShort().uppercased(),
                secondLine: "\(Int(carbsToday)) / \(Int(carbsGoal)) " + R.string.localizable.carbsShort().uppercased(),
                thirdLine: "\(Int(proteinToday)) / \(Int(proteinGoal)) " + R.string.localizable.protein().uppercased(),
                fourthLine: "\(Int(fatToday)) / \(Int(fatGoal)) " + R.string.localizable.fatShort().uppercased(),
                excludingBurned: "\(UInt(kcalGoal - kcalToday < 0 ? 0 : kcalGoal - kcalToday))",
                includingBurned: "\(includingBurnedInt)"
            ),
            circleData: MainWidgetViewNode.Model.CircleData(
                rings: [
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: fatGoal != 0 ? fatToday / fatGoal : 0,
                        color: UIColor(hex: "4BE9FF"),
                        title: "F",
                        titleColor: UIColor(hex: "00899C"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: proteinGoal != 0 ? proteinToday / proteinGoal : 0,
                        color: UIColor(hex: "4BFF52"),
                        title: "P",
                        titleColor: UIColor(hex: "03B50A"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: carbsGoal != 0 ? carbsToday / carbsGoal : 0,
                        color: UIColor(hex: "FFE769"),
                        title: "C",
                        titleColor: UIColor(hex: "B89F1B"),
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: kcalGoal != 0 ? kcalToday / kcalGoal : 0,
                        color: UIColor(hex: "FF764B"),
                        title: nil,
                        titleColor: nil,
                        image: R.image.mainWidgetViewNode.burned()
                    )
                ]
            )
        )
        
        view.setActivityWidget(model)
    }
    
    func updateExersiceWidget() {
        let date = pointDate ?? Date()
        let exercises = ExerciseWidgetServise.shared.getExercisesForDate(date)
        let burnedKcal = ExerciseWidgetServise.shared.getBurnedKcalForDate(date)
        let burnedKcalGoal: Int? = {
            guard let goal = ExerciseWidgetServise.shared.getBurnedKclaGoal() else {
                return nil
            }
            return Int(goal)
        }()
        let model: ExercisesWidgetNode.Model = .init(
            exercises: exercises.map {
                .init(burnedKcal: Int($0.burnedKcal), exerciseType: $0.type)
            },
            progress: burnedKcal / CGFloat(burnedKcalGoal ?? 1),
            burnedKcal: Int(burnedKcal),
            goalBurnedKcal: burnedKcalGoal
        )
        
        view.setExersiceWidget(model, UDM.isAuthorisedHealthKit)
    }
    
    func didTapExerciseWidget() {
        if !UDM.isAuthorisedHealthKit {
            ExerciseWidgetServise.shared.syncWithHealthKit {
                DispatchQueue.main.async {
                    self.updateExersiceWidget()
                }
            }
        }
    }
    
    func didTapNotesWidget() {
        router?.openCreateNotesVC()
    }
    
    func setPointDate(_ date: Date) {
        self.pointDate = date
    }
    
    func didTapBarcodeScannerButton() {
        router?.openBarcodeScannerVC()
    }
    
    func getPointDate() -> Date {
        pointDate ?? Date()
    }
}
