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
    func openOnboarding()
    func openCreateNotesVC()
    func openAllNotesVC()
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
        viewController?.present(
            TopDownNavigationController(rootViewController: vc),
            animated: true
        )
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
    
    func openOnboarding() {
        let vc = WelcomeRouter.setupModule()
        viewController?.present(
            UINavigationController(rootViewController: vc),
            animated: false
        )
    }
    
    func openCreateNotesVC() {
        let vc = NotesCreateViewController()
        vc.handlerAllNotes = { [weak self] in
            self?.openAllNotesVC()
        }
        viewController?.present(vc, animated: true)
    }
    
    func openAllNotesVC() {
        let vc = NotesRouter.setupModule()
        
        viewController?.present(
            TopDownNavigationController(rootViewController: vc),
            animated: true
        )
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
        guard let date = date else { return }
        self.presenter?.setPointDate(date)
        self.presenter?.updateCalendarWidget(date)
    }
}
