//
//  FoodViewingPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol FoodViewingPresenterInterface: AnyObject {

}

class FoodViewingPresenter {
    
    unowned var view: FoodViewingViewControllerInterface
    let router: FoodViewingRouterInterface?
    let interactor: FoodViewingInteractorInterface?
    
    init(
        interactor: FoodViewingInteractorInterface,
        router: FoodViewingRouterInterface,
        view: FoodViewingViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FoodViewingPresenter: FoodViewingPresenterInterface {
    
}
