//
//  RecipePageScreenHeader.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 13.01.2023.
//

import UIKit

protocol RecipePageScreenHeaderDelegate: AnyObject {
    func backButtonTapped()
}

final class RecipePageScreenHeader: UIView {
    weak var delegate: RecipePageScreenHeaderDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.chevronLeft(), for: .normal)
        button.imageView?.contentMode = .center
        button.imageEdgeInsets.right = 17
        button.tintColor = UIColor(hex: "0C695E")
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textColor = UIColor(hex: "0C695E")
        label.numberOfLines = 2
        return label
    }()
    
    let blurView = UIVisualEffectView(effect: nil)
    private var blurRadiusDriver: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = UIColor(hex: "E5F5F3").withAlphaComponent(0.9)
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reinitBlurView()
    }
    
    func setBackButtonTitle(title: String) {
        let attributedTitle = NSAttributedString(
            string: title.uppercased(),
            attributes: [
                .foregroundColor: UIColor(hex: "0C695E"),
                .font: R.font.sfProRoundedBold(size: 15) ?? .systemFont(ofSize: 15)
            ]
        )
        backButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setTitle(title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 20.29
        let attrTitle = NSAttributedString(
            string: title,
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
        titleLabel.attributedText = attrTitle
    }
    
    func releaseBlurAnimation() {
        blurRadiusDriver?.stopAnimation(true)
    }
    
    private func setupActions() {
        backButton.addAction(
            UIAction { [weak self] _ in
                self?.delegate?.backButtonTapped()
            },
            for: .touchUpInside)
    }
    
    private func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.1
//        blurRadiusDriver?.stopAnimation(true)
//        blurRadiusDriver?.finishAnimation(at: .current)
    }
    
    private func setupSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubview(backButton)
        blurView.contentView.addSubview(titleLabel)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(110)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
