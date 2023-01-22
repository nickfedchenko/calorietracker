//
//  RecipesSearchFooter.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.12.2022.
//

import UIKit

final class RecipesSearchFooter: UIView {
    enum RecipesFooterState {
        case compact, expanded
    }
    
    let gradientLayer = CAGradientLayer()
    var backButtonTappedHandler: (() -> Void)?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.contentMode = .center
        button.tintColor = UIColor(hex: "7A948F")
        return button
    }()
    
    let textField = SearchRecipesSearchField()
    var state: RecipesFooterState = .compact {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var colorsForGradient: [CGColor] {
        state == .compact
        ? [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        : [UIColor(hex: "CACDD4").cgColor, UIColor(hex: "E5EAF1").cgColor]
    }
    
    var startPoint: CGPoint {
        state == .compact ? CGPoint(x: 0.5, y: 0.2) : CGPoint(x: 0.5, y: 0.3)
    }
    
    var endPoint: CGPoint {
        state == .compact ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0.5, y: 0)
    }
    
    var locations: [NSNumber] {	
        state == .compact ? [0, 0.5] : [0, 0.7]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        setupSubviews()
        clipsToBounds = true
        textField.delegate = self
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient()
    }
    
    private func setupActions() {
        let popAction = UIAction { [weak self] _ in
            self?.backButtonTappedHandler?()
        }
        backButton.addAction(popAction, for: .touchUpInside)
    }
    
    private func drawGradient() {
        layer.cornerRadius = state == .compact ? 0 : 16
        gradientLayer.frame = bounds
        gradientLayer.colors = colorsForGradient
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.setNeedsDisplay()
        print("Current bounds now \(gradientLayer.frame)")
    }
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(backButton)
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(96)
            make.top.equalToSuperview().offset(51)
        }
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}


extension RecipesSearchFooter: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        state = .compact
        return true
    }
}
