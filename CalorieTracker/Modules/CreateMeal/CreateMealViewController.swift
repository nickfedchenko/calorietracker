//
//  CreateMealViewController.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Photos
import UIKit

protocol CreateMealViewControllerInterface: AnyObject {

}

class CreateMealViewController: UIViewController {
    
    var presenter: CreateMealPresenterInterface?
    
    private lazy var contentView: UIView = getContentView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var scrollView: UIScrollView = getScrollView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var addPhotoButton: UIButton = getAddPhotoButton()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var descriptionLabel: UILabel = getDescriptionLabel()
    private lazy var descriptionForm: FormView = getDescriptionForm()
    private lazy var saveButton: CustomAddButton = getSaveButton()
    private lazy var addFoodButton: CustomAddButton = getAddFoodButton()
    private lazy var containerPhotoView: UIView = getContainerPhotoView()
    private lazy var mealPhoto: UIImageView = getMealPhoto()
    private lazy var firstContainerCollectionView: UIView = getFirstContainerCollectionView()
    private lazy var secondContainerCollectionView: UIView = getSecondContainerCollectionView()
    private lazy var collectionView: UICollectionView = getCollectionView()

    private let placeholderAttributes = [
        NSAttributedString.Key.foregroundColor: R.color.grayBasicGray(),
        .font: R.font.sfProTextMedium(size: 17)
    ].mapValues { $0 as Any }
    
    private lazy var collectionViewHeightConstraint = firstContainerCollectionView
        .heightAnchor.constraint(
            equalToConstant: containerViewHeight
        )
    
    private let cellHeight: CGFloat = 57
    private let cellCount: Int = 15
    private lazy var collectionViewHeight: CGFloat = CGFloat(cellCount) * cellHeight
    private lazy var containerViewHeight: CGFloat = collectionViewHeight + 20

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupKeyboardManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViewHeight()
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
            headerView,
            closeButton,
            addPhotoButton,
            containerPhotoView,
            mealPhoto,
            titleHeaderLabel,
            descriptionLabel,
            descriptionForm,
            firstContainerCollectionView,
            secondContainerCollectionView,
            collectionView,
            saveButton,
            addFoodButton
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.height.equalTo(scrollView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(163)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(headerView).offset(-81)
            make.leading.equalTo(headerView).inset(25)
            make.width.height.equalTo(30)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.bottom.equalTo(headerView).offset(-85)
            make.trailing.equalTo(headerView).inset(25)
            make.width.equalTo(30)
            make.height.equalTo(22)
        }
        
        containerPhotoView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(60)
            make.bottom.equalTo(headerView).offset(-76)
            make.trailing.equalTo(headerView).inset(20)
            
        }
        
        mealPhoto.snp.makeConstraints { make in
            make.edges.equalTo(containerPhotoView)
        }
    
        titleHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(headerView).offset(-36)
            make.leading.trailing.equalTo(headerView).inset(28)
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
        
        firstContainerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionForm.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.lessThanOrEqualTo(addFoodButton.snp.top).offset(-20)
        }

        secondContainerCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(firstContainerCollectionView)
            make.height.equalTo(collectionViewHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(secondContainerCollectionView)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-88)
        }
        
        addFoodButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-24)
        }
    }
    
    private func setupKeyboardManager() {
        addTapToHideKeyboardGesture()
    }
    
    private func addTapGestureRecognizer(to view: UIView, with selector: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false

        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            present(imagePickerController, animated: true)

        case .denied, .restricted:
            showSettingsAlert()

        case .notDetermined:
            requestAuthorization(for: imagePickerController)

        case .limited:
            present(imagePickerController, animated: true)

        @unknown default:
            print("Unknown authorization status: \(status.rawValue)")
        }
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: R.string.localizable.mealCreationAccessToPhotosTitle(),
            message: R.string.localizable.mealCreationAccessToPhotosMesage(),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: R.string.localizable.settings(), style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))

        present(alert, animated: true)
    }
    
    private func requestAuthorization(for imagePickerController: UIImagePickerController) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch status {
                case .authorized:
                    self.present(imagePickerController, animated: true)
                    
                case .denied, .restricted:
                    self.showSettingsAlert()
                    
                case .notDetermined:
                    break
                    
                case .limited:
                    self.present(imagePickerController, animated: true)
                    
                @unknown default:
                    print("Unknown authorization status: \(status.rawValue)")
                }
            }
        }
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
        firstContainerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            firstContainerCollectionView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
    }
    
    @objc private func keyboardWillBeShown(notification: NSNotification) {
        guard let keyboardFrame = keyboardFrame(from: notification) else { return }
        
        let heightDiferenceOfView = view.frame.size.height - keyboardFrame.size.height
        let heightDiferenceOfButton = addFoodButton.frame.origin.y - heightDiferenceOfView
        let offsetPoint = heightDiferenceOfButton + addFoodButton.frame.height + 19
        
        collectionViewHeightConstraint.constant -= keyboardFrame.height + addFoodButton.frame.height + 19
        updateHeaderViewHeight(with: offsetPoint)
        animateScrollViewInsets(with: keyboardFrame, offsetPoint: offsetPoint)
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        collectionViewHeightConstraint.constant = containerViewHeight
        updateHeaderViewHeight(with: 0)
        animateScrollViewInsets(with: .zero, offsetPoint: 0)
    }
    
    private func keyboardFrame(from notification: NSNotification) -> CGRect? {
        guard let userInfo = notification.userInfo else { return nil }
        let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return keyboardFrameValue?.cgRectValue
    }
    
    private func updateHeaderViewHeight(with offsetPoint: CGFloat) {
        let newHeaderViewHeight = 163 + offsetPoint
        headerView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(newHeaderViewHeight)
        }
    }
    
    private func animateScrollViewInsets(with keyboardFrame: CGRect, offsetPoint: CGFloat) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
            self.scrollView.contentInset.bottom = keyboardFrame.height
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            self.scrollView.contentOffset = CGPoint(x: 0, y: offsetPoint)
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateCollectionViewHeight() {
        collectionViewHeightConstraint.constant = containerViewHeight
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        
    }
    
    @objc private func didTapAddFoodButton() {
        
    }
}

extension CreateMealViewController: CreateMealViewControllerInterface {
    
}

// MARK: - Factory

extension CreateMealViewController: UIScrollViewDelegate {
    
    private func getContentView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getHeaderView() -> UIView {
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
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        return button
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.addFoodMealCreation()
        label.font = R.font.sfProRoundedBold(size: 24)
        label.textColor = R.color.createMeal.basicPrimary()
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
        let button = CustomAddButton(
            buttonImage: R.image.basicButton.saveInactive(),
            buttonImagePressed: R.image.basicButton.savePressed(),
            gradientFirstColor: R.color.basicButton.gradientFirstColor(),
            gradientSecondColor: R.color.basicButton.gradientSecondColor(),
            borderColorActive: R.color.foodViewing.basicSecondary(),
            borderWidth: 2
        )
        
        button.setTitle(R.string.localizable.save().uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.sfProRoundedBold(size: 18)
        
        let spacing: CGFloat = 4.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        button.setState(.inactive)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }
    
    private func getAddFoodButton() -> CustomAddButton {
        let button = CustomAddButton(
            buttonImage: R.image.basicButton.addDefault()?
                .withTintColor(R.color.createMeal.basicPrimary() ?? .white),
            buttonImagePressed: R.image.basicButton.addDefault()?
                .withTintColor(R.color.createMeal.basicPrimary() ?? .white),
            gradientFirstColor: R.color.createMeal.basicSecondary(),
            gradientSecondColor: R.color.createMeal.basicSecondary(),
            borderColorActive: R.color.foodViewing.basicSecondaryDark(),
            borderWidth: 1
        )
        
        button.setTitle(R.string.localizable.mealCreationAddFoodButton(), for: .normal)
        button.setTitleColor(R.color.createMeal.basicPrimary(), for: .normal)
        button.titleLabel?.font = R.font.sfProRoundedBold(size: 18)
        button.layer.borderColor = R.color.createMeal.basicSecondaryDark()?.cgColor
        
        let spacing: CGFloat = 6.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        button.setState(.active)
        button.addTarget(self, action: #selector(didTapAddFoodButton), for: .touchUpInside)
        return button
    }
        
    private func getContainerPhotoView() -> UIView {
        let containerView = UIView()

        containerView.isHidden = true
        containerView.backgroundColor = .gray

        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false

        containerView.layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.2

        let innerShadow = CALayer()
        innerShadow.frame = containerView.bounds
        innerShadow.masksToBounds = false
        innerShadow.backgroundColor = UIColor.white.cgColor
        innerShadow.shadowColor = UIColor(hex: "000000").cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadow.shadowRadius = 2
        innerShadow.shadowOpacity = 0.25
        containerView.layer.addSublayer(innerShadow)

        let insetShadow = CALayer()
        insetShadow.frame = containerView.bounds
        insetShadow.masksToBounds = false
        insetShadow.backgroundColor = UIColor.clear.cgColor
        insetShadow.shadowColor = UIColor(hex: "FFE665").cgColor
        insetShadow.shadowOffset = CGSize(width: 0, height: 6)
        insetShadow.shadowRadius = 12
        insetShadow.shadowOpacity = 0.25
        insetShadow.borderColor = UIColor(hex: "06BBBB").cgColor
        insetShadow.shadowPath = UIBezierPath(roundedRect: insetShadow.bounds, cornerRadius: 10).cgPath
        containerView.layer.addSublayer(insetShadow)
        
        return containerView
    }
    
    private func getMealPhoto() -> UIImageView {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .brown
        imageView.layer.borderColor = R.color.createMeal.basicSecondary()?.cgColor
        imageView.layer.borderWidth = 2.0
        
        addTapGestureRecognizer(to: imageView, with: #selector(openGallery))
        
        return imageView
    }
    
    private func getFirstContainerCollectionView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(hex: "123E5E").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.25
        return containerView
    }
    
    private func getSecondContainerCollectionView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.2
        return containerView
    }
    
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 57)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MealCollectionViewCell.self)
        collectionView.layoutIfNeeded()

        return collectionView
    }

}

// MARK: - UITextFieldDelegate

extension CreateMealViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == descriptionForm.textField else { return }
        descriptionForm.layer.borderWidth = 1
        descriptionForm.layer.borderColor = R.color.createMeal.basicPrimary()?.cgColor
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text as NSString?
        let replacedText = currentText?.replacingCharacters(in: range, with: string)
        let resultText = replacedText ?? string
        
        guard textField == descriptionForm.textField else { return true }
        saveButton.buttonImage = R.image.basicButton.saveDefault()
        saveButton.setState(resultText.isEmpty ? .inactive : .active)
        
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

// MARK: - UIImagePickerControllerDelegate

extension CreateMealViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else { return }
        mealPhoto.isHidden = false
        containerPhotoView.isHidden = false
        mealPhoto.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CreateMealViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
        
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: MealCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: MealCellViewModel(
            title: "Corn Flakes Original",
            tag: "Basic Food",
            kcal: "456",
            weight: "12 g")
        )

        return cell
    }
}

extension CreateMealViewController: UICollectionViewDelegate {}
