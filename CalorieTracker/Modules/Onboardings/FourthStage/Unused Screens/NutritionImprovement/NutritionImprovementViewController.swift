//
//  NutritionImprovementViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

//import Foundation
//import UIKit
//
//protocol NutritionImprovementViewControllerInterface: AnyObject {
//    func set(currentOnboardingStage: OnboardingStage)
//}
//
//final class NutritionImprovementViewController: UIViewController {
//    
//    // MARK: - Public properties
//    
//    var presenter: NutritionImprovementPresenterInterface?
//    
//    // MARK: - Views properties
//
//    private let scrolView: UIScrollView = .init()
//    private let contentView: UIView = .init()
//    private let stageCounterView: StageCounterView = .init()
//    private let stackView: UIStackView = .init()
//    private let imageView: UIImageView = .init()
//    private let titleLabel: UILabel = .init()
//    private let approvalCommonButton: CommonButton = .init(
//        style: .bordered,
//        text: R.string.localizable.onboardingFourthNutritionImprovementButtonYes().uppercased()
//    )
//    private let rejectionCommonButton: CommonButton = .init(
//        style: .bordered,
//        text: R.string.localizable.onboardingFourthNutritionImprovementButtonNo().uppercased()
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
//        title = R.string.localizable.onboardingFourthNutritionImprovementTitle()
//        
//        view.backgroundColor = R.color.mainBackground()
//        
//        scrolView.showsVerticalScrollIndicator = false
//        
//        stackView.spacing = 24
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        
//        imageView.image = UIImage(named: R.image.onboardings.burger.name)
//        
//        let attributedString = NSMutableAttributedString()
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFourthNutritionImprovementTitleFirst(),
//            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
//        ))
//        
//        attributedString.append(NSAttributedString(
//            string: R.string.localizable.onboardingFourthNutritionImprovementTitleSecond(),
//            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
//        ))
//        
//        titleLabel.attributedText = attributedString
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
//        
//        approvalCommonButton.addTarget(self, action: #selector(didTapApprovalCommonButton),
//                                       for: .touchUpInside)
//        
//        rejectionCommonButton.addTarget(self, action: #selector(didTapRejectionCommonButton),
//                                        for: .touchUpInside)
//    }
//    
//    private func configureLayouts() {
//        view.addSubview(scrolView)
//        
//        scrolView.addSubview(contentView)
//        
//        contentView.addSubview(stageCounterView)
//        
//        contentView.addSubview(stackView)
//        
//        stackView.addArrangedSubview(imageView)
//        stackView.addArrangedSubview(titleLabel)
//        
//        contentView.addSubview(approvalCommonButton)
//        
//        contentView.addSubview(rejectionCommonButton)
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
//        stackView.snp.makeConstraints {
//            $0.left.equalTo(contentView.snp.left).offset(43)
//            $0.right.equalTo(contentView.snp.right).offset(-43)
//            $0.centerY.equalTo(contentView.snp.centerY)
//            $0.centerX.equalTo(contentView.snp.centerX)
//        }
//        
//        imageView.snp.makeConstraints {
//            $0.size.equalTo(96)
//        }
//        
//        approvalCommonButton.snp.makeConstraints {
//            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
//            $0.left.equalTo(contentView.snp.left).offset(40)
//            $0.right.equalTo(contentView.snp.right).offset(-40)
//            $0.height.equalTo(64)
//        }
//        
//        rejectionCommonButton.snp.makeConstraints {
//            $0.top.equalTo(approvalCommonButton.snp.bottom).offset(16)
//            $0.left.equalTo(contentView.snp.left).offset(40)
//            $0.right.equalTo(contentView.snp.right).offset(-40)
//            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
//            $0.height.equalTo(64)
//        }
//    }
//    
//    @objc private func didTapApprovalCommonButton() {
//        presenter?.didTapApprovalCommonButton()
//    }
//    
//    @objc private func didTapRejectionCommonButton() {
//        presenter?.didTapRejectionCommonButton()
//    }
//}
//
//// MARK: - NutritionImprovementViewControllerInterface
//
//extension NutritionImprovementViewController: NutritionImprovementViewControllerInterface {
//    func set(currentOnboardingStage: OnboardingStage) {
//        stageCounterView.set(onboardingStage: currentOnboardingStage)
//    }
//}
