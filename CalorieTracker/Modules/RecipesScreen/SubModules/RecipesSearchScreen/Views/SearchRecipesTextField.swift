//
//  SearchRecipesTextField.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.12.2022.
//

import UIKit

final class SearchRecipesSearchField: UITextField {
    
    private let shadowLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    var filtersButtonTapAction: (() -> Void)?
    
    override var backgroundColor: UIColor? {
        get {
            UIColor(cgColor: shapeLayer.fillColor ?? UIColor.clear.cgColor)
        }
        
        set {
            shapeLayer.fillColor = newValue?.cgColor
        }
    }
    
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.filtersIcon(), for: .normal)
        return button
    }()
    
    private let magnifyingGlass: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(hex: "ABABAB")
//        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAdditionalViews()
        setupAppearance()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadow()
    }
    
    private func setupActions() {
        let filterAction = UIAction { [weak self] _ in
            self?.filtersButtonTapAction?()
        }
        filterButton.addAction(filterAction, for: .touchUpInside)
    }
    
    private func setupAdditionalViews() {
        leftViewMode = .always
        leftView = magnifyingGlass
        rightViewMode = .whileEditing
        rightView = filterButton
    }
    
    private func setupAppearance() {
        layer.insertSublayer(shapeLayer, at: 0)
        layer.insertSublayer(shadowLayer, at: 0)
        backgroundColor = UIColor(hex: "B3EFDE")
        clipsToBounds = false
        attributedPlaceholder = NSAttributedString(
            string: "SEARCH RECIPE",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 18) ?? .systemFont(ofSize: 18),
                .foregroundColor: UIColor(hex: "ABABAB")
            ]
        )
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if !isFirstResponder {
            return CGRect(x: 55, y: 16, width: 32, height: 32)
        } else {
            return CGRect(x: 12, y: 16, width: 32, height: 32)
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if !isFirstResponder {
            return CGRect(x: 90, y: 12, width: 157, height: 40)
        } else {
            return super.textRect(forBounds: bounds)
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        backgroundColor = .white
        setNeedsDisplay()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        backgroundColor = UIColor(hex: "B3EFDE")
        return super.resignFirstResponder()
    }
    
    private func drawShadow() {
        let shapeLayerShadowOpacity: Float = isFirstResponder ? 0 : 0.2
        let shadowLayerOpacity: Float = isFirstResponder ? 0 : 0.25
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
//        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowColor = UIColor(hex: "06BBBB").cgColor
        shapeLayer.shadowOpacity = shapeLayerShadowOpacity
        shapeLayer.shadowRadius = 10
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = shadowLayerOpacity
        shadowLayer.shadowRadius = 2
    }
}
