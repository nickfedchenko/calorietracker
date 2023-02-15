//
//  CustomEntryViewController.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 13.02.2023.
//

import UIKit

final class CustomEntryViewController: UIViewController, UIScrollViewDelegate {
    
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
    private lazy var contentView: UIView = getContentView()
    private lazy var scrollView: UIScrollView = getScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupKeyboardManager()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.addFood.menu.background()
    }
    
    private func addSubviews() {
        view.addSubviews(
            scrollView
        )
        
        scrollView.addSubview(
            contentView
        )
    
        contentView.addSubviews(
            closeButton,
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
            addEntryButton
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        titleHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(descriptionForm.snp.top).offset(-36)
        }
        
        descriptionForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(caloriesForm.snp.top).offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.bottom.equalTo(descriptionForm.snp.top).offset(-4)
        }
        
        caloriesForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(contentView).inset(108)
            make.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(carbsForm.snp.top).offset(-12)
        }
        
        caloriesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(caloriesForm)
            make.trailing.equalTo(caloriesForm.snp.leading).offset(-8)
        }

        carbsForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(contentView).inset(108)
            make.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(proteinForm.snp.top).offset(-12)
        }
        
        carbsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(carbsForm)
            make.trailing.equalTo(carbsForm.snp.leading).offset(-8)
        }
        
        proteinForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(contentView).inset(108)
            make.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(fatForm.snp.top).offset(-12)
        }
        
        proteinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(proteinForm)
            make.trailing.equalTo(proteinForm.snp.leading).offset(-8)
        }
        
        fatForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalTo(contentView).inset(108)
            make.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(addEntryButton.snp.top).offset(-24)
        }
        
        fatLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fatForm)
            make.trailing.equalTo(fatForm.snp.leading).offset(-8)
        }
        
        addEntryButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-226)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-24)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.height.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupKeyboardManager() {
        addTapToHideKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillBeShown(notification: NSNotification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrameValue = notification.userInfo?[key] as? NSValue else { return }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        
        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        let heightDiferenceOfView = view.frame.size.height - keyboardFrame.size.height
        let heightDiferenceOfButton = addEntryButton.frame.origin.y - heightDiferenceOfView
        let offsetPoint = heightDiferenceOfButton + addEntryButton.frame.height + 16
        scrollView.contentOffset = CGPoint(x: 0, y: offsetPoint)
    }
    
    @objc private func keyboardWillBeHidden() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        self.dismiss(animated: true)
    }
    
    @objc private func didTapCustomEntryButton() {
        Vibration.rigid.vibrate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        form.textField.becomeFirstResponder()
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
        form.textField.keyboardType = .decimalPad
        form.textField.delegate = self
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
        form.textField.keyboardType = .decimalPad
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
        form.textField.keyboardType = .decimalPad
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
        form.textField.keyboardType = .decimalPad
        return form
    }
    
    private func getAddEntryButton() -> BasicButtonView {
        let button = BasicButtonView(
            type: .custom(
                .init(
                    image: .init(isPressImage: R.image.basicButton.addPressed(),
                                 defaultImage: R.image.basicButton.addDefault(),
                                 inactiveImage: R.image.basicButton.addInactive()),
                    title: nil,
                    backgroundColorInactive: R.color.basicButton.inactiveColor(),
                    backgroundColorDefault: R.color.basicButton.gradientFirstColor(),
                    backgroundColorPress: R.color.basicButton.gradientFirstColor(),
                    gradientColors: nil,
                    borderColorInactive: R.color.basicButton.inactiveColor(),
                    borderColorDefault: R.color.foodViewing.basicSecondaryDark(),
                    borderColorPress: R.color.foodViewing.basicSecondary()
                )
            )
        )
        
        button.addTarget(self, action: #selector(didTapCustomEntryButton), for: .touchUpInside)
        button.active = false
        return button
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getContentView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }
}

extension CustomEntryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text as NSString?
        let replacedText = currentText?.replacingCharacters(in: range, with: string)
        let resultText = replacedText ?? string
        addEntryButton.active = resultText.isEmpty ? false : true
        
        return true
    }
}
