//
//  ThoughtsAboutChangingFeelingsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

//import Foundation
//
//protocol ThoughtsAboutChangingFeelingsPresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class ThoughtsAboutChangingFeelingsPresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: ThoughtsAboutChangingFeelingsViewControllerInterface
//    let router: ThoughtsAboutChangingFeelingsRouterInterface?
//    let interactor: ThoughtsAboutChangingFeelingsInteractorInterface?
//    
//    // MARK: - Private properties
//
//    private var thoughtsAboutChangingFeelings: [ThoughtsAboutChangingFeelings] = []
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: ThoughtsAboutChangingFeelingsInteractorInterface,
//        router: ThoughtsAboutChangingFeelingsRouterInterface,
//        view: ThoughtsAboutChangingFeelingsViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - ThoughtsAboutChangingFeelingsPresenterInterface
//
//extension ThoughtsAboutChangingFeelingsPresenter: ThoughtsAboutChangingFeelingsPresenterInterface {
//    func viewDidLoad() {
//        thoughtsAboutChangingFeelings = interactor?.getAllThoughtsAboutChangingFeelings() ?? []
//        
//        view.set(thoughtsAboutChangingFeelings: thoughtsAboutChangingFeelings)
//        
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//    
//    func didTapContinueCommonButton() {
//        interactor?.set(thoughtsAboutChangingFeelings: .havingMoreEnergy)
//        router?.openLifeChangesAfterWeightLoss()
//    }
//}
