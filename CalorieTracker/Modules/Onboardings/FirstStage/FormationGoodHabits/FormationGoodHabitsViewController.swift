//
//  FormationGoodHabitsViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol FormationGoodHabitsViewControllerInterface: AnyObject {
    func set(formationGoodHabits: [FormationGoodHabits])
    func set(currentOnboardingStage: OnboardingStage)
}

final class FormationGoodHabitsViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: FormationGoodHabitsPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var answerOptions: [AnswerOption] = []
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFirstFormationGoodHabitsButton().uppercased()
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
        title = R.string.localizable.onboardingFirstFormationGoodHabitsTitle()
        
        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFirstFormationGoodHabitsTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFirstFormationGoodHabitsTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = R.string.localizable.onboardingFirstFormationGoodHabitsDescription()
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(descriptionLabel)
        
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
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.left.equalTo(contentView.snp.left).offset(32)
            $0.right.equalTo(contentView.snp.right).offset(-32)
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
        answerOptions.enumerated().forEach { index, answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
                if isSelected {
                    presenter?.didSelectFormationGoodHabits(with: index)
                } else {
                    presenter?.didDeselectFormationGoodHabits()
                }
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
    
    @objc func didTapContinueCommonButton(_ sender: AnswerOption) {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - FormationGoodHabitsViewControllerInterface

extension FormationGoodHabitsViewController: FormationGoodHabitsViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(formationGoodHabits: [FormationGoodHabits]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for formationGoodHabits in formationGoodHabits {
            let answerOption = AnswerOption(text: formationGoodHabits.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

// MARK: - FormationGoodHabits + description

fileprivate extension FormationGoodHabits {
    var description: String {
        switch self {
        case .logEveryMealBefore:
            return R.string.localizable.onboardingFirstFormationGoodHabitsLogEveryMealBefore()
        case .logOnDaysEvenWhenKnow:
            return R.string.localizable.onboardingFirstFormationGoodHabitsLogOnDaysEvenWhenKnow()
        case .stayOnTrackWithAnAccountabilityBuddy:
            return R.string.localizable.onboardingFirstFormationGoodHabitsStayOnTrackWithAnAccountabilityBuddy()
        case .planOutMyMealsInAdvance:
            return R.string.localizable.onboardingFirstFormationGoodHabitsPlanOutMyMealsInAdvance()
        case .seeHowLongOfTrackingStreak:
            return R.string.localizable.onboardingFirstFormationGoodHabitsSeeHowLongOfTrackingStreak()
        case .planOutDaysWhereKnow:
            return R.string.localizable.onboardingFirstFormationGoodHabitsPlanOutDaysWhereKnow()
        }
    }
}
