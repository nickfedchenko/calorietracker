//
//  ViewWithShadow.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.11.2022.
//

import UIKit

class ViewWithShadow: UIView {
    
    let shadows: [Shadow]
    
    private var firstDraw = true
    
    init(_ shadows: [Shadow]) {
        self.shadows = shadows
        super.init(frame: .zero)
        layer.zPosition = -1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw, bounds != .zero else { return }
        shadows.forEach { shadow in
            layer.addShadow(
                shadow: shadow,
                rect: bounds,
                cornerRadius: layer.cornerRadius,
                corner: layer.maskedCorners.rectCorners
            )
        }
        firstDraw = false
    }
}
