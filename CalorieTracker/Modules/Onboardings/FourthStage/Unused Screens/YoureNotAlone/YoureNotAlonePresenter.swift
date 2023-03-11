//
//  YoureNotAlonePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol YoureNotAlonePresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class YoureNotAlonePresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: YoureNotAloneViewControllerInterface
//    let router: YoureNotAloneRouterInterface?
//    let interactor: YoureNotAloneInteractorInterface?
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: YoureNotAloneInteractorInterface,
//        router: YoureNotAloneRouterInterface,
//        view: YoureNotAloneViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - YoureNotAlonePresenterInterface
//
//extension YoureNotAlonePresenter: YoureNotAlonePresenterInterface {
//    func viewDidLoad() {
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//        
//    func didTapContinueCommonButton() {
//        router?.openDifficultyChoosingLifestyle()
//    }
//}
