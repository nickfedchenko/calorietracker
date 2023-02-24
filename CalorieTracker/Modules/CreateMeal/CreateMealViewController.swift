//
//  CreateMealViewController.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 23.02.2023.
//

import UIKit

class CreateMealViewController: UIViewController {

    private lazy var contentView: UIView = getContentView()
    private lazy var scrollView: UIScrollView = getScrollView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var addPhotoButton: UIButton = getAddPhotoButton()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var descriptionLabel: UILabel = getDescriptionLabel()
    private lazy var descriptionForm: FormView = getDescriptionForm()
    private lazy var saveButton: CustomAddButton = getSaveButton()
    
    private let placeholderAttributes = [
        NSAttributedString.Key.foregroundColor: R.color.grayBasicGray(),
        .font: R.font.sfProTextMedium(size: 17)
    ].mapValues { $0 as Any }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupKeyboardManager()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.createMeal.background()
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
            addPhotoButton,
            titleHeaderLabel,
            descriptionLabel,
            descriptionForm,
            saveButton
        )
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.height.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(52)
            make.leading.equalTo(contentView).inset(25)
            make.width.height.equalTo(30)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(56)
            make.trailing.equalTo(contentView).inset(25)
            make.width.equalTo(30)
            make.height.equalTo(22)
        }
        
        titleHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(103)
            make.leading.trailing.equalTo(contentView).inset(28)
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
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-88)
        }
    }
    
    private func setupKeyboardManager() {
        addTapToHideKeyboardGesture()
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapAddPhotoButton() {
        
    }
    
    @objc private func didTapSaveButton() {
        
    }
}

// MARK: - Factory

extension CreateMealViewController: UIScrollViewDelegate {
    
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
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.createMeal.close(), for: .normal)
        button.imageView?.tintColor = R.color.createMeal.basicGray()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getAddPhotoButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.createMeal.photo(), for: .normal)
        button.imageView?.tintColor = R.color.createMeal.basicGray()
        button.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
        return button
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.addFoodMealCreation()
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
    
    private func getSaveButton() -> CustomAddButton {
        let button = CustomAddButton()
        button.buttonImage = R.image.basicButton.saveInactive()
        button.setTitle(R.string.localizable.save().uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.sfProRoundedBold(size: 18)
        button.setState(.inactive)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }
}

extension CreateMealViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == descriptionForm.textField else { return }
        descriptionForm.layer.borderWidth = 1
        descriptionForm.layer.borderColor = R.color.folderTitleText()?.cgColor
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text as NSString?
        let replacedText = currentText?.replacingCharacters(in: range, with: string)
        let resultText = replacedText ?? string
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let borderColor = R.color.createMeal.basicSecondaryDark()?.cgColor
        let borderWidth: CGFloat = textField.text == "" ? 2 : 1
        
        guard textField == descriptionForm.textField else { return }
        descriptionForm.layer.borderColor = borderColor
        descriptionForm.layer.borderWidth = borderWidth
    }
}
