//
//  WeightsListFooter.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.04.2023.
//

import UIKit

protocol WeightsListFooterDelegate: AnyObject {
    func didTapToCloseButton()
    func didTapToAddWeightButton()
}

final class WeightsListFooter: UIView {
    var delegate: WeightsListFooterDelegate?
    private var blurRadiusDriver: UIViewPropertyAnimator?
    
    private let closeButtonChevron: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.foodViewing.topChevronOriginal(), for: .normal)
        return button
    }()
    
    private let addWeightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.weightWidget.weightListAdd(), for: .normal)
        return button
    }()
    
    let blurView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        return visualEffectView
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reinitBlurView()
    }
    
    private func setupActions() {
        closeButtonChevron.addTarget(self, action: #selector(didTapToClose), for: .touchUpInside)
        addWeightButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    private func setupAppearance() {
        backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.1
    }
    
    private func setupSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubviews(addWeightButton, closeButtonChevron)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addWeightButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(18)
        }
        
        closeButtonChevron.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.top.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func didTapToClose() {
        delegate?.didTapToCloseButton()
    }
    
    @objc private func didTapAddButton() {
        delegate?.didTapToAddWeightButton()
    }
}
