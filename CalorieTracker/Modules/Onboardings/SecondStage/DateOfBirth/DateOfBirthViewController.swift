//
//  DateOfBirthViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation
import UIKit

protocol DateOfBirthViewControllerInterface: AnyObject {}

final class DateOfBirthViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: DateOfBirthPresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let borderTextField: BorderTextField = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue")
    private let datePicker: UIDatePicker = .init()

    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "Your date of birth"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        borderTextField.isEnabled = false

        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    @objc private func didChangedDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yyyy"
        
        borderTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(borderTextField)
        
        view.addSubview(datePicker)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
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
        
        datePicker.snp.makeConstraints {
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

// MARK: - DateOfBirthViewControllerInterface

extension DateOfBirthViewController: DateOfBirthViewControllerInterface {}
