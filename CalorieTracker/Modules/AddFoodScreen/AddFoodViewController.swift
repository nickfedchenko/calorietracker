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
    
    private lazy var overlayView: UIView = getOverlayView()
    private lazy var segmentedControl: SegmentedControl<AddFood> = getSegmentedControl()
    private lazy var segmentedScrollView: UIScrollView = getSegmentedScrollView()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = getCollectionViewFlowLayout()
    private lazy var tabBarStackView: UIStackView = getTabBarStackView()
    private lazy var backButton: UIButton = getBackButton()
    private lazy var createButton: VerticalButton = getCreateButton()
    private lazy var scanButton: VerticalButton = getScanButton()
    private lazy var caloriesButton: VerticalButton = getCaloriesButton()
    private lazy var infoButtonsView: InfoButtonsView<FoodInfoCases> = getInfoButtonsView()
    private lazy var keyboardHeaderView: UIView = getKeyboardHeaderView()
    private lazy var hideKeyboardButton: UIButton = getHideKeyboardButton()
    
    private lazy var bottomGradientView = UIView()
    private lazy var menuView = MenuView(Const.menuModels)
    private lazy var menuTypeSecondView = ContextMenuTypeSecondView(Const.menuTypeSecondModels)
    private lazy var menuButton = MenuButton()
    private lazy var searshTextField = SearchTextField()
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var searchTextFieldBottomAnchor: NSLayoutConstraint?
    private var firstDraw = true
    
    private var dishes: [Dish] = []
    private var products: [Product] = []
    private var meals: [Meal] = []
    
    private var isSelectedType: AddFood = .recent {
        didSet {
            presenter?.setFoodType(isSelectedType)
        }
    }
    
    private var selectedFoodInfo: FoodInfoCases = .off {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuView.closeNotAnimate()
        menuTypeSecondView.closeNotAnimate()
        
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
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        
        presenter?.setFoodType(.frequent)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        menuButton.configure(Const.menuModels.first)
        menuButton.completion = { complition in
            self.menuView.showAndCloseView(true)
            self.menuView.complition = { model in
                complition(model)
            }
        }
        
        infoButtonsView.completion = { complition in
            self.menuTypeSecondView.showAndCloseView(true)
            self.menuTypeSecondView.complition = { model in
                switch model {
                case .carb, .fat, .kcal, .protein:
                    complition(.configurable(model))
                case .off:
                    complition(.settings)
                }
                self.selectedFoodInfo = model
            }
        }
        
        segmentedControl.onSegmentChanged = { model in
            self.isSelectedType = model.id
        }
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGR.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGR)
    }
    
    private func registerCells() {
        collectionView.register(RecipesColectionViewCell.self)
        collectionView.register(FoodCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
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
            collectionView,
            bottomGradientView,
            keyboardHeaderView,
            searshTextField,
            menuButton,
            infoButtonsView,
            segmentedScrollView,
            menuView,
            menuTypeSecondView
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
        
        segmentedScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(menuButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        tabBarStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(tabBarStackView.snp.width).multipliedBy(0.155)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoButtonsView.snp.bottom).offset(4)
            make.bottom.equalTo(tabBarStackView.snp.top)
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
            case 1:
                let model = dishes[indexPath.row]
                cell.configure(presenter?.getFoodViewModel(model))
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
}

// MARK: - CollectionView Delegate

extension AddFoodViewController: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension AddFoodViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return 2
        case .myMeals:
            return 1
        case .myRecipes:
            return 0
        case .myFood:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return section == 0
                ? products.count
                : dishes.count
        case .myMeals:
            return meals.count
        case .myRecipes:
            return 0
        case .myFood:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getCell(collectionView: collectionView, indexPath: indexPath)
    }
}

extension AddFoodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return 0
        case .myMeals, .myRecipes, .myFood:
            return 8
        }
    }
}

extension AddFoodViewController: AddFoodViewControllerInterface {
    func setDishes(_ dishes: [Dish]) {
        self.dishes = dishes
        self.collectionView.reloadData()
    }
    
    func setProducts(_ products: [Product]) {
        self.products = products
        self.collectionView.reloadData()
    }
    
    func setMeals(_ meals: [Meal]) {
        self.meals = meals
        self.collectionView.reloadData()
    }
    
    func getFoodInfoType() -> FoodInfoCases {
        self.selectedFoodInfo
    }
}

// MARK: - Factory

private extension AddFoodViewController {
    func getOverlayView() -> UIView {
        let view = UIView()
        
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
        return view
    }
    
    func getCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }
    
    func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        return layout
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
        button.setImage(R.image.addFood.tabBar.calories(), .normal)
        button.setTitle("CALORIES", .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        return button
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
}
