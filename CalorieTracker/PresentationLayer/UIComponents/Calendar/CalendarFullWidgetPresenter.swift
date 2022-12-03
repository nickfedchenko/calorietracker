//
//  CalendarFullWidgetPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.12.2022.
//

import UIKit

protocol CalendarFullWidgetPresenterInterface: AnyObject {

}

class CalendarFullWidgetPresenter {
    unowned var view: CalendarFullWidgetViewInterface
    
    init(view: CalendarFullWidgetViewInterface) {
        self.view = view
    }
}

extension CalendarFullWidgetPresenter: CalendarFullWidgetPresenterInterface {

}

