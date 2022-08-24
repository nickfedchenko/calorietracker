//
//  ObsessingOverFoodPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectObsessingOverFood(with index: Int)
    func didDeselectObsessingOverFood()
}

class ObsessingOverFoodPresenter {
    
    unowned var view: ObsessingOverFoodViewControllerInterface
    let router: ObsessingOverFoodRouterInterface?
    let interactor: ObsessingOverFoodInterctorInterface?

    private var obsessingOverFood: [ObsessingOverFood] = []
    private var obsessingOverFoodIndex: Int?
    
    init(
        interactor: ObsessingOverFoodInterctorInterface,
        router: ObsessingOverFoodRouterInterface,
        view: ObsessingOverFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ObsessingOverFoodPresenter: ObsessingOverFoodPresenterInterface {
    func viewDidLoad() {
        obsessingOverFood = interactor?.getAllObsessingOverFood() ?? []
        
        view.set(obsessingOverFood: obsessingOverFood)
    }
    
    func didTapNextCommonButton() {
        interactor?.set(obsessingOverFood: .yesDefinitely)
        router?.openTheEffectOfWeight()
    }
    
    func didSelectObsessingOverFood(with index: Int) {
        obsessingOverFoodIndex = index
    }
    
    func didDeselectObsessingOverFood() {
        obsessingOverFoodIndex = nil
    }
}
