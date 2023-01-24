//
//  FinalOfTheSecondStageViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation
import UIKit

protocol FinalOfTheSecondStageViewControllerInterface: AnyObject {}

final class FinalOfTheSecondStageViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: FinalOfTheSecondStagePresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let passedImageView: UIImageView = .init()
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
    private let continueToMotivationCommonButton = CommonButton(
        style: .filled,
        text: R.string.localizable.onboardingSecondFinalButton().uppercased()
    )
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        
        scrolView.showsVerticalScrollIndicator = false
        
        passedImageView.image = R.image.onboardings.passed()
        
        let attributedString = NSMutableAttributedString()

        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingSecondFinalTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingSecondFinalTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        titleLabel.attributedText = attributedString
        
        titleLabel.attributedText = attributedString
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        
        descriptionLabel.text = R.string.localizable.onboardingSecondFinalDescription()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.textColor = R.color.onboardings.basicDarkGray()
   
        historyDotImageView.image = R.image.onboardings.complet()
        
        historyLabel.text = R.string.localizable.onboardingSecondFinalHistory()
        historyLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        historyLabel.textColor = R.color.onboardings.basicDark()
        
        userDataDotImageView.image = R.image.onboardings.complet()
        
        userDataLabel.text = R.string.localizable.onboardingSecondFinalUserData()
        userDataLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        userDataLabel.textColor = R.color.onboardings.basicDark()
        
        motivationImageView.image = R.image.onboardings.dotOn()
        
        motivationLabel.text = R.string.localizable.onboardingSecondFinalMotivation()
        motivationLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        motivationLabel.textColor = R.color.onboardings.basicDark()
        
        habitsImageView.image = R.image.onboardings.dotOff()
        
        habitsLabel.text = R.string.localizable.onboardingSecondFinalHabits()
        habitsLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        habitsLabel.textColor = R.color.onboardings.basicDark()
        
        delimeterView.backgroundColor = .black
        
        continueToMotivationCommonButton.addTarget(
            self,
            action: #selector(didTapContinueToMotivation),
            for: .touchUpInside
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(passedImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(delimeterView)
        
        contentView.addSubview(historyDotImageView)
        contentView.addSubview(historyLabel)
        
        contentView.addSubview(userDataDotImageView)
        contentView.addSubview(userDataLabel)
        
        contentView.addSubview(motivationImageView)
        contentView.addSubview(motivationLabel)
        
        contentView.addSubview(habitsImageView)
        contentView.addSubview(habitsLabel)
        
        contentView.addSubview(continueToMotivationCommonButton)
        
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
        
        passedImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(passedImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.left.equalTo(contentView.snp.left).offset(42)
            $0.right.equalTo(contentView.snp.right).offset(-42)
        }
    
        historyDotImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.left.equalTo(contentView.snp.left).offset(100)
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
    
        continueToMotivationCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(delimeterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }

    @objc private func didTapContinueToMotivation() {
        presenter?.didTapContinueToMotivation()
    }
}

// MARK: - FinalOfTheSecondStageViewControllerInterface

extension FinalOfTheSecondStageViewController: FinalOfTheSecondStageViewControllerInterface {}
