//
//  PurposeOfTheParishView.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

final class PurposeOfTheParishView: UIView {
    
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
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
        didChangeIsHeaden()
    }
    
    private func configureViews() {
        backgroundColor = R.color.mainBackground()
        
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
        
        let timeToGetBackHealthyHabitsAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapTimeToGetBackHealthyHabitsAnswerOption(_:)))
        timeToGetBackHealthyHabitsAnswerOption.addGestureRecognizer(timeToGetBackHealthyHabitsAnswerOptionGesture)
        
        let unhappyWithMyWeightAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapUnhappyWithMyWeightAnswerOption(_:)))
        unhappyWithMyWeightAnswerOption.addGestureRecognizer(unhappyWithMyWeightAnswerOptionGesture)
        
        let haveSomeFreshMotivationAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapHaveSomeFreshMotivationAnswerOption(_:)))
        haveSomeFreshMotivationAnswerOption.addGestureRecognizer(haveSomeFreshMotivationAnswerOptionGesture)
        
        let readyStartFeelingGoodAgainAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapReadyStartFeelingGoodAgainAnswerOption(_:)))
        readyStartFeelingGoodAgainAnswerOption.addGestureRecognizer(readyStartFeelingGoodAgainAnswerOptionGesture)
        
        let curiousCheckOutKcalcAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapCuriousCheckOutKcalcAnswerOption(_:)))
        curiousCheckOutKcalcAnswerOption.addGestureRecognizer(curiousCheckOutKcalcAnswerOptionGesture)
        
        let somethingElseAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSomethingElseAnswerOption(_:)))
        somethingElseAnswerOption.addGestureRecognizer(somethingElseAnswerOptionGesture)
        
        nextCommonButton.isHidden = true
    }
    
    private func configureLayouts() {
        addSubview(plugView)
        
        addSubview(titleLabel)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(timeToGetBackHealthyHabitsAnswerOption)
        stackView.addArrangedSubview(unhappyWithMyWeightAnswerOption)
        stackView.addArrangedSubview(haveSomeFreshMotivationAnswerOption)
        stackView.addArrangedSubview(readyStartFeelingGoodAgainAnswerOption)
        stackView.addArrangedSubview(curiousCheckOutKcalcAnswerOption)
        stackView.addArrangedSubview(somethingElseAnswerOption)
        
        addSubview(nextCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(snp.left).offset(100)
            $0.right.equalTo(snp.right).offset(-100)
            $0.centerX.equalTo(snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(plugView.snp.bottom).offset(32)
            $0.left.equalTo(snp.left).offset(43)
            $0.right.equalTo(snp.right).offset(-43)
            $0.centerX.equalTo(snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
        }
        
        nextCommonButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapTimeToGetBackHealthyHabitsAnswerOption(_ sender: UITapGestureRecognizer) {
        timeToGetBackHealthyHabitsAnswerOption.isSelected = !timeToGetBackHealthyHabitsAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapUnhappyWithMyWeightAnswerOption(_ sender: UITapGestureRecognizer) {
        unhappyWithMyWeightAnswerOption.isSelected = !unhappyWithMyWeightAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapHaveSomeFreshMotivationAnswerOption(_ sender: UITapGestureRecognizer) {
        haveSomeFreshMotivationAnswerOption.isSelected = !haveSomeFreshMotivationAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapReadyStartFeelingGoodAgainAnswerOption(_ sender: UITapGestureRecognizer) {
        readyStartFeelingGoodAgainAnswerOption.isSelected = !readyStartFeelingGoodAgainAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapCuriousCheckOutKcalcAnswerOption(_ sender: UITapGestureRecognizer) {
        curiousCheckOutKcalcAnswerOption.isSelected = !curiousCheckOutKcalcAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapSomethingElseAnswerOption(_ sender: UITapGestureRecognizer) {
        somethingElseAnswerOption.isSelected = !somethingElseAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

