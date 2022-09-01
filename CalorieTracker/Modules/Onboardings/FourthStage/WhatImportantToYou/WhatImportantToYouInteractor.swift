//
//  WhatImportantToYouInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol WhatImportantToYouInteractorInterface: AnyObject {
    func set(whatImportantToYou: Bool)
}

class WhatImportantToYouInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: WhatImportantToYouPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - WhatImportantToYouInteractorInterface

extension WhatImportantToYouInteractor: WhatImportantToYouInteractorInterface {
    func set(whatImportantToYou: Bool) {
        onboardingManager.set(whatImportantToYou: whatImportantToYou)
    }
}
