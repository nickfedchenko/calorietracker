//
//  QuestionAboutTheChangepresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol QuestionAboutTheChangePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectQuestionAboutTheChange(with index: Int)
    func didDeselectQuestionAboutTheChange()
}

class QuestionAboutTheChangePresenter {
    
    // MARK: - Public properties
    
    unowned var view: QuestionAboutTheChangeViewControllerInterface
    let router: QuestionAboutTheChangeRouterInterface?
    let interactor: QuestionAboutTheChangeInteractorInterface?

    // MARK: - Private properties
    
    private var questionAboutTheChange: [QuestionAboutTheChange] = []
    private var questionAboutTheChangeIndex: Int?
    
    // MARK: - Initialization
    
    init(
        interactor: QuestionAboutTheChangeInteractorInterface,
        router: QuestionAboutTheChangeRouterInterface,
        view: QuestionAboutTheChangeViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - QuestionAboutTheChangePresenterInterface

extension QuestionAboutTheChangePresenter: QuestionAboutTheChangePresenterInterface {
    func viewDidLoad() {
        questionAboutTheChange = interactor?.getAllQuestionAboutTheChange() ?? []
        
        view.set(questionAboutTheChange: questionAboutTheChange)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapNextCommonButton() {
        interactor?.set(questionAboutTheChange: .iHaveDifferentMindset)
        router?.openAchievingDifficultGoal()
    }
    
    func didSelectQuestionAboutTheChange(with index: Int) {
        questionAboutTheChangeIndex = index
    }
    
    func didDeselectQuestionAboutTheChange() {
        questionAboutTheChangeIndex = nil
    }
}
