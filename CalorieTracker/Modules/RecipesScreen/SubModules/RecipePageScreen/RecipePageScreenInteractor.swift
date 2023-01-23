//
//  RecipePageScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 12.01.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol RecipePageScreenInteractorInterface: AnyObject {
    func getDish() -> Dish
    func getNumberOfTags() -> Int
    func getTagModel(at indexPath: IndexPath) -> RecipeTagModel
    func getTotalKcalGoal() -> Double
    func getTotalFatGoal() -> Double
    func getTotalProteinGoal() -> Double
    func getTotalCarbsGoal() -> Double
    func getCurrentlyEatenKCal() -> Double
    func getCurrentlyEatenFat() -> Double
    func getCurrentlyEatenProtein() -> Double
    func getCurrentlyEatenCarbs() -> Double
    func makeModelsForIngredients() -> [RecipeIngredientModel]
    func updateCurrentServingsCount(to count: Int)
    func getInstructions() -> [String]
    func setCurrentSelectAmountToEat(amount: Int)
    func addSelectedPortionsToEaten()
    
    var possibleEatenKcalBySelectedServings: Double { get }
    var possibleEatenFatBySelectedServings: Double { get }
    var possibleEatenProteinBySelectedServings: Double { get }
    var possibleEatenCarbsBySelectedServings: Double { get }
}

class RecipePageScreenInteractor {
    
    weak var presenter: RecipePageScreenPresenterInterface?
    
    private let dataService: FoodDataServiceInterface = FDS.shared
    var dish: Dish
    var tags: [RecipeTagModel] = []
    private var selectedServingsAmount: Int = 0
    private var selectedServingToEat: Int = 1
    
    // TODO: - По идее данные после онбординга должны быть
    private lazy var dailyGoals: DailyNutrition? = dataService.getNutritionGoals()
    private var currentGoalsData: DailyNutritionData = .init(
        day: .init(Date()),
        nutrition: .init(
            kcal: 320,
            carbs: 2,
            protein: 1,
            fat: 3.2
        )
    )
    
    var possibleEatenKcalBySelectedServings: Double {
        let ratio = Double(selectedServingToEat) / Double((dish.totalServings ?? 1))
        return (dish.values?.serving.kcal ?? 0) * ratio
    }
    
    var possibleEatenFatBySelectedServings: Double {
        let ratio = Double(selectedServingToEat) / Double((dish.totalServings ?? 1))
        return (dish.values?.serving.fats ?? 0) * ratio
    }
    
    var possibleEatenProteinBySelectedServings: Double {
        let ratio = Double(selectedServingToEat) / Double((dish.totalServings ?? 1))
        return (dish.values?.serving.proteins ?? 0) * ratio
    }
    
    var possibleEatenCarbsBySelectedServings: Double {
        let ratio = Double(selectedServingToEat) / Double((dish.totalServings ?? 1))
        return (dish.values?.serving.carbohydrates ?? 0) * ratio
    }
    
    init(with dish: Dish) {
        self.dish = dish
        makeTagsToDisplay()
        setGoals()
        setCurrentNutritionData()
        setDefaultServingsAmount()
        print("Got ingredients models \(makeModelsForIngredients()) ")
    }
    
    private func setDefaultServingsAmount() {
        selectedServingsAmount = dish.totalServings ?? 0
    }
    
    private func setGoals() {
        guard let goals = dataService.getNutritionGoals() else {
            return
        }
        dailyGoals = goals
    }
    
    private func setCurrentNutritionData() {
        currentGoalsData = dataService.getNutritionToday()
    }
    
    private func makeTagsToDisplay() {
        tags = dish.dishTypeTags.map {
            RecipeTagModel(
                title: UDM.titlesForFilterTags[$0.convenientTag ?? .vegan] ?? "",
                color: $0.tagColorRepresentation?.baseColor ?? .white
            )
        }
        
        tags += dish.additionalTags.map {
            RecipeTagModel(
                title: UDM.titlesForFilterTags[$0.convenientTag ?? .vegan] ?? "",
                color: $0.tagColorRepresentation?.baseColor ?? .white
            )
        }
        
        tags += dish.dietTags.map {
            RecipeTagModel(
                title: UDM.titlesForFilterTags[$0.convenientTag ?? .vegan] ?? "",
                color: $0.tagColorRepresentation?.baseColor ?? .white
            )
        }
        
        tags += dish.eatingTags.map {
            RecipeTagModel(
                title: UDM.titlesForFilterTags[$0.convenientTag ?? .vegan] ?? "",
                color: $0.tagColorRepresentation?.baseColor ?? .white
            )
        }
        
        tags += dish.processingTypeTags.map {
            RecipeTagModel(
                title: UDM.titlesForFilterTags[$0.convenientTag ?? .vegan] ?? "",
                color: $0.tagColorRepresentation?.baseColor ?? .white
            )
        }
        
        tags += dish.exceptionTags.compactMap {
            if $0.id == 19 {
                return nil
                
            } else {
                return RecipeTagModel(
                    title: UDM.titlesForExceptionTags[$0.convenientTag ?? .beef] ?? "",
                    color: $0.colorRepresentationTag?.baseColor ?? .white
                )
            }
        }
        tags.sort(by: { $0.title.count < $1.title.count })
    }
}

extension RecipePageScreenInteractor: RecipePageScreenInteractorInterface {
    func setCurrentSelectAmountToEat(amount: Int) {
        selectedServingToEat = amount
    }
    
    func makeModelsForIngredients() -> [RecipeIngredientModel] {
        let ratio = Double(selectedServingsAmount) / Double(dish.totalServings ?? 1)
        print("ratio is \(ratio)")
        let models: [RecipeIngredientModel] = dish.ingredients.compactMap { ingredient in
            if
                let referenceUnit = ingredient.product.units.first(where: { $0.id == ingredient.unit?.id }),
                let referenceKCal = referenceUnit.kcal {
                let unitAmount = ingredient.quantity * ratio
                let unitTitle = ingredient.unit?.shortTitle ?? ""
                let kcal = unitAmount * referenceKCal
                let title = ingredient.product.title
                return .init(title: title, unitTitle: unitTitle, unitsAmount: unitAmount, kcal: kcal)
            } else {
                return nil
            }
        }
        return models
    }
    
    func getTotalKcalGoal() -> Double {
        dailyGoals?.kcal ?? 0
    }
    
    func getTotalFatGoal() -> Double {
        NutrientMeasurment.convert(value: dailyGoals?.fat ?? 0, type: .fat, from: .kcal, to: .gram)
    }
    
    func getTotalProteinGoal() -> Double {
        NutrientMeasurment.convert(value: dailyGoals?.protein ?? 0, type: .protein, from: .kcal, to: .gram)
    }
    
    func getTotalCarbsGoal() -> Double {
        NutrientMeasurment.convert(value: dailyGoals?.carbs ?? 0, type: .carbs, from: .kcal, to: .gram)
    }
    
    func getCurrentlyEatenKCal() -> Double {
        currentGoalsData.nutrition.kcal
    }
    
    func getCurrentlyEatenFat() -> Double {
        NutrientMeasurment.convert(value: currentGoalsData.nutrition.fat, type: .fat, from: .kcal, to: .gram)
    }
    
    func getCurrentlyEatenProtein() -> Double {
        NutrientMeasurment.convert(value: currentGoalsData.nutrition.protein, type: .protein, from: .kcal, to: .gram)
    }
    
    func getCurrentlyEatenCarbs() -> Double {
        NutrientMeasurment.convert(value: currentGoalsData.nutrition.carbs, type: .carbs, from: .kcal, to: .gram)
    }
    
    func getDish() -> Dish {
        dish
    }
    
    func getNumberOfTags() -> Int {
        tags.count
    }
    
    func getTagModel(at indexPath: IndexPath) -> RecipeTagModel {
        tags[indexPath.item]
    }
    
    func updateCurrentServingsCount(to count: Int) {
        selectedServingsAmount = count
    }
    
    func getInstructions() -> [String] {
        dish.instructions ?? []
    }
    
    func addSelectedPortionsToEaten() {
        dataService.addNutrition(
            day: .init(Date()),
            nutrition: .init(
                kcal: possibleEatenKcalBySelectedServings,
                carbs: NutrientMeasurment.convert(
                    value: possibleEatenCarbsBySelectedServings,
                    type: .carbs,
                    from: .gram,
                    to: .kcal
                ),
                protein: NutrientMeasurment.convert(
                    value: possibleEatenProteinBySelectedServings,
                    type: .protein,
                    from: .gram,
                    to: .kcal
                ),
                fat: NutrientMeasurment.convert(
                    value: possibleEatenFatBySelectedServings,
                    type: .fat,
                    from: .gram,
                    to: .kcal
                )
            )
        )
    }
}
