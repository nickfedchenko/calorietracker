//
//  ActionCAShapeLayer.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.08.2022.
//

import UIKit

final class ActionCAShapeLayer: CAShapeLayer {
    var allowActions: Bool = false

    override func action(forKey event: String) -> CAAction? {
        return allowActions ? super.action(forKey: event) : nil
    }
}
