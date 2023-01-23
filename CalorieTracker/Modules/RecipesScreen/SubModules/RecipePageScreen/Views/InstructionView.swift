//
//  IngredientView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 13.01.2023.
//

import UIKit

final class InstructionView: UIView {
    
    private var shouldHideButton: Bool = false
    private let stepNumber: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: "7A948F")
        label.textAlignment = .center
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 14)
        label.textColor = UIColor(hex: "514631")
        label.numberOfLines = 3
        
        label.lineBreakStrategy = .pushOut
        label.textAlignment = .left
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.chevronDown(), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAppearance()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roundCorners(topLeft: 12, topRight: 24, bottomLeft: 2, bottomRight: 24)
        drawCustomStrokeWithCorners(
            topLeft: 12,
            topRight: 24,
            bottomLeft: 2,
            bottomRight: 24,
            of: UIColor(hex: "B3EFDE").cgColor,
            with: 2
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }
    
    func setStepNumber(num: Int) {
        stepNumber.text = String(num)
    }
    
    func setInstruction(instruction: String) {
        instructionLabel.text = instruction
    }
    
    private func updateAppearance() {
        if instructionLabel.calculateMaxLines() > 3 {
            if !shouldHideButton {
                expandButton.alpha = 1
            }
        } else {
            expandButton.alpha = 0
        }
    }
    
    private func setupActions() {
        expandButton.addTarget(self, action: #selector(expandInstruction(sender:)), for: .touchUpInside)
    }
    
    @objc private func expandInstruction(sender: UIButton) {
        instructionLabel.numberOfLines = 0
        UIView.animate(withDuration: 0.3, delay: 0) {
            sender.alpha = 0
            self.shouldHideButton = true
            self.setNeedsDisplay()
        }
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor(hex: "FFFCDE")
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "B3EFDE").cgColor
    }
    
    private func setupSubviews() {
        addSubviews([stepNumber, instructionLabel, expandButton])
        
        stepNumber.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.left.equalToSuperview().offset(12)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stepNumber.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(32)
        }
        
        expandButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.top.equalTo(stepNumber.snp.bottom)
            make.centerX.equalTo(stepNumber)
        }
    }
}
