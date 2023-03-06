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
    func openAddFoodVC()
    func removeFood(at index: Int)
    func setFoods(_ foods: [Food])
    func getMealTime() -> MealTime
}

class CreateMealViewController: UIViewController {
    
    var presenter: CreateMealPresenterInterface?
    
    private lazy var contentView: UIView = getContentView()
    private lazy var header: CreateMealPageScreenHeader = getHeader()
    private lazy var scrollView: UIScrollView = getScrollView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var descriptionLabel: UILabel = getDescriptionLabel()
    private lazy var descriptionForm: FormView = getDescriptionForm()
    private lazy var saveButton: CustomAddButton = getSaveButton()
    private lazy var addFoodButton: CustomAddButton = getAddFoodButton()
    private lazy var firstContainerTableView: UIView = getFirstContainerTableView()
    private lazy var secondContainerTableView: UIView = getSecondContainerTableView()
    private lazy var tableView: UITableView = getTableView()
    
    private let placeholderAttributes = [
        NSAttributedString.Key.foregroundColor: R.color.grayBasicGray(),
        .font: R.font.sfProTextMedium(size: 17)
    ].mapValues { $0 as Any }
    
    private var searchRequest: String?
    private var foods: [Food] = []
    
    private lazy var tableViewHeightConstraint = firstContainerTableView
        .heightAnchor.constraint(
            equalToConstant: containerViewHeight
        )
    
    private let cellHeight: CGFloat = 57
    private var cellCount: Int = 0
    private var tableViewHeight: CGFloat = 0
    private var containerViewHeight: CGFloat = 0
    private var tableViewHeightOffset: CGFloat = 445
    private var keyboardHeight: CGFloat?
    
    let mealTime: MealTime
    
    init(mealTime: MealTime) {
        self.mealTime = mealTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        addSubviews()
        didChangeFoods()
        descriptionForm.textField.becomeFirstResponder()
        setupKeyboardManager()
        registerNotifications()
        updateContentViewHeight()
    }
    
    func didChangeFoods() {
        DispatchQueue.main.async {
            self.setupView()
            self.addSubviews()
            self.cellCount = self.foods.count
            self.tableViewHeight = CGFloat(self.cellCount) * self.cellHeight
            self.containerViewHeight = self.tableViewHeight + 20
            self.setupConstraints()
            self.setupKeyboardManager()
            self.registerNotifications()
            self.updateContentViewHeight()
            self.updateSaveButton()
            self.tableView.reloadData()
        }
    }

    private func setupView() {
        view.backgroundColor = R.color.createMeal.background()
    }
    
    private func addSubviews() {
        view.addSubviews(
            scrollView,
            saveButton
        )
        
        scrollView.addSubview(
            contentView
        )
        
        contentView.addSubviews(
            descriptionLabel,
            descriptionForm,
            firstContainerTableView,
            secondContainerTableView,
            tableView,
            header,
            titleLabel,
            addFoodButton
        )
        
    }
    
    private func setupConstraints() {
        scrollView.snp.remakeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(scrollView).offset(-scrollView.adjustedContentInset.top)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(addFoodButton.snp.bottom).offset(20)
        }
        
        header.snp.remakeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(95)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(contentView).offset(103)
            make.leading.trailing.equalTo(contentView).inset(28)
        }
        
        descriptionForm.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.height.equalTo(48)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.leading.equalTo(contentView).inset(28)
            make.bottom.equalTo(descriptionForm.snp.top).offset(-4)
        }
        
        firstContainerTableView.snp.remakeConstraints { make in
            make.top.equalTo(descriptionForm.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.lessThanOrEqualTo(addFoodButton.snp.top).offset(-20)
        }
        
        secondContainerTableView.snp.remakeConstraints { make in
            make.edges.equalTo(firstContainerTableView)
            make.height.equalTo(tableViewHeight)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(secondContainerTableView)
            make.leading.trailing.equalTo(secondContainerTableView).inset(-20)
        }
        
        saveButton.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-88)
            make.height.equalTo(64)
        }
        
        addFoodButton.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualTo(descriptionForm.snp.bottom).offset(tableViewHeightOffset)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-24)
            make.height.equalTo(64)
        }
    }
    
    private func updateContentViewHeight() {
        let contentHeight = contentView.systemLayoutSizeFitting(
            CGSize(width: view.frame.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultHigh
        ).height
        
        contentView.frame.size.height = contentHeight
        scrollView.contentSize.height = contentHeight
    }
    
    private func setupKeyboardManager() {
        addTapToHideKeyboardGesture()
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
       }
       
       @objc private func keyboardWillBeShown(notification: NSNotification) {
           guard let keyboardFrame = keyboardFrame(from: notification) else { return }

           keyboardHeight = keyboardFrame.height + 19

           let heightDiferenceOfView = view.frame.size.height - keyboardFrame.size.height
           let heightDiferenceOfButton = addFoodButton.frame.origin.y - heightDiferenceOfView
           let buttonFrameHeight = addFoodButton.frame.height + 19
           let offsetPoint = heightDiferenceOfButton + buttonFrameHeight

           tableViewHeightOffset -= offsetPoint
           setupConstraints()

           UIView.animate(withDuration: 0.6) {
               self.tableViewHeightConstraint.constant -= keyboardFrame.height + buttonFrameHeight
               self.animateScrollViewInsets(with: offsetPoint)
               self.view.layoutIfNeeded()
           }
       }

       @objc private func keyboardWillBeHidden(notification: NSNotification) {
           keyboardHeight = nil
           tableViewHeightOffset = 445
           setupConstraints()

           UIView.animate(withDuration: 0.6) {
               self.view.layoutIfNeeded()
           }
       }
    
       private func animateScrollViewInsets(with offsetPoint: CGFloat) {
           guard let keyboardHeight = keyboardHeight else { return }
           let descriptionFormMaxY = descriptionForm.frame.maxY
           let headerViewMaxY = header.frame.maxY

           scrollView.contentInset.bottom = keyboardHeight
           scrollView.verticalScrollIndicatorInsets = scrollView.contentInset

           guard descriptionFormMaxY < headerViewMaxY else { return }
           scrollView.setContentOffset(CGPoint(x: 0, y: offsetPoint), animated: true)
       }
    
    private func keyboardFrame(from notification: NSNotification) -> CGRect? {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        return keyboardFrameValue.cgRectValue
    }
    
    private func configure(_ cell: MealTableViewCell, at indexPath: IndexPath) {
        guard let foodType = foods[safe: indexPath.row] else {
            return
        }
        
        var viewModel: MealCellViewModel
        
        switch foodType {
        case .product(let product, _, _):
            viewModel = MealCellViewModel(
                title: product.title,
                tag: product.brand,
                kcal: "\(Int(product.kcal.rounded()))",
                weight: "\(Int(product.servings?.first?.weight?.rounded() ?? 0.0)) g"
            )
        case .dishes(let dish, _):
            viewModel = MealCellViewModel(
                title: dish.title,
                tag: dish.eatingTags.first?.title,
                kcal: "\(Int(dish.kcal.rounded()))",
                weight: "\(Int(dish.dishWeight ?? 0.0)) g"
            )
        case .customEntry(let customEntry):
            viewModel = MealCellViewModel(
                title: customEntry.title,
                tag: R.string.localizable.addFoodCustomEntry().capitalized,
                kcal: "\(Int(customEntry.nutrients.kcal.rounded()))",
                weight: nil
            )
        case .meal:
            return
        }
        
        cell.configure(with: viewModel)
        indexPath.row < cellCount - 1 ? cell.showSeparator() : cell.hideSeparator()
    }
    
    private func updateTableViewHeight() {
        tableViewHeightConstraint.constant = containerViewHeight
    }
    
    private func updateSaveButton() {
        saveButton.buttonImage = R.image.basicButton.saveDefault()
        saveButton.active = cellCount >= 2
    }
    
    @objc private func didTapSaveButton() {
        dismiss(animated: true) {
            self.header.releaseBlurAnimation()
            self.presenter?.saveMeal()
        }
    }
    
    @objc private func didTapAddFoodButton() {
        openAddFoodVC()
    }
}

extension CreateMealViewController: CreateMealViewControllerInterface {
    func openAddFoodVC() {
        presenter?.didTapAddFood(with: searchRequest ?? "")
    }
        
    func setFoods(_ foods: [Food]) {
        DispatchQueue.main.async {
            self.foods = foods
            self.didChangeFoods()
        }
    }
    
    func removeFood(at index: Int) {
        presenter?.removeFood(at: index)
    }
    
    func getMealTime() -> MealTime {
        return mealTime
    }
}

// MARK: - Factory

extension CreateMealViewController {
    
    private func getContentView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getHeader() -> CreateMealPageScreenHeader {
        let header = CreateMealPageScreenHeader()
        header.delegate = self
        return header
    }
    
    private func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.isPagingEnabled = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }
    
    private func getTitleLabel() -> UILabel {
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
        button.active = false
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
        button.active = true
        button.addTarget(self, action: #selector(didTapAddFoodButton), for: .touchUpInside)
        return button
    }
    
    private func getFirstContainerTableView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = R.color.createMeal.background()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(hex: "123E5E").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.25
        return containerView
    }
    
    private func getSecondContainerTableView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = R.color.createMeal.background()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.2
        return containerView
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.rowHeight = 57
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 8
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MealTableViewCell.self)
        tableView.layoutIfNeeded()
        
        return tableView
    }
    
    private func deleteRowImage() -> UIImage {
        let imageView = UIImageView(image: R.image.createMeal.deleteRow())
        
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor(hex: "210020").cgColor
        imageView.layer.shadowOpacity = 0.25
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 20).cgPath
        
        imageView.layer.shadowColor = UIColor(hex: "E340DD").cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 20).cgPath
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        imageView.layer.render(in: context)
        let imageWithShadows = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithShadows ?? UIImage()
    }
}

// MARK: - CreateMealPageScreenHeaderDelegate

extension CreateMealViewController: CreateMealPageScreenHeaderDelegate {
    
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    func openGallery() {
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
}

// MARK: - UIScrollViewDelegate

extension CreateMealViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titleLabelMaxY = titleLabel.frame.maxY
        let headerViewMaxY = header.frame.maxY
        
        if titleLabelMaxY < headerViewMaxY {
            header.reinitBlurView()
            titleLabel.isHidden = true
            header.hiddenTitle(false)
        } else {
            header.releaseBlurAnimation()
            titleLabel.isHidden = false
            header.hiddenTitle(true)
        }
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
        let resultText = replacedText ?? ""
        
        guard textField == descriptionForm.textField else { return true }
        searchRequest = resultText

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
        header.setImage(image)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CreateMealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MealTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            self.removeFood(at: indexPath.row)
            self.didChangeFoods()
            completionHandler(true)

        }

        deleteAction.image = deleteRowImage()
        deleteAction.backgroundColor = R.color.createMeal.background()

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MealTableViewCell {
            cell.addShadow()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let indexPath = indexPath,
            let cell = tableView.cellForRow(at: indexPath) as? MealTableViewCell {
            cell.removeShadow()
        }

        tableView.reloadData()
    }
}
