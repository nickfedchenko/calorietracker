//
//  IngredientView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 13.01.2023.
//

import UIKit

final class InstructionView: UIView {
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
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAppearance()
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
    
    func setStepNumber(num: Int) {
        stepNumber.text = String(num)
    }
    
    func setInstruction(instruction: String) {
        instructionLabel.text = instruction
    }
    
    func setupAppearance() {
        backgroundColor = UIColor(hex: "FFFCDE")
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "B3EFDE").cgColor
    }
    
    func setupSubviews() {
        addSubviews([stepNumber, instructionLabel])
        
        stepNumber.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.left.equalToSuperview().offset(12)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stepNumber.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
