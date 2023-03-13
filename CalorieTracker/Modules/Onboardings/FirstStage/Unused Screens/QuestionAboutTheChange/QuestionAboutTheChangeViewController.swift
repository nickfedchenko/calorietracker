//
//  QuestionAboutTheChangeViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//
//
//import SnapKit
//import UIKit
//
//protocol QuestionAboutTheChangeViewControllerInterface: AnyObject {
//    func set(questionAboutTheChange: [QuestionAboutTheChange])
//    func set(currentOnboardingStage: OnboardingStage)
//}
//
//final class QuestionAboutTheChangeViewController: UIViewController {
//    
//    // MARK: - Public properties
//    
//    var presenter: QuestionAboutTheChangePresenterInterface?
//    
//    // MARK: - Private properties
//    
//    var isHedden: Bool = false {
//        didSet { didChangeIsHeaden() }
//    }
//    
//    // MARK: - Views properties
//    
//    private let scrolView: UIScrollView = .init()
//    private let contentView: UIView = .init()
//    private let stageCounterView: StageCounterView = .init()
//    private let titleLabel: UILabel = .init()
//    private let descriptionLabel: UILabel = .init()
//    private var answerOptions: [AnswerOption] = []
//    private let stackView: UIStackView = .init()
//    
//    private let nextCommonButton: CommonButton = .init(
//        style: .filled,
//        text: R.string.localizable.onboardingFirstQuestionAboutTheChangeButton().uppercased()
//    )
//    
//    // MARK: - Lifecycle methods
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        presenter?.viewDidLoad()
//        
//        configureBackBarButtonItem()
//        configureViews()
//        configureLayouts()
//    }
//    
//    private func configureViews() {
//        title = R.string.localizable.onboardingFirstQuestionAboutTheChangeTitle()
//        descriptionLabel.numberOfLines = 0
//        view.backgroundColor = R.color.mainBackground()
//        
//        scrolView.showsVerticalScrollIndicator = false
//        
//        let attributedString = NSMutableAttributedString()
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFirstQuestionAboutTheChangeTitleFirst(),
//            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
//        ))
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFirstQuestionAboutTheChangeTitleSecond(),
//            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
//        ))
//        
//        titleLabel.attributedText = attributedString
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
//        
//        descriptionLabel.text = R.string.localizable.onboardingFirstQuestionAboutTheChangeDescription()
//        descriptionLabel.textAlignment = .center
//        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        descriptionLabel.textColor = R.color.onboardings.backTitle()
//        
//        stackView.axis = .vertical
//        stackView.spacing = 12
//        
//        nextCommonButton.isHidden = true
//        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
//    }
//    
//    private func configureLayouts() {
//        view.addSubview(scrolView)
//        
//        scrolView.addSubview(contentView)
//        
//        contentView.addSubview(stageCounterView)
//        
//        contentView.addSubview(titleLabel)
//        
//        contentView.addSubview(descriptionLabel)
//        
//        contentView.addSubview(stackView)
//        
//        contentView.addSubview(nextCommonButton)
//        
//        scrolView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.left.equalTo(view.snp.left)
//            $0.right.equalTo(view.snp.right)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//        
//        contentView.snp.makeConstraints {
//            $0.top.equalTo(scrolView.snp.top)
//            $0.left.equalTo(view.snp.left)
//            $0.right.equalTo(view.snp.right)
//            $0.bottom.equalTo(scrolView.snp.bottom)
//            $0.height.greaterThanOrEqualTo(scrolView.snp.height)
//        }
//        
//        stageCounterView.snp.makeConstraints {
//            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
//            $0.centerX.equalTo(contentView.snp.centerX)
//        }
//        
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(stageCounterView.snp.bottom).offset(32)
//            $0.left.equalTo(contentView.snp.left).offset(43)
//            $0.right.equalTo(contentView.snp.right).offset(-43)
//            $0.centerX.equalTo(contentView.snp.centerX)
//        }
//        
//        descriptionLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
//            $0.left.equalTo(contentView.snp.left).offset(43)
//            $0.right.equalTo(contentView.snp.right).offset(-43)
//        }
//        
//        stackView.snp.makeConstraints {
//            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
//            $0.left.equalTo(contentView.snp.left).offset(40)
//            $0.right.equalTo(contentView.snp.right).offset(-40)
//        }
//        
//        nextCommonButton.snp.makeConstraints {
//            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
//            $0.left.equalTo(contentView.snp.left).offset(40)
//            $0.right.equalTo(contentView.snp.right).offset(-40)
//            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-35)
//            $0.height.equalTo(64)
//        }
//    }
//    
//    @objc func didTapAnswerOption(_ sender: AnswerOption) {
//        answerOptions.enumerated().forEach { index, answerOption in
//            if answerOption == sender {
//                let isSelected = !answerOption.isSelected
//                
//                answerOption.isSelected = isSelected
//                
//                if isSelected {
//                    presenter?.didSelectQuestionAboutTheChange(with: index)
//                } else {
//                    presenter?.didDeselectQuestionAboutTheChange()
//                }
//            } else {
//                answerOption.isSelected = false
//            }
//        }
//        
//        if answerOptions.contains(where: { $0.isSelected == true }) {
//            answerOptions.forEach { $0.isTransparent = !$0.isSelected }
//        } else {
//            answerOptions.forEach { $0.isTransparent = false }
//        }
//        
//        nextCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
//    }
//    
//    @objc func didTapNextCommonButton() {
//        presenter?.didTapNextCommonButton()
//    }
//    
//    private func didChangeIsHeaden() {
//        if isHedden {
//            nextCommonButton.isHidden = false
//        } else {
//            nextCommonButton.isHidden = true
//        }
//    }
//}
//
//// MARK: - QuestionAboutTheChangeViewControllerInterface
//
//extension QuestionAboutTheChangeViewController: QuestionAboutTheChangeViewControllerInterface {
//    func set(currentOnboardingStage: OnboardingStage) {
//        stageCounterView.set(onboardingStage: currentOnboardingStage)
//    }
//    func set(questionAboutTheChange: [QuestionAboutTheChange]) {
//        stackView.removeAllArrangedSubviews()
//        answerOptions = []
//        
//        for questionAboutTheChange in questionAboutTheChange {
//            let answerOption = AnswerOption(text: questionAboutTheChange.description)
//            
//            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
//            
//            stackView.addArrangedSubview(answerOption)
//            answerOptions.append(answerOption)
//        }
//    }
//}
//
//// MARK: - QuestionAboutTheChange+description
//
//fileprivate extension QuestionAboutTheChange {
//    var description: String {
//        switch self {
//        case .iHaveDifferentMindset:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeIHaveDifferentMindset()
//        case .iHadSomeBigChangesInMyLife:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeIHadSomeBigChangesInMyLife()
//        case .iWeightMoreThanIdidLastTime:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeIWeightMoreThanIdidLastTime()
//        case .iTryingDifferentWayOfEating:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeITryingDifferentWayOfEating()
//        case .iTryingNewExercisePlan:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeITryingNewExercisePlan()
//        case .iHadSomeHealthChanges:
//            return R.string.localizable.onboardingFirstQuestionAboutTheChangeIHadSomeHealthChanges()
//        }
//    }
//}
