//
//  WidgetContainerView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.09.2022.
//

import UIKit

final class WidgetContainerView: UIView {
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
    }
    
    private lazy var forgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.progressScreen.blackout()
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var isFirstDraw = true
    private let shadows: [Shadow] = [
        .init(
            color: R.color.progressScreen.firstShadow()!,
            opacity: 0.25,
            offset: .init(width: 0, height: 0.5),
            radius: 2
        ),
        .init(
            color: R.color.progressScreen.secondShadow()!,
            opacity: 0.23,
            offset: .init(width: 0, height: 5),
            radius: 14
        )
    ]
    
    var blackout = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.forgroundView.layer.opacity = self.blackout
                ? 0.05 + Float(self.index ?? 0) * 0.05
                : 0
            }
        }
    }
    
    let view: WidgetChart
    var index: Int?
    
    init(_ view: WidgetChart) {
        self.view = view
        super.init(frame: .zero)
        addView(view)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        drawShadows()
        isFirstDraw = false
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        forgroundView.layer.opacity = 0
        
        addSubview(forgroundView)
        forgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addView(_ view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func drawShadows() {
        shadows.forEach { addShadowLayer(shadow: $0) }
    }
    
    fileprivate func extractedFunc(_ shadowLayer: CALayer, _ path: UIBezierPath, _ shadow: Shadow) {
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
    }
    
    private func addShadowLayer(shadow: Shadow) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        let shadowLayer = CALayer()
        extractedFunc(shadowLayer, path, shadow)
        shadowLayer.frame = bounds
        path.append(UIBezierPath(rect: CGRect(
            origin: CGPoint(
                x: bounds.origin.x - (shadow.radius + 10) / 2.0,
                y: bounds.origin.y - (shadow.radius + 10) / 2.0
            ),
            size: CGSize(
                width: bounds.width + shadow.radius + 20,
                height: bounds.height + shadow.radius + 20
            )
        )))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        shadowLayer.mask = mask
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
