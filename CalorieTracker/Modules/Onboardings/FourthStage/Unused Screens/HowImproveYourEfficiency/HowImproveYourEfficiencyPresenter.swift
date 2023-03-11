//
//  HowImproveYourEfficiencyPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol HowImproveYourEfficiencyPresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class HowImproveYourEfficiencyPresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: HowImproveYourEfficiencyViewControllerInterface
//    let router: HowImproveYourEfficiencyRouterInterface?
//    let interactor: HowImproveYourEfficiencyInteractorInterface?
//    
//    // MARK: - Private properties
//
//    private var howImproveYourEfficiency: [HowImproveYourEfficiency] = []
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: HowImproveYourEfficiencyInteractorInterface,
//        router: HowImproveYourEfficiencyRouterInterface,
//        view: HowImproveYourEfficiencyViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - HowImproveYourEfficiencyPresenterInterface
//
//extension HowImproveYourEfficiencyPresenter: HowImproveYourEfficiencyPresenterInterface {
//    func viewDidLoad() {
//        howImproveYourEfficiency = interactor?.getAllHowImproveYourEfficiency() ?? []
//        
//        view.set(howImproveYourEfficiency: howImproveYourEfficiency)
//        
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//    
//    func didTapContinueCommonButton() {
//        interactor?.set(howImproveYourEfficiency: .exploringNewTypesOfActivity)
//        router?.openRepresentationOfIncreasedActivityLevels()
//    }
//}
