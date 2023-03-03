//
//  MenuCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

// swiftlint:disable:next operator_usage_whitespace
final class MenuCellView<ID: WithGetTitleProtocol
                            & WithGetImageProtocol
                            & WithGetDescriptionProtocol>: ControlWithShadow {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        return label
    }()
    
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
        super.init([ShadowConst.firstShadow, ShadowConst.secondShadow])
        titleLabel.text = model.getTitle(.long)
        
        if let image = model.getImage() {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
        if let description = model.getDescription() {
            descriptionLabel.attributedText = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        
        setupView()
        addSubviews()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.borderWidth = 1
    }
    
    private func addSubviews() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(imageView, textStackView)
        textStackView.addArrangedSubviews(titleLabel, descriptionLabel)
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
