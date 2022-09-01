//
//  EnterYourNameViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import Foundation
import UIKit

protocol EnterYourNameViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class EnterYourNameViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: EnterYourNamePresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let textField: UITextField = .init()
    private let delimeterView: UIView = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue")
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "Enter your name"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        textField.backgroundColor = .clear
        textField.tintColor = R.color.onboardings.basicDark()
        textField.font = .systemFont(ofSize: 34, weight: .medium)
        textField.textColor = R.color.onboardings.basicDark()
        textField.textAlignment = .center
        textField.layer.masksToBounds = false
        textField.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        
        delimeterView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        continueCommonButton.isEnabled = false
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
        let isTextFieldEmpty = sender.text?.isEmpty ?? false
        
        continueCommonButton.isEnabled = !isTextFieldEmpty
    }
    
    @objc private func didTapContinueCommonButton() {
        guard let name = textField.text, !name.isEmpty else { return }
        
        presenter?.didTapContinueCommonButton(with: name)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(textField)
        
        view.addSubview(delimeterView)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
        }
        
        delimeterView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(8)
            $0.left.equalTo(textField.snp.left)
            $0.right.equalTo(textField.snp.right)
            $0.height.equalTo(2)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.equalTo(delimeterView.snp.bottom).offset(30)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
    }
}

// MARK: - EnterYourNameViewControllerInterface

extension EnterYourNameViewController: EnterYourNameViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
