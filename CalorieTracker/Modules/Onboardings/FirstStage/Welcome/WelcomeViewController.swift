//
//  WelcomeViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import SnapKit
import UIKit

// swiftlint:disable line_length

protocol WelcomeViewControllerInterface: AnyObject {}

final class WelcomeViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: WelcomePresenterInterface?
    
    // MARK: - Views properties

    private let welcomImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let historyDotImageView: UIImageView = .init()
    private let historyLabel: UILabel = .init()
    private let userDataDotImageView: UIImageView = .init()
    private let userDataLabel: UILabel = .init()
    private let motivationImageView: UIImageView = .init()
    private let motivationLabel: UILabel = .init()
    private let habitsImageView: UIImageView = .init()
    private let habitsLabel: UILabel = .init()
    private let delimeterView: UIView = .init()
    private let welcomCommonButton: CommonButton = .init(style: .filled, text: "Let’s Go!")
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        welcomImageView.image = R.image.onboardings.welcom()
        
        titleLabel.text = "Welcome!"
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        titleLabel.textColor = R.color.onboardings.basicDark()
        
        descriptionLabel.text = "We’re happy to have you here. We’ll walk\nwalk you through these steps to get you \n set upfor weight loss success:"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.textColor = R.color.onboardings.basicDarkGray()
   
        historyDotImageView.image = R.image.onboardings.dotOn()
        
        historyLabel.text = "History"
        historyLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        historyLabel.textColor = R.color.onboardings.basicDark()
        
        userDataDotImageView.image = R.image.onboardings.dotOff()
        
        userDataLabel.text = "User data"
        userDataLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        userDataLabel.textColor = R.color.onboardings.basicDark()
        
        motivationImageView.image = R.image.onboardings.dotOff()
        
        motivationLabel.text = "Motivation / Goal"
        motivationLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        motivationLabel.textColor = R.color.onboardings.basicDark()
        
        habitsImageView.image = R.image.onboardings.dotOff()
        
        habitsLabel.text = "Habits"
        habitsLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        habitsLabel.textColor = R.color.onboardings.basicDark()
        
        delimeterView.backgroundColor = .black
        
        welcomCommonButton.addTarget(self, action: #selector(didTapWelcomCommonButton),
                                     for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(welcomImageView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(descriptionLabel)
        
        view.addSubview(delimeterView)
        
        view.addSubview(historyDotImageView)
        view.addSubview(historyLabel)
        
        view.addSubview(userDataDotImageView)
        view.addSubview(userDataLabel)
        
        view.addSubview(motivationImageView)
        view.addSubview(motivationLabel)
        
        view.addSubview(habitsImageView)
        view.addSubview(habitsLabel)
        
        view.addSubview(welcomCommonButton)
        
        welcomImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            $0.centerX.equalTo(view.snp.centerX)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(welcomImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.left.equalTo(view.snp.left).offset(42)
            $0.right.equalTo(view.snp.right).offset(-42)
        }
    
        historyDotImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.left.equalTo(view.snp.left).offset(100)
        }
        
        historyLabel.snp.makeConstraints {
            $0.left.equalTo(historyDotImageView.snp.right).offset(24)
            $0.centerY.equalTo(historyDotImageView.snp.centerY)
        }
        
        userDataDotImageView.snp.makeConstraints {
            $0.top.equalTo(historyDotImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(historyDotImageView.snp.centerX)
        }
        
        userDataLabel.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(24)
            $0.left.equalTo(historyLabel.snp.left)
            $0.centerY.equalTo(userDataDotImageView.snp.centerY)
        }
        
        motivationImageView.snp.makeConstraints {
            $0.top.equalTo(userDataDotImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(userDataDotImageView.snp.centerX)
        }
        
        motivationLabel.snp.makeConstraints {
            $0.top.equalTo(userDataLabel.snp.bottom).offset(24)
            $0.left.equalTo(userDataLabel.snp.left)
            $0.centerY.equalTo(motivationImageView.snp.centerY)
        }
        
        habitsImageView.snp.makeConstraints {
            $0.top.equalTo(motivationImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(motivationImageView.snp.centerX)
        }
        
        habitsLabel.snp.makeConstraints {
            $0.top.equalTo(motivationLabel.snp.bottom).offset(24)
            $0.left.equalTo(motivationLabel.snp.left)
            $0.centerY.equalTo(habitsImageView.snp.centerY)
        }
        
        delimeterView.snp.makeConstraints {
            $0.top.equalTo(historyDotImageView.snp.top).offset(-16)
            $0.bottom.equalTo(habitsImageView.snp.bottom).offset(16)
            $0.centerX.equalTo(historyDotImageView.snp.centerX)
            $0.width.equalTo(1)
        }
    
        welcomCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapWelcomCommonButton() {
        presenter?.didTapWelcomCommonButton()
    }
}

// MARK: - WelcomeViewControllerInterface

extension WelcomeViewController: WelcomeViewControllerInterface {}
