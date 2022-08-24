//
//  AchievingDifficultGoalPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievingDifficultGoalPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectAchievingDifficultGoal(with index: Int)
    func didDeselectAchievingDifficultGoal()
}

class AchievingDifficultGoalPresenter {
    
    unowned var view: AchievingDifficultGoalViewControllerInterface
    let router: AchievingDifficultGoalRouterInterface?
    let interactor: AchievingDifficultGoalInteractorInterface?
    
    private var achievingDifficultGoal: [AchievingDifficultGoal] = []
    private var achievingDifficultGoalIndex: Int?

    init(
        interactor: AchievingDifficultGoalInteractorInterface,
        router: AchievingDifficultGoalRouterInterface,
        view: AchievingDifficultGoalViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AchievingDifficultGoalPresenter: AchievingDifficultGoalPresenterInterface {
    func viewDidLoad() {
        achievingDifficultGoal = interactor?.getAllAchievingDifficultGoal() ?? []
        
        view.set(achievingDifficultGoal: achievingDifficultGoal)
    }
    
    func didTapNextCommonButton() {
        interactor?.set(achievingDifficultGoal: .naturalWillpowerAndMentalStrength)
        router?.openAchievementByWillpower()
    }
    
    func didSelectAchievingDifficultGoal(with index: Int) {
        achievingDifficultGoalIndex = index
    }
    
    func didDeselectAchievingDifficultGoal() {
        achievingDifficultGoalIndex = nil
    }
}
