//
//  DescriptionOfExperienceViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol DescriptionOfExperienceViewControllerInterface: AnyObject {}

final class DescriptionOfExperienceViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: DescriptionOfExperiencePresenterInterface?
    
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
        
        attributedString.append(NSAttributedString(string: "What best describes\n ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "your past experiences \nwith weight loss?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        neverLostAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        lostWeightAndGainedAllBackAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        lostWeightAndGainedSomeBackAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        lostWeightAndHaveMoreLoseAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        lostWeightAndMaintainingAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(neverLostAnswerOption)
        stackView.addArrangedSubview(lostWeightAndGainedAllBackAnswerOption)
        stackView.addArrangedSubview(lostWeightAndGainedSomeBackAnswerOption)
        stackView.addArrangedSubview(lostWeightAndHaveMoreLoseAnswerOption)
        stackView.addArrangedSubview(lostWeightAndMaintainingAnswerOption)
        
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
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
}

extension DescriptionOfExperienceViewController: DescriptionOfExperienceViewControllerInterface {}
