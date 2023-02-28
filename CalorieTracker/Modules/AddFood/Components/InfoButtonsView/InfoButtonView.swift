//
//  InfoButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.11.2022.
//

import UIKit

final class InfoButtonView<ID: WithGetDataProtocol>: UIControl {
    enum InfoButtonType {
        case settings
        case configurable(ID)
        case immutable(ID)
    }
    
    var buttonType: InfoButtonType = .settings {
        didSet {
            didChangeType()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.addFood.menu.dots()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.sfProTextMedium(size: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let shadowLayer = CALayer()
    
    private var firstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
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
        layer.cornerCurve = .continuous
        layer.cornerRadius = 4
        layer.borderColor = UIColor.white.cgColor
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    private func addSubviews() {
        addSubviews(imageView, titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupShadow() {
        shadowLayer.frame = bounds
        
        shadowLayer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: 4
        )
        shadowLayer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: 4
        )
    }
    
    private func didChangeType() {
        switch buttonType {
        case .settings:
            imageView.isHidden = false
            titleLabel.isHidden = true
            shadowLayer.isHidden = false
            backgroundColor = .white
            layer.borderWidth = 0
        case .configurable(let infoButton):
            shadowLayer.isHidden = false
            imageView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.attributedText = NSAttributedString(
                string: infoButton.getTitle(.short) ?? "",
                attributes: [
                    .font: R.font.sfCompactTextMedium(size: 12) ?? .systemFont(ofSize: 12),
                    .kern: Locale.current.languageCode == "ru" ? -0.36 : 0
                ]
            )
            backgroundColor = infoButton.getColor()
            layer.borderWidth = 1
        case .immutable(let infoButton):
            shadowLayer.isHidden = true
            imageView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.text = infoButton.getTitle(.short)
            backgroundColor = infoButton.getColor()
            layer.borderWidth = 0
        }
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
