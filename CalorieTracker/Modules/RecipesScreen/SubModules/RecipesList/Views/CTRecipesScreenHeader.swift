//
//  LayoutControlHeaderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import UIKit

final class CTRecipesScreenHeader: UIView {
    
    // Actions
    var changeLayoutAction: (() -> Void)?
    var backButtonTapped: (() -> Void)?
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: nil)
        return view
    }()
    
    private var blurRadiusDriver: UIViewPropertyAnimator?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.chevronLeftSmall(), for: .normal)
        button.tintColor = UIColor(hex: "0C695E")
        let attrTitle = NSAttributedString(
            string: "Recipes".localized,
            attributes: [
                .font: R.font.sfProRoundedBold(size: 15) ?? .systemFont(ofSize: 15),
                .foregroundColor: UIColor(hex: "0C695E")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.titleEdgeInsets.left = 17
//        button.contentMode = .center
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0C695E")
        label.font = R.font.sfProRoundedBold(size: 24)
        label.textAlignment = .left
        return label
    }()
    
    private let changeLayoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.columsViewIcon(), for: .normal)
        button.setImage(R.image.listViewIcon(), for: .selected)
        button.contentMode = .center
//        button.tintColor = UIColor(hex: "7A948F")
//        button.setTitleShadowColor(.clear, for: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupActions()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if changeLayoutButton.frame.contains(point) {
            return changeLayoutButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reinitBlurView()
    }
    
    private func setupActions() {
        changeLayoutButton.addAction(
            UIAction { [weak self] _ in
                self?.changeLayoutAction?()
                self?.changeLayoutButton.isSelected.toggle()
            },
            for: .touchUpInside
        )
        
        backButton.addAction(
            UIAction { [weak self]  _ in
                self?.backButtonTapped?()
            },
            for: .touchUpInside
        )
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    private func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
        blurRadiusDriver?.fractionComplete = 0.4
    }
    
    private func setupSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubviews(backButton, titleLabel, changeLayoutButton)
        
        blurView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.top.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(55)
            make.width.equalTo(99)
        }
        
        changeLayoutButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().inset(5)
            make.width.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(5)
        }
    }
}
