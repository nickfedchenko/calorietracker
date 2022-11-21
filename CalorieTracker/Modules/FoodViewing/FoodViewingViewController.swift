//
//  FoodViewingViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol FoodViewingViewControllerInterface: AnyObject {

}

final class FoodViewingViewController: UIViewController {
    var presenter: FoodViewingPresenterInterface?
    
    // MARK: - Private
    
    private lazy var mainScrollView: UIScrollView = getMainScrollView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var bottomCloseButton: UIButton = getBottomCloseButton()
    private lazy var keyboardHeaderView: UIView = getKeyboardHeaderView()
    private lazy var valueTextField: InnerShadowTextField = getValueTextField()
    private lazy var addButton: BasicButtonView = getAddButton()
    
    private lazy var bottomBackgroundView: UIView = UIView()
    private lazy var headerImageView = HeaderImageView()
    private lazy var nutritionFactsView = NutritionFactsView()
    private lazy var dailyFoodIntakeView = DailyFoodIntakeView()
    
    private let speechRecognitionManager: SpeechRecognitionManager = .init()
    private var speechRecognitionTask: Task<Void, Error>?
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var firstDraw = true
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        
        guard let product = DSF.shared.getAllStoredProducts().first else { return }
        nutritionFactsView.viewModel = .init(product)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard firstDraw, bottomBackgroundView.frame != .zero else { return }
        addGradientForBottomView()
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        view.backgroundColor = R.color.foodViewing.background()
        nutritionFactsView.layer.opacity = 0.5
        
        headerImageView.didTapLike = { value in
            print(value)
        }
    }
    
    private func addSubviews() {
        mainScrollView.addSubviews(
            titleLabel,
            headerImageView,
            nutritionFactsView,
            dailyFoodIntakeView
        )
        
        view.addSubviews(
            mainScrollView,
            bottomBackgroundView,
            bottomCloseButton,
            addButton,
            valueTextField
        )
    }
    
    private func setupConstraints() {
        mainScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(valueTextField.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(32)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(headerImageView.snp.width).multipliedBy(0.65)
        }
        
        dailyFoodIntakeView.aspectRatio(0.45)
        dailyFoodIntakeView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(headerImageView.snp.bottom).offset(16)
        }
        
        nutritionFactsView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(dailyFoodIntakeView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        
        bottomBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        bottomCloseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.155)
        }
        
        addButton.aspectRatio(0.17)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomCloseButton.snp.top).offset(-20)
        }
        
        valueTextField.aspectRatio(0.73)
        valueTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(addButton.snp.top).offset(-12)
            make.height.equalTo(addButton)
        }
    }
    
    private func hideNavBar() {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addGradientForBottomView() {
        let gradientLayer = GradientLayer(.init(
            bounds: bottomBackgroundView.bounds,
            colors: [
                R.color.foodViewing.background(),
                R.color.foodViewing.background()?.withAlphaComponent(0)
            ],
            axis: .vertical(.bottom),
            locations: [0.85, 1.0]
        ))
        
        bottomBackgroundView.layer.addSublayer(gradientLayer)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardNotification = KeyboardNotification(userInfo)
        else { return }
        
        contentViewBottomAnchor?.constant = -keyboardNotification.endFrame.height
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0,
            options: keyboardNotification.animateCurve
        ) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardNotification = KeyboardNotification(userInfo)
        else { return }
        
        contentViewBottomAnchor?.constant = keyboardHeaderView.frame.height
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0,
            options: keyboardNotification.animateCurve
        ) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
}

// MARK: - ViewController Interface

extension FoodViewingViewController: FoodViewingViewControllerInterface {

}

// MARK: - ScrollView Delegate

extension FoodViewingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerImageView.frame.maxY / 2.0 {
            nutritionFactsView.animate(.opacity(1), 0.5)
        } else {
            nutritionFactsView.animate(.opacity(0.5), 0.5)
        }
    }
}

// MARK: - Factory

extension FoodViewingViewController {
    func getKeyboardHeaderView() -> UIView {
        let view = UIView()
        view.layer.maskedCorners = .topCorners
        view.backgroundColor = .gray
        view.layer.cornerRadius = 32
        return view
    }
    
    func getBottomCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    func getMainScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.delegate = self
        return view
    }
    
    func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 24)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.numberOfLines = 0
        label.text = "Apple"
        return label
    }
    
    func getValueTextField() -> InnerShadowTextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColor = R.color.foodViewing.basicSecondaryDark()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.textAlignment = .center
        return textField
    }
    
    func getAddButton() -> BasicButtonView {
        let button = BasicButtonView(type: .add)
        
        return button
    }
}
