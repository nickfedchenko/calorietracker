//
//  DietarySettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import Foundation

protocol DietarySettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func getUserData() -> UserData?
    func saveDietary(_ dietary: UserDietary)
}

class DietarySettingsPresenter {
    
    unowned var view: DietarySettingsViewControllerInterface
    let router: DietarySettingsRouterInterface?
    
    init(
        router: DietarySettingsRouterInterface,
        view: DietarySettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension DietarySettingsPresenter: DietarySettingsPresenterInterface {
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func getUserData() -> UserData? {
        UDM.userData
    }
    
    func saveDietary(_ dietary: UserDietary) {
        let oldUserData = UDM.userData
        UDM.userData = .init(
            name: oldUserData?.name ?? "",
            lastName: oldUserData?.lastName,
            city: oldUserData?.city,
            sex: oldUserData?.sex ?? .male,
            dateOfBirth: oldUserData?.dateOfBirth ?? Date(),
            height: oldUserData?.height ?? 0,
            dietary: dietary,
            email: oldUserData?.email
        )
    }
}
