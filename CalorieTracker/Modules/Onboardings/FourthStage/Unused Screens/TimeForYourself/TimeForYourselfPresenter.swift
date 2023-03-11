//
//  TimeForYourselfPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

//import Foundation
//
//protocol TimeForYourselfPresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class TimeForYourselfPresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: TimeForYourselfViewControllerInterface
//    let router: TimeForYourselfRouterInterface?
//    let interactor: TimeForYourselfInteractorInterface?
//    
//    // MARK: - Private properties
//
//    private var timeForYourself: [TimeForYourself] = []
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: TimeForYourselfInteractorInterface,
//        router: TimeForYourselfRouterInterface,
//        view: TimeForYourselfViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - TimeForYourselfPresenterInterface
//
//extension TimeForYourselfPresenter: TimeForYourselfPresenterInterface {
//    func viewDidLoad() {
//        timeForYourself = interactor?.getAllTimeForYourself() ?? []
//        
//        view.set(timeForYourself: timeForYourself)
//        
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//    
//    func didTapContinueCommonButton() {
//        interactor?.set(timeForYourself: .asMuchAsWant)
//        router?.openJointWeightLoss()
//    }
//}
