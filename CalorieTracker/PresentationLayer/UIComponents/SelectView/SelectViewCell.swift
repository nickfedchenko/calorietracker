//
//  SelectViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

final class SelectViewCell<ID: WithGetTitleProtocol>: UIControl {
    var isSelectedCell = false {
        didSet {
            didChangeState()
        }
    }
    
    let id: ID
    
    private var shadowLayer = CALayer()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedMedium(size: 22)
        return label
    }()
    
    init(_ id: ID) {
        self.id = id
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupView() {
        titleLabel.text = id.getTitle(.long)
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.borderWidth = 1
    }
    
    private func setupConstraints() {
        layer.addSublayer(shadowLayer)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func didChangeState() {
        switch isSelectedCell {
        case true:
            shadowLayer.isHidden = true
            layer.borderColor = R.color.foodViewing.basicPrimary()?.cgColor
            backgroundColor = UIColor.white
            titleLabel.textColor = R.color.foodViewing.basicDark()
        case false:
            shadowLayer.isHidden = false
            layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
            backgroundColor = UIColor.white
            titleLabel.textColor = R.color.foodViewing.basicGrey()
        }
    }
    
    private func setupShadow() {
        shadowLayer.frame = bounds
        shadowLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        shadowLayer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
        shadowLayer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
    }
}

private struct ShadowConst {
    static let firstShadow = Shadow(
        color: R.color.addFood.menu.firstShadow() ?? .black,
        opacity: 0.2,
        offset: CGSize(width: 0, height: 4),
        radius: 10,
        spread: 0
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2,
        spread: 0
    )
}
