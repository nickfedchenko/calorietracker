//
//  WhatIsYourGoalWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol WhatIsYourGoalWeightPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class WhatIsYourGoalWeightPresenter {
    
    // MARK: - Public properties

    unowned var view: WhatIsYourGoalWeightViewControllerInterface
    let router: WhatIsYourGoalWeightRouterInterface?
    let interactor: WhatIsYourGoalWeightInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: WhatIsYourGoalWeightInteractorInterface,
        router: WhatIsYourGoalWeightRouterInterface,
        view: WhatIsYourGoalWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension WhatIsYourGoalWeightPresenter: WhatIsYourGoalWeightPresenterInterface {
    func didTapContinueCommonButton() {}
}
