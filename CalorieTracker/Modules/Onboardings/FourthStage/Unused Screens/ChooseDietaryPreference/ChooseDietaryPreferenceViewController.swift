//
//  ChooseDietaryPreferenceViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 02.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

//import UIKit
//
//protocol ChooseDietaryPreferenceViewControllerInterface: AnyObject {
//    func set(currentOnboardingStage: OnboardingStage)
//}
//
//class ChooseDietaryPreferenceViewController: UIViewController {
//    var presenter: ChooseDietaryPreferencePresenterInterface?
//    private let stageCounterView: StageCounterView = .init()
//    private var selectedDietary: UserDietary = .classic
//    private let continueCommonButton: CommonButton = .init(
//        style: .filled,
//        text: R.string.localizable.onboardingFourthEmotionalSupportSystemButton().uppercased()
//    )
//    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 16
//        stackView.clipsToBounds = false
//        buttonsModels.enumerated().forEach { index, model in
//            let button = ButtonWithSubtitle(Constants.shadows)
//            button.viewModel = model
//            button.tag = index
//            button.layer.cornerRadius = 16.fitH
//            button.layer.cornerCurve = .continuous
//            button.addTarget(self, action: #selector(dietaryDidChoose(sender:)), for: .touchUpInside)
//            stackView.addArrangedSubview(button)
//        }
//        return stackView
//    }()
//    
//    private lazy var buttonsModels: [ButtonWithSubtitleViewModel] = [
//        .init(
//            image: R.image.onboardings.dietaryClassic(),
//            title: R.string.localizable.onboardingFourthDietaryPreferenceDietClassicTitle(),
//            subtitle: R.string.localizable.onboardingFourthDietaryPreferenceDietClassicSubtitle()
//        ),
//        .init(
//            image: R.image.onboardings.dietaryPescetarian(),
//            title: R.string.localizable.onboardingFourthDietaryPreferenceDietPescatarianTitle(),
//            subtitle: R.string.localizable.onboardingFourthDietaryPreferenceDietPescatarianSubtitle()
//        ),
//        .init(
//            image: R.image.onboardings.dietaryVegetarian(),
//            title: R.string.localizable.onboardingFourthDietaryPreferenceDietVegetarianTitle(),
//            subtitle: R.string.localizable.onboardingFourthDietaryPreferenceDietVegetarianSubtitle()
//        ),
//        .init(
//            image: R.image.onboardings.dietaryVegan(),
//            title: R.string.localizable.onboardingFourthDietaryPreferenceDietVeganTitle(),
//            subtitle: R.string.localizable.onboardingFourthDietaryPreferenceDietVeganSubtitle()
//        )
//    ]
//    
////    private lazy var classicSelectionButton: ButtonWithSubtitle =
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor(hex: "192621")
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.font = R.font.sfProRoundedMedium(size: 30.fitH)
//        label.colorString(
//            text: R.string.localizable.onboardingFourthDietaryPreferenceTitleFirst()
//            + " "
//            + R.string.localizable.onboardingFourthDietaryPreferenceTitleSecond(),
//            coloredText: R.string.localizable.onboardingFourthDietaryPreferenceTitleFirst(),
//            color: UIColor(hex: "12834D"),
//            additionalAttributes: [.kern: 0.38]
//        )
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupSubviews()
//        presenter?.viewDidLoad()
//        updateAppearance()
//        setupActions()
//    }
//    
//    private func setupActions() {
//        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
//    }
//    
//    @objc private func dietaryDidChoose(sender: ButtonWithSubtitle) {
//        sender.isSelected = !sender.isSelected
//        stackView.arrangedSubviews.forEach {
//            guard let button = $0 as? ButtonWithSubtitle else { return }
//            if button != sender {
//                button.isSelected = false
//            }
//        }
//        updateAppearance()
//        if sender.isSelected {
//            switch sender.tag {
//            case 0:
//                selectedDietary = .classic
//            case 1:
//                selectedDietary = .pescatarian
//            case 2:
//                selectedDietary = .vegetarian
//            case 3:
//                selectedDietary = .vegan
//            default:
//                return
//            }
//        }
//    }
//    
//    @objc func didTapContinueCommonButton() {
//        presenter?.didTapContinueCommonButton(with: selectedDietary)
//    }
//    
//    private func updateAppearance() {
//        guard let buttons = stackView.arrangedSubviews as? [ButtonWithSubtitle] else { return }
//        var shouldShowContinueButton = false
//        for button in buttons where button.isSelected {
//            shouldShowContinueButton = true
//        }
//        continueCommonButton.isHidden = !shouldShowContinueButton
//    }
//    
//    private func setupSubviews() {
//        view.backgroundColor = R.color.mainBackground()
//        view.addSubviews(stageCounterView, titleLabel, stackView, continueCommonButton)
//        title = R.string.localizable.onboardingFourthEmotionalSupportSystemTitle()
//        stageCounterView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30.fitH)
//        }
//        
//        titleLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(43.fitW)
//            make.top.equalTo(stageCounterView.snp.bottom).offset(62.fitH)
//        }
//        
//        stackView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(24.fitW)
//            make.top.equalTo(titleLabel.snp.bottom).offset(44.fitH)
//        }
//        
//        continueCommonButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(40)
//            make.height.equalTo(64)
//            make.bottom.equalToSuperview().inset(UIDevice.isSmallDevice ? 20 : 80)
//        }
//    }
//}
//
//extension ChooseDietaryPreferenceViewController: ChooseDietaryPreferenceViewControllerInterface {
//    enum Constants {
//        static let shadows: [Shadow] = [
//            .init(
//                color: R.color.widgetShadowColorMainLayer()!,
//                opacity: 0.25,
//                offset: .init(width: 1, height: 4),
//                radius: 10,
//                spread: 0
//            ),
//            .init(
//                color: R.color.widgetShadowColorSecondaryLayer()!,
//                opacity: 0.2,
//                offset: .init(width: 1, height: 0.5),
//                radius: 2,
//                spread: 0
//            )
//        ]
//    }
//    
//    func set(currentOnboardingStage: OnboardingStage) {
//        stageCounterView.set(onboardingStage: currentOnboardingStage)
//    }
//}
