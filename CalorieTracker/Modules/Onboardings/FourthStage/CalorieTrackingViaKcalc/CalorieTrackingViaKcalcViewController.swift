//
//  CalorieTrackingViaKcalcViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation
import UIKit

protocol CalorieTrackingViaKcalcViewControllerInterface: AnyObject {}

final class CalorieTrackingViaKcalcViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: CalorieTrackingViaKcalcPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let topImage: UIImage = R.image.onboardings.topImages() ?? UIImage()
    private let topImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let getStartedSignInAppleButton: SignInAppleButton = .init()
    private let continueWithoutRegistrationButton: UIButton = .init()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.contentInsetAdjustmentBehavior = .never
        scrolView.showsVerticalScrollIndicator = false
        
        topImageView.image = topImage
        
        let attributedString = NSMutableAttributedString()

        attributedString.append(NSAttributedString(
            string: "Get the best calorie tracking recommendations and ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        attributedString.append(NSAttributedString(
            string: "stay fit with Kcalc",
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        
        getStartedSignInAppleButton.addTarget(
            self,
            action: #selector(didTapGetStartedSignInAppleButton),
            for: .touchUpInside
        )
        
        continueWithoutRegistrationButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        continueWithoutRegistrationButton.setTitle("Сontinue without registration", for: .normal)
        continueWithoutRegistrationButton.setTitleColor(R.color.onboardings.basicDarkGray(), for: .normal)
        continueWithoutRegistrationButton.addTarget(
            self,
            action: #selector(didTapContinueWithoutRegistrationButton),
            for: .touchUpInside
        )
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(topImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(getStartedSignInAppleButton)
        
        contentView.addSubview(continueWithoutRegistrationButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        getStartedSignInAppleButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        continueWithoutRegistrationButton.snp.makeConstraints {
            $0.top.equalTo(getStartedSignInAppleButton.snp.bottom).offset(30)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
        }
    }
    
    @objc private func didTapGetStartedSignInAppleButton() {
        print("didTapGetStartedSignInAppleButton")
    }
    
    @objc private func didTapContinueWithoutRegistrationButton() {
        print("didTapContinueWithoutRegistrationButton")
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

// MARK: - CalorieTrackingViaKcalcViewControllerInterface

extension CalorieTrackingViaKcalcViewController: CalorieTrackingViaKcalcViewControllerInterface {}
