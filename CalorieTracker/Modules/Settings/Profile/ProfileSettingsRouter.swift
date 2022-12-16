//
//  ProfileSettingsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

protocol ProfileSettingsRouterInterface: AnyObject {
    func closeViewController()
}

class ProfileSettingsRouter: NSObject {
    
    weak var presenter: ProfileSettingsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ProfileSettingsViewController {
        let vc = ProfileSettingsViewController()
        let router = ProfileSettingsRouter()
        let presenter = ProfileSettingsPresenter(router: router, view: vc)
        
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
}
