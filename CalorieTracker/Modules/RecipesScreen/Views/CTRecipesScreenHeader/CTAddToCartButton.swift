//
//  addToCartButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import UIKit

final class CTAddToCartButton: UIView {
    var addToCartTapped: (() -> Void)?
    private var isFirstLayout = true
    private let contentView = UIView()
    
    private let addToCartButton: UIButton = {
        let button = UIButton.systemButton(with: R.image.addToCartIcon() ?? UIImage(), target: nil, action: nil)
        button.backgroundColor = .clear
        button.tintColor = UIColor(hex: "0C695E")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAppearance()
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.addSubview(addToCartButton)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAppearance() {
        guard isFirstLayout else { return }
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        print("Button inset is \(addToCartButton.imageEdgeInsets)")
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
//        layer.borderWidth = 1
//        layer.borderColor = R.color.basicSecondaryDarkGreen()?.cgColor
//        frame = frame.insetBy(dx: 1, dy: 1)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = 0.15
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.insertSublayer(shadowLayer, at: 0)
        isFirstLayout = false
    }
}
