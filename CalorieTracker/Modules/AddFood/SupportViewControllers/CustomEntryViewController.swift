//
//  CustomEntryViewController.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 13.02.2023.
//

import UIKit

final class CustomEntryViewController: UIViewController {
    
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
    private lazy var addEntryButton: CustomAddButton = getAddEntryButton()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var contentView: UIView = getContentView()
    private lazy var scrollView: UIScrollView = getScrollView()
    
    private let placeholderAttributes = [
        NSAttributedString.Key.foregroundColor: R.color.grayBasicGray(),
        .font: R.font.sfProTextMedium(size: 17)
    ].mapValues { $0 as Any }
    
    var onSavedCustomEntry: ((CustomEntry) -> Void)?
    
    let mealTime: MealTime
    
    init(mealTime: MealTime) {
        self.mealTime = mealTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            make.top.equalTo(contentView).inset(145)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        descriptionForm.snp.makeConstraints { make in
            make.top.equalTo(titleHeaderLabel.snp.bottom).inset(-36)
            make.height.equalTo(48)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(28)
            make.bottom.equalTo(descriptionForm.snp.top).offset(-4)
        }
        
        caloriesForm.snp.makeConstraints { make in
            make.top.equalTo(descriptionForm.snp.bottom).inset(-12)
            make.height.equalTo(48)
            make.width.equalTo(descriptionForm.snp.width).dividedBy(2)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        caloriesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(caloriesForm)
            make.trailing.equalTo(caloriesForm.snp.leading).offset(-8)
        }
        
        carbsForm.snp.makeConstraints { make in
            make.top.equalTo(caloriesForm.snp.bottom).inset(-12)
            make.height.equalTo(48)
            make.width.equalTo(descriptionForm.snp.width).dividedBy(2)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        carbsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(carbsForm)
            make.trailing.equalTo(carbsForm.snp.leading).offset(-8)
        }
        
        proteinForm.snp.makeConstraints { make in
            make.top.equalTo(carbsForm.snp.bottom).inset(-12)
            make.height.equalTo(48)
            make.width.equalTo(descriptionForm.snp.width).dividedBy(2)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        proteinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(proteinForm)
            make.trailing.equalTo(proteinForm.snp.leading).offset(-8)
        }
        
        fatForm.snp.makeConstraints { make in
            make.top.equalTo(proteinForm.snp.bottom).inset(-12)
            make.height.equalTo(48)
            make.width.equalTo(descriptionForm.snp.width).dividedBy(2)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        fatLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fatForm)
            make.trailing.equalTo(fatForm.snp.leading).offset(-8)
        }
        
        addEntryButton.snp.makeConstraints { make in
            make.top.equalTo(fatForm.snp.bottom).inset(-24)
            make.height.equalTo(64)
            make.leading.trailing.equalTo(contentView).inset(20)
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
        
        let heightDiferenceOfView = view.frame.size.height - keyboardFrame.size.height
        let heightDiferenceOfButton = addEntryButton.frame.origin.y - heightDiferenceOfView
        let offsetPoint = heightDiferenceOfButton + addEntryButton.frame.height + 16
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
            self.scrollView.contentInset.bottom = keyboardFrame.height
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            self.scrollView.contentOffset = CGPoint(x: 0, y: offsetPoint)
        }
    }
    
    @objc private func keyboardWillBeHidden() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        self.dismiss(animated: true)
    }
    
    @objc private func didTapCustomEntryButton() {
        Vibration.rigid.vibrate()
        
        guard let title = descriptionForm.textField.text,
              let kcal = Double(caloriesForm.textField.text ?? "")
        else { return }
        
        let carbs = Double(carbsForm.textField.text ?? "")
        let proteins = Double(proteinForm.textField.text ?? "")
        let fats = Double(fatForm.textField.text ?? "")
        
        self.dismiss(animated: true) {
            
            let customEntry = CustomEntry(
                title: title,
                nutrients: .init(
                    kcal: kcal,
                    carbs: carbs ?? 0.0,
                    proteins: proteins ?? 0.0,
                    fats: fats ?? 0.0
                ),
                mealTime: self.mealTime
            )
            
            self.onSavedCustomEntry?(customEntry)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Factory

extension CustomEntryViewController: UIScrollViewDelegate {
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.addFoodCustomEntry().uppercased()
        label.font = R.font.sfProRoundedBold(size: 24)
        label.textColor = R.color.folderTitleText()
        return label
    }
    
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.grayBasicGray()
        label.text = R.string.localizable.description()
        return label
    }
    
    private func getDescriptionForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .required(nil))
        form.textField.font = R.font.sfProTextMedium(size: 17)
        form.textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.textFieldRequired(),
            attributes: placeholderAttributes
        )
        
        form.textField.autocorrectionType = .no
        form.textField.spellCheckingType = .no
        form.textField.delegate = self
        form.textField.becomeFirstResponder()
        return form
    }
    
    private func getCaloriesLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.addFood.menu.kcal()
        label.text = R.string.localizable.calories()
        return label
    }
    
    private func getCaloriesForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .required(nil))
        form.textField.font = R.font.sfProTextMedium(size: 17)
        form.textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.textFieldRequired(),
            attributes: placeholderAttributes
        )
        
        form.textField.keyboardType = .decimalPad
        form.textField.delegate = self
        return form
    }
    
    private func getCarbsLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.addFood.menu.carb()
        label.text = R.string.localizable.carbsShort()
        return label
    }
    
    private func getCarbsForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        form.textField.font = R.font.sfProTextMedium(size: 17)
        form.textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.textFieldOptional(),
            attributes: placeholderAttributes
        )
        
        form.textField.keyboardType = .decimalPad
        return form
    }
    
    private func getProteinLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.addFood.menu.protein()
        label.text = R.string.localizable.proteins()
        return label
    }
    
    private func getProteinForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        form.textField.font = R.font.sfProTextMedium(size: 17)
        form.textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.textFieldOptional(),
            attributes: placeholderAttributes
        )
        
        form.textField.keyboardType = .decimalPad
        return form
    }
    
    private func getFatLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.addFood.menu.fat()
        label.text = R.string.localizable.fatShort()
        return label
    }
    
    private func getFatForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        form.textField.font = R.font.sfProTextMedium(size: 17)
        form.textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.textFieldOptional(),
            attributes: placeholderAttributes
        )
        
        form.textField.keyboardType = .decimalPad
        return form
    }
    
    private func getAddEntryButton() -> CustomAddButton {
        let button = CustomAddButton()
        button.setState(.inactive)
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
    
    private func getContentView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.delegate = self
        return scrollView
    }
}

extension CustomEntryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        [caloriesForm, descriptionForm].forEach {
            guard textField == $0.textField else { return }
            $0.layer.borderWidth = 1
            $0.layer.borderColor = R.color.folderTitleText()?.cgColor
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text as NSString?
        let replacedText = currentText?.replacingCharacters(in: range, with: string)
        let resultText = replacedText ?? string
        
        if (textField == caloriesForm.textField && descriptionForm.textField.text != "")
            || (textField == descriptionForm.textField && caloriesForm.textField.text != "") {
            addEntryButton.setState(resultText.isEmpty ? .inactive : .active)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        let borderWidth: CGFloat = textField.text == "" ? 2 : 1
        
        [caloriesForm, descriptionForm].forEach {
            guard textField == $0.textField else { return }
            $0.layer.borderColor = borderColor
            $0.layer.borderWidth = borderWidth
        }
    }
}
