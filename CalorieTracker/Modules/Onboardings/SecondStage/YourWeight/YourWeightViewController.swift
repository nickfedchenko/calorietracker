//
//  YourWeightViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation
import UIKit

protocol YourWeightViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class YourWeightViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: YourWeightPresenterInterface?
    
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
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "Your weight"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        borderTextField.isEnabled = false
        borderTextField.textField.addTarget(self, action:  #selector(didTapContinueCommonButton), for: .touchUpInside)
        
        pickerView.dataSource = self
        pickerView.delegate = self

        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
//        let isTextFieldEmpty = sender.text?.isEmpty ?? false
//        
//        continueCommonButton.isEnabled = !isTextFieldEmpty
    }
    
    @objc private func didChangedDatePicker(_ sender: UIDatePicker) {
        borderTextField.text = pickerView(pickerView, titleForRow: 1, forComponent: 1)
    }
    
    @objc private func didTapContinueCommonButton() {
//        guard let name = borderTextField.text, !name.isEmpty else { return }
        
        presenter?.didTapContinueCommonButton()
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(50)
            $0.right.equalTo(view.snp.right).offset(-50)
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

// MARK: - YourWeightViewControllerInterface

extension YourWeightViewController: YourWeightViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}

// MARK: - UIPickerViewDataSource

extension YourWeightViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 200
        } else if component == 1 {
            return 1
        } else if component == 2 {
            return 1000
        } else {
            return 1
        }
    }
}

// MARK: - UIPickerViewDelegate

extension YourWeightViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + 1)"
        } else if component == 1 {
            return "."
        } else if component == 2 {
            return "\(row * 1)"
        } else if component == 3 {
            return "кг"
        }
        return nil
    }
}
