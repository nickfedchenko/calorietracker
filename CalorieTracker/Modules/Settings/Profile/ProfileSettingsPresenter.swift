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
    func saveUserData()
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
    
    func saveUserData() {
//        let oldUserData = UDM.userData
//        let dateFormatter = DateFormatter()
//        
//        let newDate = dateFormatter.date(from: view.getDate() ?? "")
//        let newHeight = Double(view.getHeight()?.split(separator: " ").first ?? "")
//        let newSexStr = view.getSex() ?? ""
//        let newSex = UserSex.allCases.first(where: { $0.rawValue == newSexStr })
//        
//        let newUserData: UserData = .init(
//            name: view.getName() ?? oldUserData?.name ?? "",
//            lastName: view.getLastName(),
//            city: view.getCity(),
//            sex: newSex ?? oldUserData?.sex,
//            dateOfBirth: newDate ?? oldUserData?.dateOfBirth ?? Date(),
//            height: newHeight ?? oldUserData?.height ?? 0,
//            dietary: oldUserData?.dietary ?? .classic
//        )
//        
//        UDM.userData = newUserData
    }
}

extension UserSex: CaseIterable {
    static var allCases: [UserSex] = [.male, .famale]
}
