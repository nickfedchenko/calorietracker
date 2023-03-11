//
//  FinalOfTheSecondStagePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

//import Foundation
//
//protocol FinalOfTheSecondStagePresenterInterface: AnyObject {
//    func didTapContinueToMotivation()
//}
//
//class FinalOfTheSecondStagePresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: FinalOfTheSecondStageViewControllerInterface
//    let router: FinalOfTheSecondStageRouterInterface?
//    let interactor: FinalOfTheSecondStageInteractorInterface?
//
//    // MARK: - Initialization
//
//    init(
//        interactor: FinalOfTheSecondStageInteractorInterface,
//        router: FinalOfTheSecondStageRouterInterface,
//        view: FinalOfTheSecondStageViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - FinalOfTheSecondStagePresenterInterface
//
//extension FinalOfTheSecondStagePresenter: FinalOfTheSecondStagePresenterInterface {
//    func didTapContinueToMotivation() {
//        router?.openImportanceOfWeightLoss()
//    }
//}
