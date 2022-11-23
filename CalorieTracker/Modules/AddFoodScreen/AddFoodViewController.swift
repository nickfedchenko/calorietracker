//
//  AddFoodViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol AddFoodViewControllerInterface: AnyObject {
    func setDishes(_ dishes: [Dish])
    func setProducts(_ products: [Product])
    func setMeals(_ meals: [Meal])
    func getFoodInfoType() -> FoodInfoCases
}

final class AddFoodViewController: UIViewController {
    var presenter: AddFoodPresenterInterface?
    
    // MARK: - Private Propertys
    
    private lazy var overlayView: UIView = getOverlayView()
    private lazy var segmentedControl: SegmentedControl<AddFood> = getSegmentedControl()
    private lazy var segmentedScrollView: UIScrollView = getSegmentedScrollView()
    private lazy var tabBarStackView: UIStackView = getTabBarStackView()
    private lazy var backButton: UIButton = getBackButton()
    private lazy var createButton: VerticalButton = getCreateButton()
    private lazy var scanButton: VerticalButton = getScanButton()
    private lazy var caloriesButton: VerticalButton = getCaloriesButton()
    private lazy var infoButtonsView: InfoButtonsView<FoodInfoCases> = getInfoButtonsView()
    private lazy var keyboardHeaderView: UIView = getKeyboardHeaderView()
    private lazy var hideKeyboardButton: UIButton = getHideKeyboardButton()
    private lazy var menuCreateView: MenuView = getMenuCreateView()
    private lazy var microphoneButton: UIButton = getMicrophoneButton()
    
    private lazy var bottomGradientView = UIView()
    private lazy var menuView = MenuView(Const.menuModels)
    private lazy var menuTypeSecondView = ContextMenuTypeSecondView(Const.menuTypeSecondModels)
    private lazy var menuButton = MenuButton()
    private lazy var searshTextField = SearchTextField()
    private lazy var foodCollectionViewController = FoodCollectionViewController()
    private lazy var searchHistoryViewController = SearchHistoryViewController()
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var searchTextFieldBottomAnchor: NSLayoutConstraint?
    private var collectionViewTopFirstAnchor: NSLayoutConstraint?
    private var collectionViewTopSecondAnchor: NSLayoutConstraint?
    
    private var firstDraw = true
    
    private var dishes: [Dish] = []
    private var products: [Product] = []
    private var meals: [Meal] = []
    
    private var isSelectedType: AddFood = .recent {
        didSet {
            self.foodCollectionViewController.isSelectedType = self.isSelectedType
            presenter?.setFoodType(isSelectedType)
        }
    }
    
    private var selectedFoodInfo: FoodInfoCases = .off {
        didSet {
            foodCollectionViewController.reloadData()
        }
    }
    
    private var state: AddFoodVCState = .default {
        didSet {
            didChangeState()
        }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        didChangeState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuView.closeNotAnimate()
        menuTypeSecondView.closeNotAnimate()
        menuCreateView.closeNotAnimate()
        
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
    
    // MARK: - Private functions
    
    private func setupView() {
        presenter?.setFoodType(.frequent)
        
        view.backgroundColor = .white
        foodCollectionViewController.view.backgroundColor = .white
        
        menuView.isHidden = true
        menuTypeSecondView.isHidden = true
        menuCreateView.isHidden = true
        
        searshTextField.delegate = self
        foodCollectionViewController.dataSource = self
        foodCollectionViewController.delegate = self
        
        self.addChild(foodCollectionViewController)
        self.addChild(searchHistoryViewController)
        
        menuButton.configure(Const.menuModels.first)
        menuButton.completion = { [weak self] complition in
            self?.showOverlay(true)
            self?.menuView.showAndCloseView(true)
            self?.menuView.complition = { model in
                self?.showOverlay(false)
                complition(model)
            }
        }
        
        infoButtonsView.completion = { [weak self] complition in
            self?.showOverlay(true)
            self?.menuTypeSecondView.showAndCloseView(true)
            self?.menuTypeSecondView.complition = { model in
                self?.showOverlay(false)
                switch model {
                case .carb, .fat, .kcal, .protein:
                    complition(.configurable(model))
                case .off:
                    complition(.settings)
                }
                self?.selectedFoodInfo = model
            }
        }
        
        segmentedControl.onSegmentChanged = { model in
            self.isSelectedType = model.id
        }
        
        searchHistoryViewController.complition = { [weak self] search in
            self?.searshTextField.text = search
            self?.state = .search(.foundResults)
        }
        
        menuCreateView.complition = { _ in
            self.showOverlay(false)
        }
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGR.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGR)
    }
    
    private func addSubviews() {
        tabBarStackView.addArrangedSubview(backButton)
        tabBarStackView.addArrangedSubview(createButton)
        tabBarStackView.addArrangedSubview(caloriesButton)
        tabBarStackView.addArrangedSubview(scanButton)
        
        keyboardHeaderView.addSubview(hideKeyboardButton)
        segmentedScrollView.addSubview(segmentedControl)
        view.addSubviews(
            tabBarStackView,
            foodCollectionViewController.view,
            searchHistoryViewController.view,
            menuButton,
            infoButtonsView,
            segmentedScrollView,
            bottomGradientView,
            microphoneButton,
            keyboardHeaderView,
            searshTextField,
            overlayView,
            menuView,
            menuTypeSecondView,
            menuCreateView
        )
    }
    
    private func setupConstraints() {
        searchTextFieldBottomAnchor = searshTextField.bottomAnchor.constraint(
            equalTo: tabBarStackView.topAnchor,
            constant: -12
        )
        contentViewBottomAnchor = keyboardHeaderView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 200
        )
        
        contentViewBottomAnchor?.isActive = true
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            make.height.equalTo(40)
            make.width.equalTo(143)
        }
        
        menuView.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.top.equalTo(menuButton.snp.top)
            make.leading.equalTo(menuButton.snp.leading)
        }
        
        menuTypeSecondView.snp.makeConstraints { make in
            make.width.equalTo(187)
            make.top.equalTo(infoButtonsView.snp.top)
            make.trailing.equalTo(infoButtonsView.snp.trailing)
        }
        
        menuCreateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.69)
        }
        
        segmentedScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(menuButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        tabBarStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(tabBarStackView.snp.width).multipliedBy(0.155)
        }
        
        collectionViewTopSecondAnchor = foodCollectionViewController
            .view
            .topAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            )
        foodCollectionViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoButtonsView.snp.bottom).offset(4).priority(.low)
            make.bottom.equalTo(searshTextField.snp.top)
        }
        
        searchHistoryViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoButtonsView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(segmentedScrollView.snp.bottom).offset(16)
        }
        
        searshTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalTo(searshTextField.snp.height).multipliedBy(4.66)
            make.bottom.lessThanOrEqualTo(keyboardHeaderView.snp.bottom).offset(-20)
            make.bottom.equalTo(tabBarStackView.snp.top).offset(-12).priority(.low)
        }
        
        microphoneButton.aspectRatio()
        microphoneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(searshTextField.snp.trailing).offset(12)
            make.bottom.equalTo(tabBarStackView.snp.top).offset(-12)
        }
        
        keyboardHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(searshTextField).offset(40)
        }
        
        hideKeyboardButton.aspectRatio()
        hideKeyboardButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarStackView.snp.top)
            make.height.equalTo(searshTextField).offset(50)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupShadow() {
        hideKeyboardButton.layer.addShadow(
            shadow: Const.hideKeyboardShadow,
            rect: hideKeyboardButton.bounds,
            cornerRadius: hideKeyboardButton.layer.cornerRadius
        )
        
        bottomGradientView.layer.addSublayer(
            GradientLayer(
                .init(
                    bounds: bottomGradientView.bounds,
                    colors: [.white, .white.withAlphaComponent(0)],
                    axis: .vertical(.bottom),
                    locations: [0.7, 1]
                )
            )
        )
    }
    
    private func showOverlay(_ flag: Bool) {
        overlayView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.overlayView.layer.opacity = flag ? 1 : 0
        } completion: { _ in
            self.overlayView.isHidden = !flag
        }
    }
    
    private func getCell(collectionView: UICollectionView,
                         indexPath: IndexPath) -> UICollectionViewCell {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.cellType = .table
            
            switch indexPath.section {
            case 0:
                let model = products[indexPath.row]
                cell.configure(presenter?.getFoodViewModel(model))
                cell.foodType = .product(model)
            case 1:
                let model = dishes[indexPath.row]
                cell.configure(presenter?.getFoodViewModel(model))
                cell.foodType = .dishes(model)
            default:
                break
            }
            
            return cell
        case .myMeals:
            let cell: RecipesColectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .myRecipes:
            let cell: RecipesColectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .myFood:
            let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.cellType = .withShadow
            return cell
        }
    }
    
    private func didChangeState() {
        setupDefaultState()
        switch self.state {
        case .search(let state):
            switch state {
            case .recent:
                setupSearchRecentState()
            case .noResults:
                break
            case .foundResults:
                setupSearchFoundResultsState()
            }
        case .default:
            setupDefaultState()
        }
    }
    
    private func setupDefaultState() {
        collectionViewTopSecondAnchor?.isActive = false
        searchHistoryViewController.view.isHidden = true
        searchHistoryViewController.view.layer.zPosition = 0
        foodCollectionViewController.view.layer.zPosition = 0
        bottomGradientView.layer.zPosition = 0
        searshTextField.layer.zPosition = 0
        keyboardHeaderView.layer.zPosition = 0
    }
    
    private func setupSearchRecentState() {
        searchHistoryViewController.view.isHidden = false
        searchHistoryViewController.view.layer.zPosition = 5
        bottomGradientView.layer.zPosition = 8
        searshTextField.layer.zPosition = 10
        keyboardHeaderView.layer.zPosition = 9
    }
    
    private func setupSearchFoundResultsState() {
        collectionViewTopSecondAnchor?.isActive = true
        foodCollectionViewController.view.layer.zPosition = 7
        bottomGradientView.layer.zPosition = 8
        searshTextField.layer.zPosition = 10
        keyboardHeaderView.layer.zPosition = 9
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
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
    
    @objc private func didTapCreateButton() {
        showOverlay(true)
        menuCreateView.showAndCloseView(true)
    }
    
    @objc private func didTapCalorieButton() {}
    
    @objc private func didTapScanButton() {}
    
    @objc private func didTapMicrophoneButton() {}
}

// MARK: - FoodCollectionViewController Delegate

extension AddFoodViewController: FoodCollectionViewControllerDelegate {
    func didSelectCell(_ type: Food) {
        presenter?.didTapCell(type)
    }
}

// MARK: - FoodCollectionViewController DataSource

extension AddFoodViewController: FoodCollectionViewControllerDataSource {
    func productsCount() -> Int {
        self.products.count
    }
    
    func dishesCount() -> Int {
        self.dishes.count
    }
    
    func mealsCount() -> Int {
        self.meals.count
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        getCell(collectionView: collectionView, indexPath: indexPath)
    }
}

// MARK: - SearchTextField Delegate

extension AddFoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searshTextField.textAlignment = .left
        guard let text = textField.text, !text.isEmpty else {
            state = .search(.recent)
            return
        }
        state = .search(.foundResults)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let replace = -1 * (range.length * 2 - 1)
        guard let text = textField.text, text.count + replace > 0 else {
            state = .search(.recent)
            return true
        }
        
        state = .search(.foundResults)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            searshTextField.textAlignment = .center
            state = .default
            return
        }
        
        FDS.shared.rememberSearchQuery(text)
    }
}

// MARK: - AddFoodViewController Interface

extension AddFoodViewController: AddFoodViewControllerInterface {
    func setDishes(_ dishes: [Dish]) {
        self.dishes = dishes
        self.foodCollectionViewController.reloadData()
    }
    
    func setProducts(_ products: [Product]) {
        self.products = products
        self.foodCollectionViewController.reloadData()
    }
    
    func setMeals(_ meals: [Meal]) {
        self.meals = meals
        self.foodCollectionViewController.reloadData()
    }
    
    func getFoodInfoType() -> FoodInfoCases {
        self.selectedFoodInfo
    }
}

// MARK: - Factory

private extension AddFoodViewController {
    func getOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = R.color.addFood.overlay()
        view.isHidden = true
        view.layer.opacity = 0
        return view
    }
    
    func getSegmentedControl() -> SegmentedControl<AddFood> {
        let view = SegmentedControl<AddFood>(Const.segmentedModels)
        view.backgroundColor = R.color.addFood.menu.background()
        return view
    }
    
    func getSegmentedScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.clipsToBounds = false
        return view
    }
    
    func getTabBarStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }
    
    func getBackButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.addFood.tabBar.chevronLeft(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.aspectRatio()
        return button
    }
    
    func getCreateButton() -> VerticalButton {
        let button = VerticalButton()
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.setImage(R.image.addFood.tabBar.pencil(), .normal)
        button.setTitle("CREATE", .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        return button
    }
    
    func getScanButton() -> VerticalButton {
        let button = VerticalButton()
        button.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        button.setImage(R.image.addFood.tabBar.scan(), .normal)
        button.setTitle("SCAN", .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        return button
    }
    
    func getCaloriesButton() -> VerticalButton {
        let button = VerticalButton()
        button.addTarget(self, action: #selector(didTapCalorieButton), for: .touchUpInside)
        button.setImage(R.image.addFood.tabBar.calories(), .normal)
        button.setTitle("CALORIES", .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        return button
    }
    
    func getMenuCreateView() -> MenuView {
        let menuView = MenuView(Const.menuCreateModels)
        menuView.backgroundColor = .white
        return menuView
    }
    
    func getInfoButtonsView() -> InfoButtonsView<FoodInfoCases> {
        let view = InfoButtonsView<FoodInfoCases>([
            .settings,
            .immutable(.kcal)
        ])
        
        return view
    }
    
    func getKeyboardHeaderView() -> UIView {
        let view = UIView()
        view.layer.maskedCorners = .topCorners
        view.backgroundColor = .gray
        view.layer.cornerRadius = 32
        return view
    }
    
    func getHideKeyboardButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.addFood.hideKeyboard(), for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = R.color.addFood.white()
        button.addAction(
            UIAction(
                handler: { _ in
                    self.hideKeyboard()
                }
            ),
            for: .touchUpInside
        )
        return button
    }
    
    func getMicrophoneButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
        button.setImage(R.image.addFood.menu.micro(), for: .normal)
        button.backgroundColor = R.color.addFood.menu.isNotSelectedBorder()
        button.imageView?.tintColor = R.color.addFood.menu.isSelectedBorder()
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = R.color.addFood.menu.isSelectedBorder()?.cgColor
        return button
    }
}
