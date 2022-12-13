//
//  WidgetContainerRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import UIKit

protocol WidgetContainerRouterInterface: AnyObject {
    func closeViewController()
    func openChangeWeightViewController(_ type: WeightKeyboardHeaderView.ActionType)
    func openChangeStepsViewController()
}

class WidgetContainerRouter: NSObject {
    weak var viewController: UIViewController?
    weak var presenter: WidgetContainerPresenterInterface?

    static func setupModule(_ type: WidgetContainerViewController.WidgetType) -> WidgetContainerViewController {
        let vc = WidgetContainerViewController(type)
        let router = WidgetContainerRouter()
        let presenter = WidgetContainerPresenter(router: router, view: vc)

        vc.presenter = presenter
        router.viewController = vc
        router.presenter = presenter
        return vc
    }
}

extension WidgetContainerRouter: WidgetContainerRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func openChangeWeightViewController(_ type: WeightKeyboardHeaderView.ActionType) {
        let vc = KeyboardEnterValueViewController(.weight(type))
        vc.modalPresentationStyle = .overFullScreen
        vc.needUpdate = {
            self.presenter?.updateView()
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openChangeStepsViewController() {
        let vc = KeyboardEnterValueViewController(.steps)
        vc.modalPresentationStyle = .overFullScreen
        vc.needUpdate = {
            self.presenter?.updateView()
        }
        
        viewController?.present(vc, animated: true)
    }
}
