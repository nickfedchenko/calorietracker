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
    private var firstDraw = true
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 22)
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
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
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
        shadowLayer.addShadow(
            shadow: MenuView.ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
        shadowLayer.addShadow(
            shadow: MenuView.ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
    }
}