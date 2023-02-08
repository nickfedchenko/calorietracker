//
//  ProfileSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import Foundation

protocol ProfileSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func didTapHeightCell()
    func didTapDateCell()
    func didTapDietaryCell()
    func getNameStr() -> String?
    func getLastNameStr() -> String?
    func getDateStr() -> String?
    func getCityStr() -> String?
    func getUserSexStr() -> String?
    func getHeightStr() -> String?
    func getDietary() -> UserDietary?
    func setUserSex(_ userSex: UserSex)
}

class ProfileSettingsPresenter {
    
    unowned var view: ProfileSettingsViewControllerInterface
    let router: ProfileSettingsRouterInterface?
    
    private var name: String?
    private var lastName: String?
    private var city: String?
    
    private var date: Date? {
        didSet {
            updateValue()
            view.updateCell(.date)
        }
    }
    
    private var userSex: UserSex? {
        didSet {
            updateValue()
            view.updateCell(.sex)
        }
    }
    
    private var height: Double? {
        didSet {
            updateValue()
            view.updateCell(.height)
        }
    }
    
    init(
        router: ProfileSettingsRouterInterface,
        view: ProfileSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
    
    private func updateValue() {
        guard let oldUserData = UDM.userData else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let newDate = date
        let newHeight = height
        let newSex = userSex
        let newCity = city
        let newLastName = lastName
        let newName = name
        
        let newUserData = UserData(
            name: newName ?? oldUserData.name,
            lastName: newLastName ?? oldUserData.lastName,
            city: newCity ?? oldUserData.city,
            sex: newSex ?? oldUserData.sex,
            dateOfBirth: newDate ?? oldUserData.dateOfBirth,
            height: newHeight ?? oldUserData.height,
            dietary: oldUserData.dietary,
            email: UDM.userData?.email
        )

        UDM.userData = newUserData
    }
}

extension ProfileSettingsPresenter: ProfileSettingsPresenterInterface {
    func didTapBackButton() {
        self.name = view.getNameStr()
        self.lastName = view.getLastNameStr()
        self.city = view.getCityStr()
        self.updateValue()
        view.needUpdateParentVC()
        router?.closeViewController()
    }
    
    func didTapHeightCell() {
        router?.openHeightEnterValueViewController { value in
            self.height = BAMeasurement(value, .lenght).value
        }
    }
    
    func didTapDateCell() {
        router?.openDatePickerViewController { date in
            self.date = date
        }
    }
    
    func didTapDietaryCell() {
        router?.openDietaryViewController()
    }
    
    func setUserSex(_ userSex: UserSex) {
        self.userSex = userSex
    }

    func getCityStr() -> String? {
        UDM.userData?.city
    }
    
    func getDateStr() -> String? {
        guard let date = UDM.userData?.dateOfBirth else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getNameStr() -> String? {
        UDM.userData?.name
    }
    
    func getHeightStr() -> String? {
        guard let height = UDM.userData?.height else { return nil }
        return BAMeasurement(height, .lenght, isMetric: true).string
    }
    
    func getUserSexStr() -> String? {
        UDM.userData?.sex.getTitle(.long)
    }
    
    func getLastNameStr() -> String? {
        UDM.userData?.lastName
    }
    
    func getDietary() -> UserDietary? {
        UDM.userData?.dietary
    }
}

extension UserSex: CaseIterable {
    static var allCases: [UserSex] = [.male, .famale]
}
