//
//  CTWidgetProtocol.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import UIKit

protocol CTWidgetProtocol {
    var widgetType: WidgetContainerViewController.WidgetType { get }
}

protocol CTWidgetFullProtocol: UIView {
    var didTapCloseButton: (() -> Void)? { get set }
    var didChangeSelectedDate: ((Date) -> Void)? { get set }
    func update()
}
