//
//  DatePickerViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.12.2022.
//

import UIKit

final class DatePickerViewController: BottomSheetController {

    var date: ((Date) -> Void)?
    
    private lazy var datePickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.date = Date()
        view.preferredDatePickerStyle = .wheels
        view.datePickerMode = .date
        view.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(datePickerView)
        preferredSheetBackdropColor = .red
        
        datePickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    @objc private func handleDateSelection(_ sender: UIDatePicker) {
        date?(sender.date)
    }
}
