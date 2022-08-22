//
//  QuestionAboutTheChangeViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

protocol QuestionAboutTheChangeViewControllerInterface: AnyObject {}

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
    private let stackView: UIStackView = .init()
    private let differentMindsetAnswerOption: AnswerOption = .init(text: "I have a different mindset")
    private let hadSomeBigChangesAnswerOption: AnswerOption = .init(text: "I’ve had some big changes in my life")
    private let weightMoreAnswerOption: AnswerOption = .init(text: "I weight more than I did last time")
    private let ryingDifferentWayAnswerOption: AnswerOption = .init(text: "I’m trying a different way of eating")
    private let tryingNewExercisePlanAnswerOption: AnswerOption = .init(text: "I’m trying a new exercise plan")
    private let someHealthChangesAnswerOption: AnswerOption = .init(text: "I’ve had some health changes")
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
        
        differentMindsetAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        hadSomeBigChangesAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        weightMoreAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        ryingDifferentWayAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        tryingNewExercisePlanAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        someHealthChangesAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(descriptionLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(differentMindsetAnswerOption)
        stackView.addArrangedSubview(hadSomeBigChangesAnswerOption)
        stackView.addArrangedSubview(weightMoreAnswerOption)
        stackView.addArrangedSubview(ryingDifferentWayAnswerOption)
        stackView.addArrangedSubview(tryingNewExercisePlanAnswerOption)
        stackView.addArrangedSubview(someHealthChangesAnswerOption)
        
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

extension QuestionAboutTheChangeViewController: QuestionAboutTheChangeViewControllerInterface {}
