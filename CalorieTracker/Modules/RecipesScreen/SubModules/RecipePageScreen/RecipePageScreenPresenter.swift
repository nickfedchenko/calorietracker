//
//  RecipePageScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 12.01.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol RecipePageScreenPresenterInterface: AnyObject {
    func getHeaderTitle() -> String
    func getIngredients() -> [Ingredient]
    func getInstructions() -> [String]
    func getDish() -> Dish?
    func askForNumberOfTags() -> Int
    func getTagModel(for indexPath: IndexPath) -> RecipeTagModel?
    func getModeForCarbs() -> RecipeRoundProgressView.ProgressMode
    func getModeForKcal() -> RecipeRoundProgressView.ProgressMode
    func getModeForFat() -> RecipeRoundProgressView.ProgressMode
    func getModeForProtein() -> RecipeRoundProgressView.ProgressMode
    func getModelsForIngredients() -> [RecipeIngredientModel]
    func didChangeServing(to count: Int)
    func didChangeAmountToEat(amount: Int)
    func addToDiaryTapped()
}

class RecipePageScreenPresenter {

    unowned var view: RecipePageScreenViewControllerInterface
    let router: RecipePageScreenRouterInterface?
    let interactor: RecipePageScreenInteractorInterface?

    init(
        interactor: RecipePageScreenInteractorInterface,
        router: RecipePageScreenRouterInterface,
        view: RecipePageScreenViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension RecipePageScreenPresenter: RecipePageScreenPresenterInterface {
    func getModelsForIngredients() -> [RecipeIngredientModel] {
        interactor?.makeModelsForIngredients() ?? []
    }
    func getModeForCarbs() -> RecipeRoundProgressView.ProgressMode {
        return .carbs(
            total: interactor?.getTotalCarbsGoal() ?? 0,
            possible: interactor?.possibleEatenCarbsBySelectedServings ?? 0 ,
            eaten: interactor?.getCurrentlyEatenCarbs() ?? 0
        )
    }
    
    func getModeForKcal() -> RecipeRoundProgressView.ProgressMode {
        return .kcal(
            total: interactor?.getTotalKcalGoal() ?? 0,
            possible: interactor?.possibleEatenKcalBySelectedServings ?? 0 ,
            eaten: interactor?.getCurrentlyEatenKCal() ?? 0
        )
    }
    
    func getModeForFat() -> RecipeRoundProgressView.ProgressMode {
        return .fat(
            total: interactor?.getTotalFatGoal() ?? 0,
            possible: interactor?.possibleEatenFatBySelectedServings ?? 0,
            eaten: interactor?.getCurrentlyEatenFat() ?? 0
        )
    }
    
    func getModeForProtein() -> RecipeRoundProgressView.ProgressMode {
        return .protein(
            total: interactor?.getTotalProteinGoal() ?? 0,
            possible: interactor?.possibleEatenProteinBySelectedServings ?? 0,
            eaten: interactor?.getCurrentlyEatenProtein() ?? 0
        )
    }
    
    func getDish() -> Dish? {
        interactor?.getDish()
    }
    
    func getInstructions() -> [String] {
        return interactor?.getInstructions() ?? []
    }
    
    func getHeaderTitle() -> String {
        return ""
    }
    
    func getIngredients() -> [Ingredient] {
        guard let dish = interactor?.getDish() else { return [] }
        return dish.ingredients
    }
    
    func askForNumberOfTags() -> Int {
        interactor?.getNumberOfTags() ?? 0
    }
    
    func getTagModel(for indexPath: IndexPath) -> RecipeTagModel? {
        interactor?.getTagModel(at: indexPath)
    }
    
    func didChangeServing(to count: Int) {
        interactor?.updateCurrentServingsCount(to: count)
        let updateModels = interactor?.makeModelsForIngredients() ?? []
        view.shouldUpdateIngredients(with: updateModels)
    }
    
    func didChangeAmountToEat(amount: Int) {
        interactor?.setCurrentSelectAmountToEat(amount: amount)
        view.shouldUpdateProgressView(
            carbsData: getModeForCarbs(),
            kcalData: getModeForKcal(),
            fatData: getModeForFat(),
            proteinData: getModeForProtein()
        )
    }
    
    func addToDiaryTapped() {
        interactor?.addSelectedPortionsToEaten()
        router?.dismiss()
    }
}
