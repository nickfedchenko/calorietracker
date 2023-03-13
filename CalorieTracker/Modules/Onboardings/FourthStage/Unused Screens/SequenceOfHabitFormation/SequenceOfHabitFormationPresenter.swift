//
//  SequenceOfHabitFormationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol SequenceOfHabitFormationPresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class SequenceOfHabitFormationPresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: SequenceOfHabitFormationViewControllerInterface
//    let router: SequenceOfHabitFormationRouterInterface?
//    let interactor: SequenceOfHabitFormationInteractorInterface?
//    
//    // MARK: - Private properties
//
//    private var sequenceOfHabitFormation: [SequenceOfHabitFormation] = []
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: SequenceOfHabitFormationInteractorInterface,
//        router: SequenceOfHabitFormationRouterInterface,
//        view: SequenceOfHabitFormationViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - SequenceOfHabitFormationPresenterInterface
//
//extension SequenceOfHabitFormationPresenter: SequenceOfHabitFormationPresenterInterface {
//    func viewDidLoad() {
//        sequenceOfHabitFormation = interactor?.getAllSequenceOfHabitFormation() ?? []
//        
//        view.set(sequenceOfHabitFormation: sequenceOfHabitFormation)
//        
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//    func didTapContinueCommonButton() {
//        interactor?.set(sequenceOfHabitFormation: .logAllOfYoutMealsBeforeTheDayStarts)
//        router?.openSoundsGood()
//    }
//}
