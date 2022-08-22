//
//  AchievingDifficultGoalViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

protocol AchievingDifficultGoalViewControllerInterface: AnyObject {}

final class AchievingDifficultGoalViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: AchievingDifficultGoalPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let willpowerMentalStrength: AnswerOption = .init(text: "Natural willpower and mental strength")
    private let planAndGoodHabitsAnswerOption: AnswerOption = .init(text: "A plan and good habits")
    private let nextCommonButton: CommonButton = .init(style: .filled, text: "Next".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "Think about someone \nin your life ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "who has \nachieved a difficult \ngoal.", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = "What do you think helped them become successful?"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        willpowerMentalStrength.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        planAndGoodHabitsAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(descriptionLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(willpowerMentalStrength)
        stackView.addArrangedSubview(planAndGoodHabitsAnswerOption)
        
        view.addSubview(nextCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(plugView.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
        
        nextCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        sender.isSelected = !sender.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
}

extension AchievingDifficultGoalViewController: AchievingDifficultGoalViewControllerInterface {}
