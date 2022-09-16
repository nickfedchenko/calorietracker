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
        UDM.dietary = [
        TripleWidgetData(date: Date() - 84000 * 0, valueFirst: 90, valueSecond: 58, valueThird: 110),
        TripleWidgetData(date: Date() - 84000 * 1, valueFirst: 50, valueSecond: 90, valueThird: 100),
        TripleWidgetData(date: Date() - 84000 * 2, valueFirst: 65, valueSecond: 34, valueThird: 120),
        TripleWidgetData(date: Date() - 84000 * 3, valueFirst: 97, valueSecond: 76, valueThird: 95),
        TripleWidgetData(date: Date() - 84000 * 4, valueFirst: 60, valueSecond: 34, valueThird: 84),
        TripleWidgetData(date: Date() - 84000 * 5, valueFirst: 70, valueSecond: 45, valueThird: 70),
        TripleWidgetData(date: Date() - 84000 * 6, valueFirst: 67, valueSecond: 58, valueThird: 90),
        TripleWidgetData(date: Date() - 84000 * 7, valueFirst: 90, valueSecond: 70, valueThird: 86)
        ]
    }
}

extension ProgressPresenter: ProgressPresenterInterface {
    func getWidgetTypes() -> [WidgetType] {
        let data = UDM.widgetSettings
        return data.isEmpty ? [.weight, .calories, .steps] : data
    }
}
