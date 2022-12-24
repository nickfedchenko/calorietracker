//
//  DateOfBirthViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation
import UIKit

protocol DateOfBirthViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class DateOfBirthViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: DateOfBirthPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let borderTextField: BorderTextField = .init()
    private let containerdatePickerView: UIView = .init()
    private let datePicker: UIDatePicker = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue")
    
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
        
        titleLabel.text = "Your date of birth"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        borderTextField.isEnabled = false
        borderTextField.textField.addTarget(
            self,
            action: #selector(didTapContinueCommonButton),
            for: .touchUpInside
        )
        
        containerdatePickerView.backgroundColor = .white
        containerdatePickerView.layer.cornerRadius = 12
        containerdatePickerView.layer.masksToBounds = false
        containerdatePickerView.layer.shadowColor = UIColor.black.cgColor
        containerdatePickerView.layer.shadowOpacity = 0.10
        containerdatePickerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        containerdatePickerView.layer.shadowRadius = 8
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
        let isTextFieldEmpty = sender.text?.isEmpty ?? false
        
        continueCommonButton.isEnabled = !isTextFieldEmpty
    }
    
    @objc private func didChangedDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yyyy"
        
        borderTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func didTapContinueCommonButton() {
        guard let name = borderTextField.text, !name.isEmpty else { return }
        presenter?.didTapContinueCommonButton(with: datePicker.date)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(borderTextField)
        
        contentView.addSubview(containerdatePickerView)
        
        containerdatePickerView.addSubview(datePicker)
        
        containerdatePickerView.addSubview(continueCommonButton)
        
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
        
        containerdatePickerView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(borderTextField.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(containerdatePickerView.snp.top).offset(26)
            $0.left.equalTo(contentView.snp.left).offset(32)
            $0.right.equalTo(contentView.snp.right).offset(-32)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(24)
            $0.left.equalTo(containerdatePickerView.snp.left).offset(40)
            $0.right.equalTo(containerdatePickerView.snp.right).offset(-40)
            $0.bottom.equalTo(containerdatePickerView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
}

// MARK: - DateOfBirthViewControllerInterface

extension DateOfBirthViewController: DateOfBirthViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
