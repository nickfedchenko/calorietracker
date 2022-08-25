//
//  DescriptionOfExperiencePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol DescriptionOfExperiencePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectDescriptionOfExperience(with index: Int)
    func didDeselectDescriptionOfExperience()
}

class DescriptionOfExperiencePresenter {
    
    // MARK: - Public properties
    
    unowned var view: DescriptionOfExperienceViewControllerInterface
    let router: DescriptionOfExperienceRouterInterface?
    let interactor: DescriptionOfExperienceInteractorInterface?
    
    // MARK: - Private properties
    
    private var descriptionOfExperiences: [DescriptionOfExperience] = []
    private var descriptionOfExperienceIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: DescriptionOfExperienceInteractorInterface,
        router: DescriptionOfExperienceRouterInterface,
        view: DescriptionOfExperienceViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - DescriptionOfExperiencePresenterInterface

extension  DescriptionOfExperiencePresenter: DescriptionOfExperiencePresenterInterface {
    func viewDidLoad() {
        descriptionOfExperiences = interactor?.getAllDescriptionOfExperience() ?? []
        
        view.set(descriptionOfExperiences: descriptionOfExperiences)
    }
    
    func didTapNextCommonButton() {
        guard let descriptionOfExperienceIndex = descriptionOfExperienceIndex else { return }
        
        interactor?.set(descriptionOfExperience: descriptionOfExperiences[descriptionOfExperienceIndex])
        router?.openPurposeOfTheParish()
    }
    
    func didSelectDescriptionOfExperience(with index: Int) {
        descriptionOfExperienceIndex = index
    }
    
    func didDeselectDescriptionOfExperience() {
        descriptionOfExperienceIndex = nil
    }
}
