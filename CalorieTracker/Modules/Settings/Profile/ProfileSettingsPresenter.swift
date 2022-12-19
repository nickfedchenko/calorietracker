//
//  ProfileSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import Foundation

protocol ProfileSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func didTapHeightCell(_ complition: @escaping (Double) -> Void)
    func didTapDateCell(_ complition: @escaping (Date) -> Void)
    func didTapDietaryCell()
    func getUserData() -> UserData?
}

class ProfileSettingsPresenter {
    
    unowned var view: ProfileSettingsViewControllerInterface
    let router: ProfileSettingsRouterInterface?
    
    init(
        router: ProfileSettingsRouterInterface,
        view: ProfileSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension ProfileSettingsPresenter: ProfileSettingsPresenterInterface {
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func didTapHeightCell(_ complition: @escaping (Double) -> Void) {
        router?.openHeightEnterValueViewController { value in
            complition(value)
        }
    }
    
    func didTapDateCell(_ complition: @escaping (Date) -> Void) {
        router?.openDatePickerViewController { date in
            complition(date)
        }
    }
    
    func didTapDietaryCell() {
        router?.openDietaryViewController()
    }
    
    func getUserData() -> UserData? {
        UDM.userData
    }
}
