//
//  WhatIsYourGoalWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol WhatIsYourGoalWeightInteractorInterface: AnyObject {}

class WhatIsYourGoalWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: WhatIsYourGoalWeightPresenterInterface?
}

extension WhatIsYourGoalWeightInteractor: WhatIsYourGoalWeightInteractorInterface {}
