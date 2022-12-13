//
//  KeyboardManagerProtocol.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import UIKit

protocol KeyboardManagerProtocol: AnyObject {
    var eventClosure: KeyboardManagerEventClosure? { get set }

    func bindToKeyboardNotifications(scrollView: UIScrollView)
    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat,
        animated: Bool
    )
}
