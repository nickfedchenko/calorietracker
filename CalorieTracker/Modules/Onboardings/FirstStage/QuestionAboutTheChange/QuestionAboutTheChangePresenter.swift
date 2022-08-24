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
    
    unowned var view: QuestionAboutTheChangeViewControllerInterface
    let router: QuestionAboutTheChangeRouterInterface?
    let interactor: QuestionAboutTheChangeInteractorInterface?

    private var questionAboutTheChange: [QuestionAboutTheChange] = []
    private var questionAboutTheChangeIndex: Int?
    
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

extension QuestionAboutTheChangePresenter: QuestionAboutTheChangePresenterInterface {
    func viewDidLoad() {
        questionAboutTheChange = interactor?.getAllQuestionAboutTheChange() ?? []
        
        view.set(questionAboutTheChange: questionAboutTheChange)
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
