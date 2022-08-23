//
//  FormationGoodHabitsViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol FormationGoodHabitsViewControllerInterface: AnyObject {}

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
    private let logEveryMealBeforeAnswerOption: AnswerOption = .init(text: "Log every meal before I eat it")
    private let logOnDaysEvenAnswerOption: AnswerOption = .init(text: "Log on days even when I know I’m \ngoing over budget")
    private let stayOnTrackAnswerOption: AnswerOption = .init(text: "Stay on track with an accountability\n buddy")
    private let mealsInAdvanceAnswerOption: AnswerOption = .init(text: "Plan out my meals in advance")
    private let trackingStreakAnswerOption: AnswerOption = .init(text: "See how long of a tracking streak I can\n keep up")
    private let planOutDaysAnswerOption: AnswerOption = .init(text: "Plan out days where I know I’ll be\n eating indulgent foods")
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue".uppercased())
    
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
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "Building good habits takes a plan ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "and accountability.", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = "How do you plan to stay on track?"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        logEveryMealBeforeAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        logOnDaysEvenAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        stayOnTrackAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        mealsInAdvanceAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        trackingStreakAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        planOutDaysAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(logEveryMealBeforeAnswerOption)
        stackView.addArrangedSubview(logOnDaysEvenAnswerOption)
        stackView.addArrangedSubview(stayOnTrackAnswerOption)
        stackView.addArrangedSubview(mealsInAdvanceAnswerOption)
        stackView.addArrangedSubview(trackingStreakAnswerOption)
        stackView.addArrangedSubview(planOutDaysAnswerOption)
        
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
        }
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(30)
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
        sender.isSelected = !sender.isSelected
    }
    
    @objc func didTapContinueCommonButton(_ sender: AnswerOption) {
        presenter?.didTapContinueCommonButton()
    }
}

extension FormationGoodHabitsViewController: FormationGoodHabitsViewControllerInterface {}
