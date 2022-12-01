//
//  WidgetContainerRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import UIKit

protocol WidgetContainerRouterInterface: AnyObject {
    func closeViewController()
}

class WidgetContainerRouter: NSObject {
    weak var viewController: UIViewController?

    static func setupModule(_ type: WidgetContainerViewController.WidgetType) -> WidgetContainerViewController {
        let vc = WidgetContainerViewController(type)
        let router = WidgetContainerRouter()

        vc.router = router
        router.viewController = vc
        return vc
    }
}

extension WidgetContainerRouter: WidgetContainerRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
}
