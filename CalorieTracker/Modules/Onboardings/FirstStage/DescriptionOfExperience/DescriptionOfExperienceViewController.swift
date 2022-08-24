//
//  DescriptionOfExperienceViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol DescriptionOfExperienceViewControllerInterface: AnyObject {
    func set(descriptionOfExperiences: [DescriptionOfExperience])
}

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
    private var answerOptions: [AnswerOption] = []
    private let nextCommonButton: CommonButton = .init(style: .filled, text: "Next".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "History"
        
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
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
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
        answerOptions.enumerated().forEach { index, answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
                isSelected ? presenter?.didSelectDescriptionOfExperience(with: index) : presenter?.didDeselectDescriptionOfExperience()
            } else {
                answerOption.isSelected = false
            }
        }
        
        if answerOptions.contains(where: { $0.isSelected == true }) {
            answerOptions.forEach { $0.isTransparent = !$0.isSelected }
        } else {
            answerOptions.forEach { $0.isTransparent = false }
        }
        
        nextCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
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

// MARK: - DescriptionOfExperienceViewControllerInterface

extension DescriptionOfExperienceViewController: DescriptionOfExperienceViewControllerInterface {
    func set(descriptionOfExperiences: [DescriptionOfExperience]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for descriptionOfExperience in descriptionOfExperiences {
            let answerOption = AnswerOption(text: descriptionOfExperience.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

fileprivate extension DescriptionOfExperience {
    var description: String {
        switch self {
        case .iHaveNeverLostMuchWeightBefore:
            return "I’ve never lost much weight before"
        case .iLostWeightAndGainedItAllBack:
            return "I lost weight and gained it all back"
        case .iLostWeightAndGainedSomeBack:
            return "I lost weight and gained some back"
        case .iLostWeightAndHaveMoreLose:
            return "I lost weight and have more lose"
        case .iLostWeightAndAmMaintainingIt:
            return "I lost weight and am maintaining it"
        }
    }
}
