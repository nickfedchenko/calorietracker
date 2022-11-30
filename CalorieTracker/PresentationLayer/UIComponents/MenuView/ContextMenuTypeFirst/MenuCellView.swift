//
//  MenuCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

final class MenuCellView<ID: WithGetTitleProtocol & WithGetImageProtocol>: UIControl {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var firstDraw = true
    private var shadowLayer = CALayer()
    
    let model: ID
    
    var isSelectedBackgroundColor: UIColor? = .white
    var isNotSelectedBackgroundColor: UIColor? = R.color.addFood.menu.background()
    var isSelectedTextColor: UIColor? = R.color.addFood.menu.isSelectedText()
    var isNotSelectedTextColor: UIColor? = R.color.addFood.menu.isNotSelectedText()
    var isSelectedBorderColor: UIColor? = R.color.addFood.menu.isSelectedBorder()
    var isNotSelectedBorderColor: UIColor? = R.color.addFood.menu.isNotSelectedBorder()
    
    var isSelectedCell = false {
        didSet {
            didChangeState()
        }
    }
    
    init(_ model: ID) {
        self.model = model
        super.init(frame: .zero)
        titleLabel.text = model.getTitle(.long)
        imageView.image = model.getImage()
        
        setupView()
        addSubviews()
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
        layer.insertSublayer(shadowLayer, at: 0)
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.borderWidth = 1
    }
    
    private func addSubviews() {
        addSubviews(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.aspectRatio()
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    private func didChangeState() {
        switch isSelectedCell {
        case true:
            layer.borderColor = isSelectedBorderColor?.cgColor
            backgroundColor = isSelectedBackgroundColor
            titleLabel.textColor = isSelectedTextColor
            shadowLayer.isHidden = true
        case false:
            layer.borderColor = isNotSelectedBorderColor?.cgColor
            backgroundColor = isNotSelectedBackgroundColor
            titleLabel.textColor = isNotSelectedTextColor
            shadowLayer.isHidden = false
        }
    }
    
    private func setupShadow() {
        shadowLayer.frame = bounds
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
        radius: 10
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2
    )
}
