//
//  TouchPassingView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 13.02.2023.
//

import UIKit

final class TouchPassingView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
