//
//  SliderTrackLayer.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.08.2022.
//

import UIKit

final class SliderTrackLayer: ActionCAShapeLayer {
    weak var slider: SliderStepperView?
    
    override init() {
        super.init()
        zPosition = -1
        masksToBounds = true
        cornerCurve = .circular
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        guard let slider = slider else { return }
        let position = slider.positionCircle ?? .zero
        let rect = CGRect(
            origin: .zero,
            size: CGSize(
                width: position.x + slider.frame.height,
                height: slider.bounds.height
            )
        )
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        ctx.setFillColor(slider.sliderTrackColor?.cgColor ?? UIColor.blue.cgColor)
        ctx.fillPath()
    }
}
