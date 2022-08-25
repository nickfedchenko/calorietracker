//
//  AchievementByWillpowerViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol AchievementByWillPowerViewControllerInterface: AnyObject {}

final class AchievementByWillPowerViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: AchievementByWillPowerPresenterInterface?
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let letsDoItCommonButton: CommonButton = .init(style: .filled, text: "Let’s do it!".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "History"
        
        view.backgroundColor = R.color.mainBackground()
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        imageView.image = R.image.onboardings.emojiBotan()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "It doesn’t take \nunlimited willpower to ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        attributedString.append(NSAttributedString(
            string: "achieve your goals.",
            attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = "Learning and implementing some new habits can go a long way in getting you \nthere. Are you ready to take the first steps towards building your own strong habits?"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        letsDoItCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(imageView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(descriptionLabel)
        
        view.addSubview(letsDoItCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(plugView.snp.bottom).offset(80)
            $0.centerX.equalTo(view.snp.centerX)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(26)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
        }
        
        letsDoItCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapNextCommonButton() {
        presenter?.didTapNextCommonButton()
    }
}

// MARK: - AchievementByWillPowerViewControllerInterface

extension AchievementByWillPowerViewController: AchievementByWillPowerViewControllerInterface {}
