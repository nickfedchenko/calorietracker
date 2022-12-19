//
//  ProfileSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

protocol ProfileSettingsRouterInterface: AnyObject {
    func closeViewController()
    func openHeightEnterValueViewController(_ complition: @escaping (Double) -> Void)
    func openDatePickerViewController(_ complition: @escaping (Date) -> Void)
    func openDietaryViewController()
}

class ProfileSettingsRouter: NSObject {
    
    weak var presenter: ProfileSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ProfileSettingsViewController {
        let vc = ProfileSettingsViewController()
        let router = ProfileSettingsRouter()
        let presenter = ProfileSettingsPresenter(router: router, view: vc)
        let viewModel = SettingsProfileViewModel(
            types: [
                .title,
                .name,
                .lastName,
                .city,
                .sex,
                .date,
                .height,
                .dietary
            ],
            presenter: presenter
        )
        
        vc.viewModel = viewModel
        vc.keyboardManager = KeyboardManager()
        vc.presenter = presenter
        router.viewController = vc
        router.presenter = presenter
        return vc
    }
}

extension ProfileSettingsRouter: ProfileSettingsRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openHeightEnterValueViewController(_ complition: @escaping (Double) -> Void) {
        let vc = KeyboardEnterValueViewController(.height)
        vc.complition = { value in
            complition(value)
        }
        viewController?.present(vc, animated: true)
    }
    
    func openDatePickerViewController(_ complition: @escaping (Date) -> Void) {
        let vc = DatePickerViewController()
        vc.date = { date in
            complition(date)
        }
        viewController?.present(vc, animated: true)
    }
    
    func openDietaryViewController() {
        let vc = DietarySettingsRouter.setupModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
