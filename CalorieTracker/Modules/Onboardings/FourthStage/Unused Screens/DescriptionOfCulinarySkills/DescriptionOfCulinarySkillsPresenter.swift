//
//  DescriptionOfCulinarySkillsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol DescriptionOfCulinarySkillsPresenterInterface: AnyObject {
//    func viewDidLoad()
//    func didTapContinueCommonButton()
//}
//
//class DescriptionOfCulinarySkillsPresenter {
//    
//    // MARK: - Public properties
//
//    unowned var view: DescriptionOfCulinarySkillsViewControllerInterface
//    let router: DescriptionOfCulinarySkillsRouterInterface?
//    let interactor: DescriptionOfCulinarySkillsInteractorInterface?
//    
//    // MARK: - Private properties
//
//    private var descriptionOfCulinarySkills: [DescriptionOfCulinarySkills] = []
//
//    // MARK: - Initialization
//    
//    init(
//        interactor: DescriptionOfCulinarySkillsInteractorInterface,
//        router: DescriptionOfCulinarySkillsRouterInterface,
//        view: DescriptionOfCulinarySkillsViewControllerInterface
//      ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//// MARK: - DescriptionOfCulinarySkillsPresenterInterface
//
//extension DescriptionOfCulinarySkillsPresenter: DescriptionOfCulinarySkillsPresenterInterface {
//    func viewDidLoad() {
//        descriptionOfCulinarySkills = interactor?.getAllDescriptionOfCulinarySkills() ?? []
//        
//        view.set(descriptionOfCulinarySkills: descriptionOfCulinarySkills)
//        
//        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
//            view.set(currentOnboardingStage: currentOnboardingStage)
//        }
//    }
//    
//    func didTapContinueCommonButton() {
//        interactor?.set(descriptionOfCulinarySkills: .imLearning)
//        router?.openWhatImportantToYou()
//    }
//}
