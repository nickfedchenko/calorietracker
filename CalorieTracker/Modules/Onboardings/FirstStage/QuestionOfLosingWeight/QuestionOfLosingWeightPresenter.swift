//
//  QuestionOfLosingWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol QuestionOfLosingWeightPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class  QuestionOfLosingWeightPresenter {
    
    unowned var view: QuestionOfLosingWeightViewControllerInterface
    let router: QuestionOfLosingWeightRouterInterface?
    let interactor: QuestionOfLosingWeightInteractorInterface?

    init(
        interactor: QuestionOfLosingWeightInteractorInterface,
        router: QuestionOfLosingWeightRouterInterface,
        view: QuestionOfLosingWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension  QuestionOfLosingWeightPresenter: QuestionOfLosingWeightPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(isHaveYouTriedToLoseWeightBefor: true)
        router?.openDescriptionOfExperience()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(isHaveYouTriedToLoseWeightBefor: false)
        router?.openDescriptionOfExperience()
    }
}
