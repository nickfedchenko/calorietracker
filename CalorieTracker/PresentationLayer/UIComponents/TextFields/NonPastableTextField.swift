//
//  NonPastableTextField.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 01.03.2023.
//

import UIKit

final class NonPastableTextField: InnerShadowTextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                    return false
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}
