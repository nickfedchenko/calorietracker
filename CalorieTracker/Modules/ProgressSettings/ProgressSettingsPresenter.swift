//
//  ProgressSettingsPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 12.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProgressSettingsPresenterInterface: AnyObject {
    func getWidgetTypes() -> [WidgetType]
    func saveWidgetTypes(_ types: [WidgetType])
}

class ProgressSettingsPresenter {

    unowned var view: ProgressSettingsViewControllerInterface
    let router: ProgressSettingsRouterInterface?
    let interactor: ProgressSettingsInteractorInterface?

    init(
        interactor: ProgressSettingsInteractorInterface,
        router: ProgressSettingsRouterInterface,
        view: ProgressSettingsViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProgressSettingsPresenter: ProgressSettingsPresenterInterface {
    func getWidgetTypes() -> [WidgetType] {
        let data = UDM.widgetSettings
        return data.isEmpty ? [.weight, .calories, .steps] : data
    }
    
    func saveWidgetTypes(_ types: [WidgetType]) {
        UDM.widgetSettings = types
    }
}
