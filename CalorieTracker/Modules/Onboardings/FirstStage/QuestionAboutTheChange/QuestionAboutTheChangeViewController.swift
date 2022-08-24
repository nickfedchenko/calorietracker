//
//  QuestionAboutTheChangeViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

protocol QuestionAboutTheChangeViewControllerInterface: AnyObject {
    func set(questionAboutTheChange: [QuestionAboutTheChange])
}

final class QuestionAboutTheChangeViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: QuestionAboutTheChangePresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private var answerOptions: [AnswerOption] = []
    private let stackView: UIStackView = .init()
    
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
        
        attributedString.append(NSAttributedString(string: "What’s defferent ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "from \nlast time?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = "Other than you using Kcalс, of cource"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(descriptionLabel)
        
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
        answerOptions.enumerated().forEach { index, answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
                isSelected ? presenter?.didSelectQuestionAboutTheChange(with: index) : presenter?.didDeselectQuestionAboutTheChange()
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

extension QuestionAboutTheChangeViewController: QuestionAboutTheChangeViewControllerInterface {
    func set(questionAboutTheChange: [QuestionAboutTheChange]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for questionAboutTheChange in questionAboutTheChange {
            let answerOption = AnswerOption(text: questionAboutTheChange.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

fileprivate extension QuestionAboutTheChange {
    var description: String {
        switch self {
        case .iHaveDifferentMindset:
            return "I have a different mindset"
        case .iHadSomeBigChangesInMyLife:
            return "I’ve had some big changes in my life"
        case .iWeightMoreThanIdidLastTime:
            return "I weight more than I did last time"
        case .iTryingDifferentWayOfEating:
            return "I’m trying a different way of eating"
        case .iTryingNewExercisePlan:
            return "I’m trying a new exercise plan"
        case .iHadSomeHealthChanges:
            return "I’ve had some health changes"
        }
    }
}
