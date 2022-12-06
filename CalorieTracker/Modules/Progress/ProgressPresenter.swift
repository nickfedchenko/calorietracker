//
//  ProgressPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 07.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProgressPresenterInterface: AnyObject {
    func getWidgetTypes() -> [WidgetType]
}

class ProgressPresenter {
    
    unowned var view: ProgressViewControllerInterface
    let router: ProgressRouterInterface?
    let interactor: ProgressInteractorInterface?
    
    init(
        interactor: ProgressInteractorInterface,
        router: ProgressRouterInterface,
        view: ProgressViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProgressPresenter: ProgressPresenterInterface {
    func getWidgetTypes() -> [WidgetType] {
        let data = UDM.widgetSettings
        return data.isEmpty ? [.weight, .calories, .steps] : data
    }
}
