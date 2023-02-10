//
//  ActivityLevelSelectionViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.02.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol ActivityLevelSelectionViewControllerInterface: AnyObject {
    func set(activityLevels: [ActivityLevel])
    func set(currentOnboardingStage: OnboardingStage)
}

class ActivityLevelSelectionViewController: UIViewController {
    var presenter: ActivityLevelSelectionPresenterInterface?
    
    // MARK: - Private properties
    
    var isHidden: Bool = false {
        didSet { didChangeIsHidden() }
    }
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "192621")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = R.font.sfProRoundedMedium(size: 30)
        label.colorString(
            text: R.string.localizable.onboardingFourthActivityLevelTitleFirstPart()
            + " "
            + R.string.localizable.onboardingFourthActivityLevelTitleSecondPart() ,
            coloredText: R.string.localizable.onboardingFourthActivityLevelTitleSecondPart(),
            color: UIColor(hex: "12834D"),
            additionalAttributes: [.kern: 0.38]
        )
        return label
    }()
    
    private let stackView: UIStackView = .init()
    private var answerOptions: [AnswerOptionWithSubtitle] = []
    
    let awareView: UIView = {
       let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.layer.cornerCurve = .continuous
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hex: "DEEBEE").cgColor
        let aboutIcon = UIImageView(image: R.image.onboardings.aboutIcon())
        containerView.addSubview(aboutIcon)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 0.96
        titleLabel.attributedText = NSAttributedString(
            string: R.string.localizable.onboardingFourthActivityLevelKeepInMind(),
            attributes: [
                .font: R.font.sfProRoundedMedium(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor(hex: "192621"),
                .kern: 0.38,
                .paragraphStyle: paragraph
            ]
        )
        containerView.addSubview(titleLabel)
        let subtitle = UILabel()
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        subtitle.attributedText = NSAttributedString(
            string: R.string.localizable.onboardingFourthActivityLevelKeepInMindAwareness(),
            attributes: [
                .font: R.font.sfProTextMedium(size: 14) ?? .systemFont(ofSize: 14),
                .foregroundColor: UIColor(hex: "547771"),
                .kern: 0.38
            ]
        )
        containerView.addSubview(subtitle)
        aboutIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.top.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(aboutIcon)
            make.leading.equalTo(aboutIcon.snp.trailing).offset(4)
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(aboutIcon.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        return containerView
    }()
    
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFourthEmotionalSupportSystemButton().uppercased()
    )
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = R.string.localizable.onboardingFourthEmotionalSupportSystemTitle()
        
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.showsVerticalScrollIndicator = false
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        continueCommonButton.isHidden = true
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)

        contentView.addSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
        contentView.addSubview(continueCommonButton)
        
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
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(5)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        answerOptions.forEach { answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
            } else {
                answerOption.isSelected = false
            }
        }
        
        if answerOptions.contains(where: { $0.isSelected == true }) {
            answerOptions.forEach { $0.isTransparent = !$0.isSelected }
        } else {
            answerOptions.forEach { $0.isTransparent = false }
        }
        
        continueCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
    }
    
    @objc func didTapContinueCommonButton() {
        guard let index = answerOptions.firstIndex(where: { $0.isSelected }) else { return }
        presenter?.didTapContinueCommonButton(with: ActivityLevel.allCases[index])
    }
    
    private func didChangeIsHidden() {
        if isHidden {
            continueCommonButton.isHidden = false
        } else {
            continueCommonButton.isHidden = true
        }
    }
}

extension ActivityLevelSelectionViewController: ActivityLevelSelectionViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(activityLevels: [ActivityLevel]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for (index, level) in activityLevels.enumerated() {
            let answerOption = AnswerOptionWithSubtitle(
                title: level.getTitle(.long) ?? "",
                subtitle: level.onboardingDescription
            )
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
            if index == activityLevels.count - 1 {
                stackView.setCustomSpacing(24, after: answerOption)
            }
        }
        stackView.addArrangedSubview(awareView)
    }
}
