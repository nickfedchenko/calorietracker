//
//  MainScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol MainScreenRouterInterface: AnyObject {
    func openAddFoodVC()
    func openWidget(_ type: WidgetContainerViewController.WidgetType)
    func openSettingsVC()
}

class MainScreenRouter: NSObject {

    weak var presenter: MainScreenPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> MainScreenViewController {
        let vc = MainScreenViewController()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension MainScreenRouter: MainScreenRouterInterface {
    func openSettingsVC() {
        let vc = SettingsRouter.setupModule()
        viewController?.present(vc, animated: true)
    }
    
    func openAddFoodVC() {
        let vc = AddFoodRouter.setupModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openWidget(_ type: WidgetContainerViewController.WidgetType) {
        let vc = WidgetContainerRouter.setupModule(type)
        vc.output = self
        
        viewController?.present(vc, animated: true)
    }
}

extension MainScreenRouter: WidgetContainerOutput {
    func needUpdateWidget(_ type: WidgetContainerViewController.WidgetType) {
        switch type {
        case .water:
            self.presenter?.updateWaterWidgetModel()
        case .steps:
            self.presenter?.updateStepsWidget()
        case .calendar:
            self.presenter?.updateCalendarWidget(nil)
        case .weight:
            self.presenter?.updateWeightWidget()
        case .exercises:
            self.presenter?.updateExersiceWidget()
        default:
            return
        }
    }
    
    func needUpdateCalendarWidget(_ date: Date?) {
        self.presenter?.updateCalendarWidget(date)
    }
}
