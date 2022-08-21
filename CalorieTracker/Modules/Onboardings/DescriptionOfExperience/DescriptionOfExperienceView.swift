//
//  DescriptionOfExperienceView.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all


final class DescriptionOfExperienceView: UIView {
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let neverLostAnswerOption: AnswerOption = .init(text: "I’ve never lost much weight before")
    private let lostWeightAndGainedAllBackAnswerOption: AnswerOption = .init( text: "I lost weight and gained it all back")
    private let lostWeightAndGainedSomeBackAnswerOption: AnswerOption = .init( text: "I lost weight and gained it some back")
    private let lostWeightAndHaveMoreLoseAnswerOption: AnswerOption = .init( text: "I lost weight and have more lose")
    private let lostWeightAndMaintainingAnswerOption: AnswerOption = .init(text: "I lost weight and am maintaining it")
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
        
        attributedString.append(NSAttributedString(string: "What best describes\n ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "your past experiences \nwith weight loss?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        let neverLostAnswerOptionGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapNeverLostAnswerOption(_:)))
        neverLostAnswerOption.addGestureRecognizer(neverLostAnswerOptionGesture)
        
        let lostWeightAndGainedAllBackGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapLostWeightAndGainedAllBack(_:)))
        lostWeightAndGainedAllBackAnswerOption.addGestureRecognizer(lostWeightAndGainedAllBackGesture)
        
        let lostWeightAndGainedSomeBackGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapLostWeightAndGainedSomeBack(_:)))
        lostWeightAndGainedSomeBackAnswerOption.addGestureRecognizer(lostWeightAndGainedSomeBackGesture)
        
        let lostWeightAndHaveMoreLoseGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapLostWeightAndHaveMoreLose(_:)))
        lostWeightAndHaveMoreLoseAnswerOption.addGestureRecognizer(lostWeightAndHaveMoreLoseGesture)
        
        let lostWeightAndMaintainingGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapLostWeightAndMaintaining(_:)))
        lostWeightAndMaintainingAnswerOption.addGestureRecognizer(lostWeightAndMaintainingGesture)
        
        
        nextCommonButton.isHidden = true
    }
    
    private func configureLayouts() {
        addSubview(plugView)
        
        addSubview(titleLabel)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(neverLostAnswerOption)
        stackView.addArrangedSubview(lostWeightAndGainedAllBackAnswerOption)
        stackView.addArrangedSubview(lostWeightAndGainedSomeBackAnswerOption)
        stackView.addArrangedSubview(lostWeightAndHaveMoreLoseAnswerOption)
        stackView.addArrangedSubview(lostWeightAndMaintainingAnswerOption)
        
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
    
    @objc func didTapNeverLostAnswerOption(_ sender: UITapGestureRecognizer) {
        neverLostAnswerOption.isSelected = !neverLostAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapLostWeightAndGainedAllBack(_ sender: UITapGestureRecognizer) {
        lostWeightAndGainedAllBackAnswerOption.isSelected = !lostWeightAndGainedAllBackAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapLostWeightAndGainedSomeBack(_ sender: UITapGestureRecognizer) {
        lostWeightAndGainedSomeBackAnswerOption.isSelected = !lostWeightAndGainedSomeBackAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapLostWeightAndHaveMoreLose(_ sender: UITapGestureRecognizer) {
        lostWeightAndHaveMoreLoseAnswerOption.isSelected = !lostWeightAndHaveMoreLoseAnswerOption.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapLostWeightAndMaintaining(_ sender: UITapGestureRecognizer) {
        lostWeightAndMaintainingAnswerOption.isSelected = !lostWeightAndMaintainingAnswerOption.isSelected
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
