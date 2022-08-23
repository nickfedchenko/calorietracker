//
//  PurposeOfTheParishViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol PurposeOfTheParishViewControllerInterface: AnyObject {}

final class PurposeOfTheParishViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PurposeOfTheParishPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let timeToGetBackHealthyHabitsAnswerOption: AnswerOption = .init(text: "It’s time to get back to healthy habits")
    private let unhappyWithMyWeightAnswerOption: AnswerOption = .init(text: "I’m unhappy with my weight")
    private let haveSomeFreshMotivationAnswerOption: AnswerOption = .init(text: "I have some fresh motivation")
    private let readyStartFeelingGoodAgainAnswerOption: AnswerOption = .init(text: "I’m ready to start feeling good again")
    private let curiousCheckOutKcalcAnswerOption: AnswerOption = .init(text: "I am curious to check out Kcalc")
    private let somethingElseAnswerOption: AnswerOption = .init(text: "Something else")
    private let nextCommonButton: CommonButton = .init(style: .filled, text: "Next".uppercased())
    
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
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "What brings ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "you here\n now?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        timeToGetBackHealthyHabitsAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        unhappyWithMyWeightAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        haveSomeFreshMotivationAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        readyStartFeelingGoodAgainAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        curiousCheckOutKcalcAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        somethingElseAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(timeToGetBackHealthyHabitsAnswerOption)
        stackView.addArrangedSubview(unhappyWithMyWeightAnswerOption)
        stackView.addArrangedSubview(haveSomeFreshMotivationAnswerOption)
        stackView.addArrangedSubview(readyStartFeelingGoodAgainAnswerOption)
        stackView.addArrangedSubview(curiousCheckOutKcalcAnswerOption)
        stackView.addArrangedSubview(somethingElseAnswerOption)
        
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
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
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
    
    @objc func didTapNextCommonButton() {
        presenter?.didTapNextCommonButton()
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
}

extension PurposeOfTheParishViewController: PurposeOfTheParishViewControllerInterface {}
