//
//  DescriptionOfExperienceViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//
//
//import Foundation
//import UIKit
//
//protocol DescriptionOfExperienceViewControllerInterface: AnyObject {
//    func set(descriptionOfExperiences: [DescriptionOfExperience])
//    func set(currentOnboardingStage: OnboardingStage)
//}
//
//final class DescriptionOfExperienceViewController: UIViewController {
//    
//    // MARK: - Public properties
//    
//    var presenter: DescriptionOfExperiencePresenterInterface?
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
//    private let stackView: UIStackView = .init()
//    private var answerOptions: [AnswerOption] = []
//    private let nextCommonButton: CommonButton = .init(
//        style: .filled,
//        text: R.string.localizable.onboardingFirstDescriptionOfExperienceButton().uppercased()
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
//        title = R.string.localizable.onboardingFirstDescriptionOfExperienceTitle()
//        
//        view.backgroundColor = R.color.mainBackground()
//        
//        scrolView.showsVerticalScrollIndicator = false
//
//        let attributedString = NSMutableAttributedString()
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFirstDescriptionOfExperienceTitleFirst(),
//            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
//        ))
//        
//        attributedString.append(.init(string: " "))
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFirstDescriptionOfExperienceTitleSecond(),
//            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
//        ))
//        
//        titleLabel.attributedText = attributedString
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
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
//        stackView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
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
//                    presenter?.didSelectDescriptionOfExperience(with: index)
//                } else {
//                    presenter?.didDeselectDescriptionOfExperience()
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
//// MARK: - DescriptionOfExperienceViewControllerInterface
//
//extension DescriptionOfExperienceViewController: DescriptionOfExperienceViewControllerInterface {
//    func set(currentOnboardingStage: OnboardingStage) {
//        stageCounterView.set(onboardingStage: currentOnboardingStage)
//    }
//    
//    func set(descriptionOfExperiences: [DescriptionOfExperience]) {
//        stackView.removeAllArrangedSubviews()
//        answerOptions = []
//        
//        for descriptionOfExperience in descriptionOfExperiences {
//            let answerOption = AnswerOption(text: descriptionOfExperience.description)
//            
//            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
//            
//            stackView.addArrangedSubview(answerOption)
//            answerOptions.append(answerOption)
//        }
//    }
//}
//
//// MARK: - DescriptionOfExperience+description
//
//fileprivate extension DescriptionOfExperience {
//    var description: String {
//        switch self {
//        case .iHaveNeverLostMuchWeightBefore:
//            return R.string.localizable.onboardingFirstDescriptionOfExperienceIHaveNeverLostMuchWeightBefore()
//        case .iLostWeightAndGainedItAllBack:
//            return R.string.localizable.onboardingFirstDescriptionOfExperienceILostWeightAndGainedItAllBack()
//        case .iLostWeightAndGainedSomeBack:
//            return R.string.localizable.onboardingFirstDescriptionOfExperienceILostWeightAndGainedSomeBack()
//        case .iLostWeightAndHaveMoreLose:
//            return R.string.localizable.onboardingFirstDescriptionOfExperienceILostWeightAndHaveMoreLose()
//        case .iLostWeightAndAmMaintainingIt:
//            return R.string.localizable.onboardingFirstDescriptionOfExperienceILostWeightAndAmMaintainingIt()
//        }
//    }
//}
