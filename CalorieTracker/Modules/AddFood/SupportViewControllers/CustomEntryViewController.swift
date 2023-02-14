//
//  CustomEntryViewController.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 13.02.2023.
//

import UIKit

class CustomEntryViewController: UIViewController {
    
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var descriptionLabel: UILabel = getDescriptionLabel()
    private lazy var descriptionForm: FormView = getDescriptionForm()
    private lazy var caloriesLabel: UILabel = getCaloriesLabel()
    private lazy var caloriesForm: FormView = getCaloriesForm()
    private lazy var carbsLabel: UILabel = getCarbsLabel()
    private lazy var carbsForm: FormView = getCarbsForm()
    private lazy var proteinLabel: UILabel = getProteinLabel()
    private lazy var proteinForm: FormView = getProteinForm()
    private lazy var fatLabel: UILabel = getFatLabel()
    private lazy var fatForm: FormView = getFatForm()
    private lazy var addEntryButton: BasicButtonView = getAddEntryButton()
    private lazy var closeButton: UIButton = getCloseButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.addFood.menu.background()
    }
    
    private func addSubviews() {
        view.addSubviews(
            titleHeaderLabel,
            descriptionLabel,
            descriptionForm,
            caloriesForm,
            caloriesLabel,
            carbsForm,
            carbsLabel,
            proteinForm,
            proteinLabel,
            fatLabel,
            fatForm,
            addEntryButton,
            closeButton
        )
    }
    
    private func setupConstraints() {
        titleHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(226)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(titleHeaderLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(descriptionForm.snp.top).offset(-4)
        }
        
        caloriesForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(descriptionForm.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(108)
            make.trailing.equalToSuperview().inset(20)
        }
        
        caloriesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(caloriesForm)
            make.trailing.equalTo(caloriesForm.snp.leading).offset(-8)
        }

        carbsForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(caloriesForm.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(108)
            make.trailing.equalToSuperview().inset(20)
        }
        
        carbsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(carbsForm)
            make.trailing.equalTo(carbsForm.snp.leading).offset(-8)
        }
        
        proteinForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(carbsForm.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(108)
            make.trailing.equalToSuperview().inset(20)
        }
        
        proteinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(proteinForm)
            make.trailing.equalTo(proteinForm.snp.leading).offset(-8)
        }
        
        fatForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(proteinForm.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(108)
            make.trailing.equalToSuperview().inset(20)
        }
        
        fatLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fatForm)
            make.trailing.equalTo(fatForm.snp.leading).offset(-8)
        }
        
        addEntryButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalTo(fatForm.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        self.dismiss(animated: true)
    }
    
    @objc private func didTapCustomEntryButton() {
        Vibration.rigid.vibrate()
    }
}

// MARK: - Factory

extension CustomEntryViewController {
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "CUSTOM ENTRY"
        label.font = R.font.sfProDisplaySemibold(size: 24.fontScale())
        label.textColor = R.color.foodViewing.basicPrimary()
        return label
    }
    
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17)
        label.textColor = R.color.addFood.menu.isNotSelectedText()
        label.text = "Description"
        return label
    }
    
    private func getDescriptionForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .required("Required"))
        return form
    }
    
    private func getCaloriesLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17)
        label.textColor = R.color.addFood.menu.kcal()
        label.text = "Calories"
        return label
    }
    
    private func getCaloriesForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .required("Required"))
        return form
    }
    
    private func getCarbsLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17)
        label.textColor = R.color.addFood.menu.carb()
        label.text = "Carbs"
        return label
    }
    
    private func getCarbsForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        return form
    }
    
    private func getProteinLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17)
        label.textColor = R.color.addFood.menu.protein()
        label.text = "Protein"
        return label
    }
    
    private func getProteinForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        return form
    }
    
    private func getFatLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17)
        label.textColor = R.color.addFood.menu.fat()
        label.text = "Fat"
        return label
    }
    
    private func getFatForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        return form
    }
    
    private func getAddEntryButton() -> BasicButtonView {
        let button = BasicButtonView(type: .add)
        button.addTarget(self, action: #selector(didTapCustomEntryButton), for: .touchUpInside)
        return button
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
}
