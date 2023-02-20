//
//  ProductViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProductViewControllerInterface: AnyObject {
    func getOpenController() -> ProductViewController.OpenController
    func viewControllerShouldClose()
}

final class ProductViewController: CTViewController {
    enum OpenController {
        case addFood
        case createProduct
    }
    
    var shouldClose: (() -> Void)?
    var presenter: ProductPresenterInterface?
    var keyboardManager: KeyboardManagerProtocol?
    
    // MARK: - Private
    
    private let openController: OpenController
    
    private lazy var mainScrollView: UIScrollView = getMainScrollView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var bottomCloseButton: UIButton = getBottomCloseButton()
    private lazy var valueTextField: InnerShadowTextField = getValueTextField()
    private lazy var addButton: BasicButtonView = getAddButton()
    private lazy var selectView: SelectView = getSelectView()
    private lazy var overlayView: UIView = getOverlayView()
    private lazy var headerKeyboardView: UIView = getHeaderKeyboardView()
    
    private lazy var bottomGradientView: UIView = UIView()
    private lazy var bottomContainerView: UIView = UIView()
    private lazy var headerImageView = HeaderImageView()
    private lazy var nutritionFactsView = NutritionFactsView()
    private lazy var dailyFoodIntakeView = DailyFoodIntakeView()
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var firstDraw = true
    private var weight: Double = 0
    
    private var addNutrition: DailyNutrition = .zero {
        didSet {
            didChangeAddNutrition()
        }
    }
    
    private lazy var selectedWeightType: UnitElement.ConvenientUnit = presenter?
        .getProduct()?
        .units?
        .first?
        .convenientUnit
    ?? .custom(title: "Undefined", shortTitle: "Undefined", coefficient: 1) {
        didSet {
            didChangeWeight()
        }
    }
    
    // MARK: - Initialize
    
    init(_ openController: OpenController) {
        self.openController = openController
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        presenter?.createFoodData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard firstDraw,
              bottomGradientView.frame != .zero,
              valueTextField.frame != .zero,
              headerKeyboardView.frame != .zero else { return }
        addGradientForBottomView()
        selectView.height = valueTextField.frame.height
        configureKeyboardManager()
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        didChangeWeight()
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        view.backgroundColor = R.color.foodViewing.background()
        nutritionFactsView.layer.opacity = 0.5
        
        dailyFoodIntakeView.configure(
            from: presenter?.getNutritionDaily() ?? .zero,
            to: addNutrition,
            goal: presenter?.getNutritionDailyGoal() ?? .zero
        )
        
        headerImageView.didTapLike = { value in
            Vibration.selection.vibrate()
            self.presenter?.didTapFavoriteButton(value)
        }
        
        selectView.didSelectedCell = { [weak self] type, isColapsed in
            self?.showOverlayView(isColapsed)
            self?.selectedWeightType = type
            if !isColapsed {
                self?.valueTextField.selectAll(nil)
            }
        }
        
        guard let product = presenter?.getProduct() else { return }
        nutritionFactsView.viewModel = .init(product)
        titleLabel.text = product.title
        headerImageView.configure(
            photo: product.photo,
            check: false,
            favorite: presenter?.isFavoritesProduct ?? false
        )
    }
    
    private func addSubviews() {
        mainScrollView.addSubviews(
            titleLabel,
            headerImageView,
            nutritionFactsView,
            dailyFoodIntakeView
        )
        
        bottomContainerView.addSubviews(
            addButton,
            valueTextField
        )
        
        view.addSubviews(
            overlayView,
            mainScrollView,
            bottomGradientView,
            bottomCloseButton,
            headerKeyboardView,
            bottomContainerView,
            selectView
        )
    }
    
    // swiftlint:disable:next function_body_length
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
        
        dailyFoodIntakeView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(headerImageView.snp.bottom).offset(16)
        }
        
        nutritionFactsView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(dailyFoodIntakeView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(headerKeyboardView.snp.bottom).offset(-20)
            make.bottom.equalTo(bottomCloseButton.snp.top).offset(-20).priority(.low)
        }
        
        bottomCloseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.155)
        }
        
        addButton.aspectRatio(0.17)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        valueTextField.aspectRatio(0.73)
        valueTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(addButton.snp.top).offset(-12)
            make.height.equalTo(addButton)
            make.top.equalToSuperview()
        }
        
        selectView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(valueTextField.snp.trailing).offset(12)
            make.bottom.equalTo(valueTextField.snp.bottom)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentViewBottomAnchor = headerKeyboardView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 200
        )
        contentViewBottomAnchor?.isActive = true
        
        headerKeyboardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(bottomContainerView).offset(40)
        }
    }
    
    private func hideNavBar() {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func showOverlayView(_ flag: Bool) {
        overlayView.layer.zPosition = flag ? 1 : 0
        headerKeyboardView.layer.zPosition = flag ? 2 : 0
        bottomContainerView.layer.zPosition = flag ? 3 : 0
        selectView.layer.zPosition = flag ? 4 : 0
        
        UIView.animate(withDuration: 0.1) {
            self.overlayView.layer.opacity = flag ? 1 : 0
            self.overlayView.isHidden = !flag
        }
    }
    
    private func addGradientForBottomView() {
        let gradientLayer = GradientLayer(.init(
            bounds: bottomGradientView.bounds,
            colors: [
                R.color.foodViewing.background(),
                R.color.foodViewing.background()?.withAlphaComponent(0)
            ],
            axis: .vertical(.bottom),
            locations: [0.85, 1.0]
        ))
        
        bottomGradientView.layer.addSublayer(gradientLayer)
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func didChangeWeight() {
        guard let textValue = valueTextField.text,
              let product = presenter?.getProduct() else {
            return
        }
        let value = Double(textValue) ?? 0
        
        switch selectedWeightType {
        case .gram(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .oz(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient, isOz: true)
        case .portion(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .cup(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .cupGrated(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .cupSliced(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .teaSpoon(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .tableSpoon(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .piece(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .smallSize(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .middleSize(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .hugeSize(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .pack(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .ml(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .floz(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        case .custom(_, _, coefficient: let coefficient):
            setAddNutrition(from: product, with: value, using: coefficient)
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func setAddNutrition(
        from product: Product,
        with value: Double,
        using coefficient: Double?,
        isOz: Bool = false
    ) {
        guard let coefficient = coefficient else {
            return
        }
        
        if !isOz {
            let kcal = Double(product.kcal) / 100.0 * (value * coefficient)
            let carbs = //NutrientMeasurment.convert(
            product.carbs / 100 * (coefficient * value)
            //                type: .carbs,
            //                from: .gram,
            //                to: .kcal
            //            )
            
            let protein = // NutrientMeasurment.convert(
            product.protein / 100.0 * (value * coefficient)
            //                type: .protein,
            //                from: .gram,
            //                to: .kcal
            //            )
            
            let fat = //NutrientMeasurment.convert(
            product.fat / 100.0 * (value * coefficient)
            //                type: .fat,
            //                from: .gram,
            //                to: .kcal
            //            )
            weight = value * coefficient
            addNutrition = .init(
                kcal: kcal,
                carbs: carbs,
                protein: protein,
                fat: fat
            )
        } else {
            let kcal = Double(product.kcal) / 100.0 * (value / coefficient)
            let carbs = // NutrientMeasurment.convert(
            product.carbs / 100 * (value / coefficient)
            //                type: .carbs,
            //                from: .gram,
            //                to: .kcal
            //            )
            
            let protein = // NutrientMeasurment.convert(
            product.protein / 100.0 * (value / coefficient)
            //                type: .protein,
            //                from: .gram,
            //                to: .kcal
            //            )
            
            let fat = // NutrientMeasurment.convert(
            product.fat / 100.0 * (value / coefficient)
            //                type: .fat,
            //                from: .gram,
            //                to: .kcal
            //            )
            weight = value / coefficient
            addNutrition = .init(
                kcal: kcal,
                carbs: carbs,
                protein: protein,
                fat: fat
            )
        }
    }
    
    private func didChangeAddNutrition() {
        dailyFoodIntakeView.configure(
            from: presenter?.getNutritionDaily() ?? .zero,
            to: addNutrition,
            goal: presenter?.getNutritionDailyGoal() ?? .zero
        )
    }
    
    private func configureKeyboardManager() {
        addTapToHideKeyboardGesture()
        keyboardManager?.bindToKeyboardNotifications(
            superview: view,
            bottomConstraint: contentViewBottomAnchor ?? .init(),
            bottomOffset: headerKeyboardView.frame.height,
            animated: true
        )
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapCloseButton()
    }
    
    @objc private func didChangeTextFieldValue() {
        didChangeWeight()
    }
    
    @objc private func didTapSaveButton() {
        Vibration.success.vibrate()
        presenter?.saveNutritionDaily(weight)
        didChangeAddNutrition()
        
        if let product = presenter?.getProduct() {
            FDS.shared.foodUpdate(food: .product(product, customAmount: nil), favorites: nil)
        }
    }
}

// MARK: - ViewController Interface

extension ProductViewController: ProductViewControllerInterface {
    func getOpenController() -> OpenController {
        return self.openController
    }
    
    func viewControllerShouldClose() {
        self.shouldClose?()
    }
}

// MARK: - ScrollView Delegate

extension ProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerImageView.frame.maxY / 2.0 {
            nutritionFactsView.animate(.opacity(1), 0.5)
        } else {
            nutritionFactsView.animate(.opacity(0.5), 0.5)
        }
    }
}

// MARK: - Factory

extension ProductViewController {
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
        return label
    }
    
    func getValueTextField() -> InnerShadowTextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColors = [R.color.foodViewing.basicSecondaryDark() ?? .clear]
        textField.layer.borderWidth = 1
        textField.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .light
        textField.addTarget(
            self,
            action: #selector(didChangeTextFieldValue),
            for: .editingChanged
        )
        textField.text = "100"
        return textField
    }
    
    func getAddButton() -> BasicButtonView {
        let button = BasicButtonView(type: .add)
        button.addTarget(
            self,
            action: #selector(didTapSaveButton),
            for: .touchUpInside
        )
        return button
    }
    
    func getSelectView() -> SelectView<UnitElement.ConvenientUnit> {
        SelectView(presenter?.getProduct()?.units?.compactMap { $0.convenientUnit } ?? [], shouldHideAtStartup: true)
    }
    
    func getOverlayView() -> UIView {
        let view = UIView()
        view.isHidden = true
        view.layer.opacity = 0
        view.backgroundColor = R.color.foodViewing.basicPrimary()?
            .withAlphaComponent(0.25)
        return view
    }
    
    func getHeaderKeyboardView() -> ViewWithShadow {
        let view = ViewWithShadow(Const.shadowsForKeyboard)
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = .topCorners
        view.layer.cornerRadius = 36
        view.backgroundColor = R.color.keyboardLightColor()
        return view
    }
}

extension ProductViewController {
    struct Const {
        static let shadowsForKeyboard: [Shadow] = [
            .init(
                color: R.color.foodViewing.basicSecondaryDark()!,
                opacity: 0.2,
                offset: CGSize(width: 0, height: -2),
                radius: 10
            ),
            .init(
                color: R.color.foodViewing.basicPrimary()!,
                opacity: 0.7,
                offset: CGSize(width: 0, height: -0.5),
                radius: 2
            )
        ]
    }
}

extension ProductViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ModalSideTransitionAppearing()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalSideTransitionDissapearing()
    }
}
