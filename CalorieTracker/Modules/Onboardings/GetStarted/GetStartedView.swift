//
//  GetStartedView.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import SnapKit
import UIKit

final class GetStartedView: UIView {
    
    // MARK: - Views properties
    
    private let topImage: UIImage = R.image.onboardings.topImages() ?? UIImage()
    private let topImageView: UIImageView = .init()
    private let stackView: UIStackView = .init()
    private let logoImageView: UIImageView = .init()
    private let logoTextImageView: UIImageView = .init()
    private let trackCheckMarkDescriptionView: CheckMarkDescriptionView = .init(text: "Track what you eat")
    private let followCheckMarkDescriptionView: CheckMarkDescriptionView = .init(text: "Follow a calorie budget")
    private let reachCheckMarkDescriptionView: CheckMarkDescriptionView = .init(text: "Reach your goals")
    private let getStartedCommonButton: CommonButton = .init(style: .filled, text: "Get started")
    private let getStartedSignInAppleButton: SignInAppleButton = .init()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        topImageView.image = topImage
        
        logoImageView.image = R.image.onboardings.logoImage()
        
        logoTextImageView.image = R.image.onboardings.logoTextImage()
        
        getStartedCommonButton.addTarget(self, action: #selector(didTapGetStartedCommonButton),
                                         for: .touchUpInside)
        
        getStartedSignInAppleButton.addTarget(self, action: #selector(didTapGetStartedSignInAppleButton),
                                              for: .touchUpInside)
    }
    
    private func configureLayouts() {
        addSubview(topImageView)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(logoImageView)
        stackView.setCustomSpacing(12, after: logoImageView)
        
        stackView.addArrangedSubview(logoTextImageView)
        stackView.setCustomSpacing(45, after: logoTextImageView)
        
        stackView.addArrangedSubview(trackCheckMarkDescriptionView)
        stackView.setCustomSpacing(6, after: trackCheckMarkDescriptionView)
        
        stackView.addArrangedSubview(followCheckMarkDescriptionView)
        stackView.setCustomSpacing(6, after: followCheckMarkDescriptionView)

        stackView.addArrangedSubview(reachCheckMarkDescriptionView)
        
        addSubview(getStartedCommonButton)
        addSubview(getStartedSignInAppleButton)
                
        topImageView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(topImageView.snp.height).multipliedBy(topImage.size.width / topImage.size.height)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
        }
        
        trackCheckMarkDescriptionView.snp.makeConstraints {
            $0.width.equalTo(reachCheckMarkDescriptionView.snp.width)
        }
        
        followCheckMarkDescriptionView.snp.makeConstraints {
            $0.width.equalTo(reachCheckMarkDescriptionView.snp.width)
        }
        
        getStartedCommonButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        getStartedSignInAppleButton.snp.makeConstraints {
            $0.top.equalTo(getStartedCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapGetStartedCommonButton() {
        print("didTapGetStartedCommonButton")
    }
    
    @objc private func didTapGetStartedSignInAppleButton() {
        print("didTapGetStartedSignInAppleButton")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
