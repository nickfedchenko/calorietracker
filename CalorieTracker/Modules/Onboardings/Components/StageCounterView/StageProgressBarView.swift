//
//  StageProgressBarView.swift
//  CalorieTracker
//
//  Created by Алексей on 01.09.2022.
//

import UIKit

final class StageProgressBarView: UIView {
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = R.color.onboardings.basicGray()
        layer.addSublayer(progressLayer)
    }

    override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: 0.0).cgPath
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = R.color.onboardings.radialGradientFirst()?.cgColor
    }
}
