//
//  ConnectAHView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.08.2022.
//

import UIKit

final class ConnectAHView: UIView {
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.image = R.image.connectAH.connectAH()
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = R.font.sfProDisplaySemibold(size: 16)
        view.textColor = .black
        view.text = "Connect to Apple Health"
        return view
    }()
    
    private lazy var switchView: UISwitch = {
        let view = UISwitch()
        
        return view
    }()
    
    private var isFirstDraw = true
    private var shadows: [Shadow] = [
        .init(
            color: R.color.connectAH.firstShadow()!,
            opacity: 0.25,
            offset: .init(width: 0, height: 0.5),
            radius: 2
        ),
        .init(
            color: R.color.connectAH.secondShadow()!,
            opacity: 0.2,
            offset: .init(width: 0, height: 4),
            radius: 10
        )
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        switchView.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        backgroundColor = .clear
        addSubviews([imageView, label, switchView])
        
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(51)
            make.height.equalTo(31)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.equalTo(switchView.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func drawShadows() {
        shadows.forEach { addShadowLayer(shadow: $0) }
    }
    private func extractedFunc(_ shadowLayer: CALayer, _ path: UIBezierPath, _ shadow: Shadow) {
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
    }
    
    private func addShadowLayer(shadow: Shadow) {
        let path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 16)
   
        let shadowLayer = CALayer()
        extractedFunc(shadowLayer, path, shadow)
        shadowLayer.frame = imageView.bounds
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
    
    @objc private func didTapSwitch(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            // connect apple health
            break
        case false:
            // disconnect apple health
            break
        }
    }
}
