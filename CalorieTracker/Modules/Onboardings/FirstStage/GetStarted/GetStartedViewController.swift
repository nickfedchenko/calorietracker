//
//  GetStartedViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

protocol GetStartedViewControllerInterface: AnyObject {}

final class GetStartedViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: GetStartedPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let topImage: UIImage = R.image.onboardings.topImages() ?? UIImage()
    private let topImageView: UIImageView = .init()
    private let stackView: UIStackView = .init()
    private let logoImageView: UIImageView = .init()
    private let logoTextImageView: UIImageView = .init()
    private let trackCheckMarkDescriptionView: CheckMarkDescriptionView = .init(
        text: R.string.localizable.onboardingFirstGetStartedTrack()
    )
    private let followCheckMarkDescriptionView: CheckMarkDescriptionView = .init(
        text: R.string.localizable.onboardingFirstGetStartedFollow()
    )
    private let reachCheckMarkDescriptionView: CheckMarkDescriptionView = .init(
        text: R.string.localizable.onboardingFirstGetStartedReach()
    )
    private let getStartedCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFirstGetStartedGetStarted()
    )
    private let getStartedSignInAppleButton: SignInAppleButton = .init()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.contentInsetAdjustmentBehavior = .never
        scrolView.showsVerticalScrollIndicator = false
        
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
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(topImageView)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(logoImageView)
        stackView.setCustomSpacing(12, after: logoImageView)
        
        stackView.addArrangedSubview(logoTextImageView)
        stackView.setCustomSpacing(45, after: logoTextImageView)
        
        stackView.addArrangedSubview(trackCheckMarkDescriptionView)
        stackView.setCustomSpacing(6, after: trackCheckMarkDescriptionView)
        
        stackView.addArrangedSubview(followCheckMarkDescriptionView)
        stackView.setCustomSpacing(6, after: followCheckMarkDescriptionView)

        stackView.addArrangedSubview(reachCheckMarkDescriptionView)
        
        contentView.addSubview(getStartedCommonButton)
        contentView.addSubview(getStartedSignInAppleButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrolView.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(scrolView.snp.bottom)
            $0.height.greaterThanOrEqualTo(scrolView.snp.height)
        }
                
        topImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.width.equalTo(topImageView.snp.height).multipliedBy(topImage.size.width / topImage.size.height)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        trackCheckMarkDescriptionView.snp.makeConstraints {
            $0.width.equalTo(reachCheckMarkDescriptionView.snp.width)
        }
        
        followCheckMarkDescriptionView.snp.makeConstraints {
            $0.width.equalTo(reachCheckMarkDescriptionView.snp.width)
        }
        
        getStartedCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(followCheckMarkDescriptionView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        getStartedSignInAppleButton.snp.makeConstraints {
            $0.top.equalTo(getStartedCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapGetStartedCommonButton() {
        presenter?.didTapGetStartedCommonButton()
    }
    
    @objc private func didTapGetStartedSignInAppleButton() {
        print("didTapGetStartedSignInAppleButton")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - GetStartedViewControllerInterface

extension GetStartedViewController: GetStartedViewControllerInterface {}
