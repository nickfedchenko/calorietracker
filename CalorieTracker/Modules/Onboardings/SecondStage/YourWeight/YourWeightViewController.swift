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
    
    // MARK: - Private properties
    
    private var weight: Double = 0.0
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let borderTextField: BorderTextField = .init()
    private let containerPickerView: UIView = .init()
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingSecondYourWeightButton()
    )
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
        
        scrolView.showsVerticalScrollIndicator = false
        
        titleLabel.text = R.string.localizable.onboardingSecondYourWeightTitleFirst()
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        borderTextField.text = R.string.localizable.onboardingSecondYourWeightTitleWeight()
        borderTextField.isEnabled = false
        borderTextField.textField.addTarget(
            self,
            action: #selector(didTapContinueCommonButton),
            for: .touchUpInside
        )
        borderTextField.text = "70.0 \(R.string.localizable.measurementKg())"
        
        containerPickerView.backgroundColor = .white
        containerPickerView.layer.cornerRadius = 12
        containerPickerView.layer.masksToBounds = false
        containerPickerView.layer.shadowColor = UIColor.black.cgColor
        containerPickerView.layer.shadowOpacity = 0.20
        containerPickerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        containerPickerView.layer.shadowRadius = 8
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(70, inComponent: 0, animated: false)

        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
        let isTextFieldEmpty = sender.text?.isEmpty ?? false
        
        continueCommonButton.isEnabled = !isTextFieldEmpty
    }
    
    @objc private func didChangedDatePicker(_ sender: UIDatePicker) {
        borderTextField.text = pickerView(pickerView, titleForRow: 1, forComponent: 1)
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton(with: weight)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(borderTextField)
        
        contentView.addSubview(containerPickerView)
        
        containerPickerView.addSubview(pickerView)
        
        containerPickerView.addSubview(continueCommonButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrolView.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(scrolView.snp.bottom)
            $0.height.greaterThanOrEqualTo(scrolView.snp.height)
        }
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        borderTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(50)
            $0.right.equalTo(contentView.snp.right).offset(-50)
            $0.height.equalTo(74)
        }
        
        containerPickerView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(borderTextField.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(containerPickerView.snp.top).offset(26)
            $0.left.equalTo(contentView.snp.left).offset(32)
            $0.right.equalTo(contentView.snp.right).offset(-32)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(24)
            $0.left.equalTo(containerPickerView.snp.left).offset(40)
            $0.right.equalTo(containerPickerView.snp.right).offset(-40)
            $0.bottom.equalTo(containerPickerView.snp.bottom).offset(-35)
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let kilograms = pickerView.selectedRow(inComponent: 0)
        let grams = pickerView.selectedRow(inComponent: 2)
        
        weight = Double(kilograms) + Double(grams) / 10
        
        borderTextField.text = "\(kilograms).\(grams) \(R.string.localizable.measurementKg())"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else if component == 1 {
            return "."
        } else if component == 2 {
            return "\(row)"
        } else if component == 3 {
            return BAMeasurement.measurmentSuffix(.weight)
        }
        return nil
    }
}
