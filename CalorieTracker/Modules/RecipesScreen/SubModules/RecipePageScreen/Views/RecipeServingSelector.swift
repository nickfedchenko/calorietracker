//
//  RecipeServingSelector.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 14.01.2023.
//

import UIKit

protocol RecipeServingSelectorDelegate: AnyObject {
    func servingChangedTo(count: Int)
}

final class RecipeServingSelector: UIView {
    weak var delegate: RecipeServingSelectorDelegate?
    private var currentCount = 1 {
        didSet {
            updateLabel()
        }
    }
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.minusButton(), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.backgroundColor = UIColor(hex: "B3EFDE")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "62D3B4").cgColor
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.plusButton(), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.backgroundColor = UIColor(hex: "B3EFDE")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "62D3B4").cgColor
        return button
    }()
    
    private let servingsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextSemibold(size: 17)
        label.textColor = UIColor(hex: "1A645A")
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "1 " + "servings1".localized
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupSubviews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCountInitially(to count: Int) {
        currentCount = count
    }
    
    private func updateLabel() {
       
        var servingsString = ""
        switch currentCount {
        case 1:
            servingsString = "servings-1".localized
        case 2...4:
            servingsString = "servings-2-4".localized
        case 5...:
            servingsString = "servings>4".localized
        default:
            servingsString = "servings-1".localized
        }
        servingsLabel.text = "\(currentCount) " + servingsString
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "62D3B4").cgColor
    }
    
    private func setupSubviews() {
        addSubviews([servingsLabel, minusButton, plusButton])
        servingsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.leading.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.trailing.equalToSuperview()
        }
    }
    
    private func setupActions() {
        minusButton.addTarget(self, action: #selector(servingCountChange(sender:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(servingCountChange(sender:)), for: .touchUpInside)
    }
    
    private func animateBlinking(button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.alpha = 1
            }
        }
    }
    
    @objc
    private func servingCountChange(sender: UIButton) {
        switch sender {
        case minusButton:
            if currentCount > 1 {
                currentCount -= 1
                delegate?.servingChangedTo(count: currentCount)
            }
        case plusButton:
            currentCount += 1
            delegate?.servingChangedTo(count: currentCount)
        default:
            return
        }
        animateBlinking(button: sender)
        LoggingService.postEvent(event: .recipesetserving)
    }
}
