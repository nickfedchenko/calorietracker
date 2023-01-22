//
//  RecipesSearchFooter.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.12.2022.
//

import UIKit
protocol RecipesSearchFooterDelegate: AnyObject {
    func searchPhraseChanged(to phrase: String)
}

final class RecipesSearchFooter: UIView {
    enum RecipesFooterState {
        case compact, expanded
    }
    
    let gradientLayer = CAGradientLayer()
    var backButtonTappedHandler: (() -> Void)?
    var filtersButtonTapHandler: (() -> Void)?
    weak var delegate: RecipesSearchFooterDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.contentMode = .center
        button.tintColor = UIColor(hex: "7A948F")
        return button
    }()
    
    private let mainFilterButton: FiltersButton = {
        let button = FiltersButton(type: .system)
        button.setImage(R.image.filtersIcon(), for: .normal)
        return button
    }()
    
    let textField = SearchRecipesSearchField()
    var state: RecipesFooterState = .compact {
        didSet {
            setNeedsDisplay()
            updateMainButtonState()
        }
    }
    
    var colorsForGradient: [CGColor] {
        state == .compact
        ? [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.1).cgColor]
        : [UIColor(hex: "CACDD4").cgColor, UIColor(hex: "E5EAF1").cgColor]
    }
    
    var startPoint: CGPoint {
        state == .compact ? CGPoint(x: 0.5, y: 0.1) : CGPoint(x: 0.5, y: 0.3)
    }
    
    var endPoint: CGPoint {
        state == .compact ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0.5, y: 0)
    }
    
    var locations: [NSNumber] {	
        state == .compact ? [0, 0.9] : [0, 0.9]
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
    
    func showFiltersBadge() {
        mainFilterButton.showBadge()
    }
    
    func hideFiltersBadge() {
        mainFilterButton.hideBadge()
    }
    
    private func setupActions() {
        let popAction = UIAction { [weak self] _ in
            self?.backButtonTappedHandler?()
        }
        backButton.addAction(popAction, for: .touchUpInside)
        textField.filtersButtonTapAction =  { [weak self] in
            self?.filtersButtonTapHandler?()
        }
        
        let mainFilterButtonAction = UIAction { [weak self] _ in
            if self?.state == .expanded {
                self?.textField.resignFirstResponder()
                self?.state = .compact
                self?.updateMainButtonState()
//                self?.mainFilterButton.tintColor = UIColor(hex: "0C695E")
            } else {
//                self?.mainFilterButton.setImage(R.image.burnedKcalTextField.chevron(), for: .normal)
//                self?.mainFilterButton.tintColor = .black
                self?.filtersButtonTapHandler?()
                self?.updateMainButtonState()
            }
        }
        
        mainFilterButton.addAction(mainFilterButtonAction, for: .touchUpInside)
        textField.addTarget(self, action: #selector(searchPhraseChanged(sender:)), for: .editingChanged)
    }
    
    private func updateMainButtonState() {
        if state == .compact {
            mainFilterButton.setImage(R.image.filtersIcon(), for: .normal)
        } else {
            mainFilterButton.setImage(R.image.burnedKcalTextField.chevron(), for: .normal)
            mainFilterButton.tintColor = .black
        }
    }
    
    private func drawGradient() {
        layer.cornerRadius = state == .compact ? 0 : 16
        gradientLayer.frame = bounds
        gradientLayer.colors = colorsForGradient
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.setNeedsDisplay()
    }
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(backButton)
        addSubview(mainFilterButton)
        
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
        
        mainFilterButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerY.equalTo(textField)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func searchPhraseChanged(sender: UITextField) {
        guard let phrase = sender.text else { return }
        delegate?.searchPhraseChanged(to: phrase)
    }
}

extension RecipesSearchFooter: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        state = .compact
        return true
    }
}
