//
//  ObsessingOverFoodViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol ObsessingOverFoodViewControllerInterface: AnyObject {}

final class ObsessingOverFoodViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: ObsessingOverFoodPresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let definitelyAnswerOption: AnswerOption = .init(text: "Yes, definitely")
    private let sometimesAnswerOption: AnswerOption = .init(text: "Sure, sometimes")
    private let notReallyAnswerOption: AnswerOption = .init(text: "No, not really")
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "History"
        
        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "Have you ever found yourself ", attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "obsessing over food?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        definitelyAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        sometimesAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        notReallyAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)

        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(definitelyAnswerOption)
        stackView.addArrangedSubview(sometimesAnswerOption)
        stackView.addArrangedSubview(notReallyAnswerOption)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        presenter?.didTapAnswerOption()
        sender.isSelected = !sender.isSelected
    }
}

extension ObsessingOverFoodViewController: ObsessingOverFoodViewControllerInterface {}
