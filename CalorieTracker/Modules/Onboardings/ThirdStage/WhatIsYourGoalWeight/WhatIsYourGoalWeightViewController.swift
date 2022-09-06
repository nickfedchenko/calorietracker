//
//  WhatIsYourGoalWeightViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation
import UIKit

protocol WhatIsYourGoalWeightViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class WhatIsYourGoalWeightViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: WhatIsYourGoalWeightPresenterInterface?
    
    // MARK: - Private properties
    
    private var weightDesired: Double = 0.0
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let borderTextField: BorderTextField = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue")
    private let pickerView: UIPickerView = .init()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "Motivation/Goal"

        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "What is ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        attributedString.append(NSAttributedString(
            string: "your goal \nweight?",
            attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        borderTextField.text = "0.0 kg"
        borderTextField.isEnabled = false
        borderTextField.textField.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
        
        pickerView.dataSource = self
        pickerView.delegate = self

        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
        let isTextFieldEmpty = sender.text?.isEmpty ?? false
        
        continueCommonButton.isEnabled = !isTextFieldEmpty
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton(with: weightDesired)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(borderTextField)
        
        view.addSubview(pickerView)
        
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
        
        borderTextField.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(50)
            $0.right.equalTo(view.snp.right).offset(-50)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.height.equalTo(74)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(borderTextField.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(50)
            $0.right.equalTo(view.snp.right).offset(-50)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
}

// MARK: - WhatIsYourGoalWeightViewControllerInterface

extension WhatIsYourGoalWeightViewController: WhatIsYourGoalWeightViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}

// MARK: - UIPickerViewDataSource

extension WhatIsYourGoalWeightViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 301
        } else if component == 1 {
            return 1
        } else if component == 2 {
            return 10
        } else {
            return 1
        }
    }
}

// MARK: - UIPickerViewDelegate

extension WhatIsYourGoalWeightViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let kilograms = pickerView.selectedRow(inComponent: 0)
        let grams = pickerView.selectedRow(inComponent: 2)
        
        weightDesired = Double(kilograms) + Double(grams) / 10
        
        borderTextField.text = "\(kilograms).\(grams) kg"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else if component == 1 {
            return "."
        } else if component == 2 {
            return "\(row)"
        } else if component == 3 {
            return "кг"
        }
        return nil
    }
}
