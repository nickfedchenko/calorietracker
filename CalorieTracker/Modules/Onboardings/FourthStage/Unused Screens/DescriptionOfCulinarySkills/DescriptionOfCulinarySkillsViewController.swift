//
//  DescriptionOfCulinarySkillsViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//import UIKit
//
//protocol DescriptionOfCulinarySkillsViewControllerInterface: AnyObject {
//    func set(descriptionOfCulinarySkills: [DescriptionOfCulinarySkills])
//    func set(currentOnboardingStage: OnboardingStage)
//}
//
//final class DescriptionOfCulinarySkillsViewController: UIViewController {
//    
//    // MARK: - Public properties
//    
//    var presenter: DescriptionOfCulinarySkillsPresenterInterface?
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
//    private let imageView: UIImageView = .init()
//    private let titleLabel: UILabel = .init()
//    private let stackView: UIStackView = .init()
//    private var answerOptions: [AnswerOption] = []
//    private let continueCommonButton: CommonButton = .init(
//        style: .filled,
//        text: R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsButton().uppercased()
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
//        title = R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsTitle()
//
//        view.backgroundColor = R.color.mainBackground()
//        
//        imageView.image = R.image.onboardings.plate()
//        
//        let attributedString = NSMutableAttributedString()
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsTitleFirst(),
//            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
//        ))
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsTitleSecond(),
//            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
//        ))
//        
//        titleLabel.attributedText = attributedString
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
//        
//        stackView.axis = .vertical
//        stackView.spacing = 12
//        
//        continueCommonButton.isHidden = true
//        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
//    }
//    
//    private func configureLayouts() {
//        view.addSubview(scrolView)
//        
//        scrolView.addSubview(contentView)
//        
//        contentView.addSubview(stageCounterView)
//        
//        contentView.addSubview(imageView)
//        
//        contentView.addSubview(titleLabel)
//        
//        contentView.addSubview(stackView)
//        
//        contentView.addSubview(continueCommonButton)
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
//        imageView.snp.makeConstraints {
//            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
//            $0.centerX.equalTo(contentView.snp.centerX)
//            $0.size.equalTo(96)
//        }
//        
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(imageView.snp.bottom).offset(40)
//            $0.left.equalTo(contentView.snp.left).offset(43)
//            $0.right.equalTo(contentView.snp.right).offset(-43)
//        }
//        
//        stackView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
//            $0.left.equalTo(contentView.snp.left).offset(32)
//            $0.right.equalTo(contentView.snp.right).offset(-32)
//        }
//        
//        continueCommonButton.snp.makeConstraints {
//            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
//            $0.left.equalTo(contentView.snp.left).offset(40)
//            $0.right.equalTo(contentView.snp.right).offset(-40)
//            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
//            $0.height.equalTo(64)
//        }
//    }
//    
//    @objc func didTapAnswerOption(_ sender: AnswerOption) {
//        answerOptions.forEach { answerOption in
//            if answerOption == sender {
//                let isSelected = !answerOption.isSelected
//                
//                answerOption.isSelected = isSelected
//                
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
//        continueCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
//    }
//    
//    @objc func didTapContinueCommonButton(_ sender: AnswerOption) {
//        presenter?.didTapContinueCommonButton()
//    }
//    
//    private func didChangeIsHeaden() {
//        if isHedden {
//            continueCommonButton.isHidden = false
//        } else {
//            continueCommonButton.isHidden = true
//        }
//    }
//}
//
//// MARK: - DescriptionOfCulinarySkillsViewControllerInterface
//
//extension DescriptionOfCulinarySkillsViewController: DescriptionOfCulinarySkillsViewControllerInterface {
//    func set(currentOnboardingStage: OnboardingStage) {
//        stageCounterView.set(onboardingStage: currentOnboardingStage)
//    }
//    
//    func set(descriptionOfCulinarySkills: [DescriptionOfCulinarySkills]) {
//        stackView.removeAllArrangedSubviews()
//        answerOptions = []
//        
//        for descriptionOfCulinarySkills in descriptionOfCulinarySkills {
//            let answerOption = AnswerOption(text: descriptionOfCulinarySkills.description)
//            
//            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
//            
//            stackView.addArrangedSubview(answerOption)
//            answerOptions.append(answerOption)
//        }
//    }
//}
//
//// MARK: - DescriptionOfCulinarySkills + description
//
//fileprivate extension DescriptionOfCulinarySkills {
//    var description: String {
//        switch self {
//        case .imPrettyGoodCook:
//            return R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsImPrettyGoodCook()
//        case .iDoWellEnough:
//            return R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsIDoWellEnough()
//        case .imLearning:
//            return R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsImLearning()
//        case .imNotMuchOfCook:
//            return R.string.localizable.onboardingFourthDescriptionOfCulinarySkillsImNotMuchOfCook()
//        }
//    }
//}
