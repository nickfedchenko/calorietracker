//
//  CreateMealRouter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation
import UIKit

protocol CreateMealRouterInterface: AnyObject {
    func openAddFoodVC(with searchRequest: String)
}

class CreateMealRouter: NSObject {

    weak var presenter: CreateMealPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule(mealTime: MealTime? = nil, editedMeal: Meal? = nil) -> CreateMealViewController {
        let vc = CreateMealViewController(mealTime: mealTime ?? .breakfast, editedMeal: editedMeal)
        let interactor = CreateMealInteractor()
        let router = CreateMealRouter()
        let presenter = CreateMealPresenter(interactor: interactor, router: router, view: vc)
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        router.viewController = vc
        
        return vc
    }
}

extension CreateMealRouter: CreateMealRouterInterface {
    
    func openAddFoodVC(with searchRequest: String) {
        let vc = AddFoodRouter.setupModule(
            addFoodYCoordinate: UDM.mainScreenAddButtonOriginY,
            tabBarIsHidden: true,
            searchRequest: nil,
            wasFromMealCreateVC: true,
            didSelectFood: { [weak self] food in
                self?.presenter?.addFood(food: food)
                LoggingService.postEvent(event: .diaryaddtomeal)
            },
            navigationType: .modal
        ) 
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
}
