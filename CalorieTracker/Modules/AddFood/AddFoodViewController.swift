//
//  AddFoodViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol AddFoodViewControllerInterface: AnyObject {
    func setFoods(_ foods: [Food])
    func getFoodInfoType() -> FoodInfoCases
}

final class AddFoodViewController: UIViewController {
    var presenter: AddFoodPresenterInterface?
    var keyboardManager: KeyboardManagerProtocol?
    
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
    private lazy var doneButton: UIButton = getDoneButton()
    
    private lazy var bottomGradientView = UIView()
    private lazy var menuMealView = MenuView(Const.menuModels)
    private lazy var menuTypeSecondView = ContextMenuTypeSecondView(Const.menuTypeSecondModels)
    private lazy var menuButton = MenuButton<MealTime>()
    private lazy var searshTextField = SearchView()
    private lazy var foodCollectionViewController = FoodCollectionViewController()
    private lazy var searchHistoryViewController = SearchHistoryViewController()
    private lazy var counterKcalControl = CounterKcalControl()
    
    private var menuMealController: BAMenuController?
    
    private let speechRecognitionManager: SpeechRecognitionManager = .init()
    private var speechRecognitionTask: Task<Void, Error>?
    
    private var timer: Timer?
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var searchTextFieldBottomAnchor: NSLayoutConstraint?
    private var collectionViewTopFirstAnchor: NSLayoutConstraint?
    private var collectionViewTopSecondAnchor: NSLayoutConstraint?
    private var doneButtonWidthAnchor: NSLayoutConstraint?
    
    private var firstDraw = true
    private var microphoneButtonSelected = false
    
    private var foods: [Food] = []
    
    private var selectedFood: [Food]? {
        didSet {
            didChangeSelectedFood()
        }
    }
    
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
        setupHandlers()
        addSubviews()
        setupConstraints()
        didChangeState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw, keyboardHeaderView.frame != .zero else { return }
        setupShadow()
        configureKeyboardManager()
        menuMealController?.anchorPoint = menuButton.frame.origin
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuTypeSecondView.closeNotAnimate()
        menuCreateView.closeNotAnimate()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        presenter?.setFoodType(.frequent)
        
        view.backgroundColor = .white
        foodCollectionViewController.view.backgroundColor = .white
        
        menuTypeSecondView.isHidden = true
        menuCreateView.isHidden = true
        
        searshTextField.textField.keyboardAppearance = .light
        searshTextField.textField.keyboardType = .webSearch
        searshTextField.placeholderText = R.string.localizable.addFoodPlaceholder()
    
        foodCollectionViewController.dataSource = self
        foodCollectionViewController.delegate = self
        
        self.addChild(foodCollectionViewController)
        self.addChild(searchHistoryViewController)
        
        counterKcalControl.isHidden = true
        counterKcalControl.addTarget(
            self,
            action: #selector(didTapCounterControl),
            for: .touchUpInside
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setupHandlers() {
        searshTextField.didBeginEditing = { text in
            self.isSelectedType = .search

            guard !text.isEmpty else {
                self.state = .search(.recent)
                return
            }
        }
        
        searshTextField.didChangeValue = { text in
            self.createTimer()
            guard !text.isEmpty else {
                self.state = .search(.recent)
                return
            }
        }
        
        searshTextField.didEndEditing = { text in
            guard !text.isEmpty else {
                self.isSelectedType = .frequent
                self.state = .default
                return
            }
            
            FDS.shared.rememberSearchQuery(text)
        }
        
        menuMealController = .init(menuMealView, width: 200)
        
        menuButton.configure(Const.menuModels.first)
        menuButton.completion = { [weak self] complition in
            self?.showMealMenu()
            self?.menuMealView.complition = { model in
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
            
            switch model.id {
            case .frequent, .recent, .favorites:
                self.infoButtonsView.isHidden = false
            case .myMeals, .myRecipes, .myFood:
                self.infoButtonsView.isHidden = true
            case .search:
                break
            }
        }
        
        searchHistoryViewController.complition = { [weak self] search in
            self?.searshTextField.text = search
            self?.didEndTimer()
        }
        
        menuCreateView.complition = { type in
            self.showOverlay(false)
            self.presenter?.createFood(type)
        }
        
        foodCollectionViewController.createHandler = {
            self.presenter?.createFood(.food)
        }
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
            counterKcalControl,
            bottomGradientView,
            microphoneButton,
            keyboardHeaderView,
            searshTextField,
            doneButton,
            overlayView,
            menuTypeSecondView,
            menuCreateView
        )
    }
    
    // swiftlint:disable:next function_body_length
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
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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
            make.leading.greaterThanOrEqualTo(searshTextField.snp.trailing).offset(12)
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
        
        counterKcalControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        doneButtonWidthAnchor = doneButton
            .widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.71)
        doneButton.snp.makeConstraints { make in
            make.trailing.equalTo(microphoneButton)
            make.bottom.top.equalTo(searshTextField)
            make.leading.greaterThanOrEqualTo(searshTextField.snp.trailing).offset(12)
            make.width.equalTo(0).priority(.low)
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
    
    private func showMealMenu() {
        guard let menuMealController = menuMealController else {
            return
        }

        present(menuMealController, animated: true)
    }
    
    private func getCell(collectionView: UICollectionView,
                         indexPath: IndexPath) -> UICollectionViewCell {
        switch isSelectedType {
        case .frequent, .recent, .favorites, .search:
            let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let food = foods[safe: indexPath.row]
            cell.viewModel = .init(
                cellType: .table,
                food: food,
                buttonType: .add,
                subInfo: presenter?.getSubInfo(food, selectedFoodInfo),
                colorSubInfo: selectedFoodInfo.getColor()
            )
            cell.didTapButton = { food in
                self.selectedFood = (self.selectedFood ?? []) + [food]
                FDS.shared.foodUpdate(food: food, favorites: false)
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
            let food = foods[safe: indexPath.row]
            cell.viewModel = .init(
                cellType: .table,
                food: food,
                buttonType: .add,
                subInfo: presenter?.getSubInfo(food, selectedFoodInfo),
                colorSubInfo: selectedFoodInfo.getColor()
            )
            cell.didTapButton = { food in
                self.selectedFood = (self.selectedFood ?? []) + [food]
            }
            return cell
        }
    }
    
    private func getFoodCellModel(_ indexPath: IndexPath) -> FoodCellViewModel? {
        switch isSelectedType {
        case .frequent, .recent, .favorites, .search, .myFood:
            let food = foods[safe: indexPath.row]
            return FoodCellViewModel(
                cellType: isSelectedType == .myFood ? .withShadow : .table,
                food: food,
                buttonType: .add,
                subInfo: presenter?.getSubInfo(food, selectedFoodInfo),
                colorSubInfo: selectedFoodInfo.getColor()
            )
        default:
            return nil
        }
    }
    
    private func didChangeSelectedFood() {
        guard let selectedFood = selectedFood, !selectedFood.isEmpty else {
            counterKcalControl.isHidden = true
            showDoneButton(false)
            return
        }
        let sumKcal = selectedFood.compactMap { $0.foodInfo[.kcal] }.sum()
        counterKcalControl.isHidden = false
        counterKcalControl.configure(.init(
            kcal: sumKcal,
            count: selectedFood.count
        ))
    }
    
    private func didChangeState() {
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
        searchHistoryViewController.view.isHidden = true
        collectionViewTopSecondAnchor?.isActive = true
        foodCollectionViewController.view.layer.zPosition = 7
        bottomGradientView.layer.zPosition = 8
        searshTextField.layer.zPosition = 10
        keyboardHeaderView.layer.zPosition = 9
    }
    
    private func showDoneButton(_ flag: Bool) {
        microphoneButton.isHidden = true
        doneButton.isHidden = false
        doneButtonWidthAnchor?.isActive = flag
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.doneButton.isHidden = !flag
            self.microphoneButton.isHidden = flag
        }
    }
    
    private func createTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(didEndTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    private func configureKeyboardManager() {
        keyboardManager?.bindToKeyboardNotifications(
            superview: view,
            bottomConstraint: contentViewBottomAnchor ?? .init(),
            bottomOffset: keyboardHeaderView.frame.height,
            animated: true
        )
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
    
    @objc private func didTapScanButton() {
        presenter?.didTapScannerButton()
    }
    
    @objc private func didEndTimer() {
        guard let searchText = searshTextField.text, !searchText.isEmpty else { return }
        presenter?.search(searchText, complition: { flag in
            self.state = flag ? .search(.foundResults) : .search(.noResults)
        })
    }
    
    @objc private func didTapCounterControl() {
        guard let selectedFood = selectedFood, !selectedFood.isEmpty else { return }
        presenter?.didTapCountControl(selectedFood, complition: { newFoods in
            self.selectedFood = newFoods
        })
    }
    
    @objc private func didTapDoneButton() {
        guard let mealTime = menuButton.model else { return }
        presenter?.saveMeal(mealTime, foods: selectedFood ?? [])
    }
    
    @objc private func didTapMicrophoneButton() {
        microphoneButtonSelected = !microphoneButtonSelected
        
        switch microphoneButtonSelected {
        case true:
            speechRecognitionTask?.cancel()
            speechRecognitionTask = Task {
                let result = await SpeechRecognitionManager.requestAuthorization()
                switch result {
                case .notDetermined, .denied, .restricted:
                    // TODO: - Обработать исключения
                    break
                case .authorized:
                    let request = SpeechAudioBufferRecognitionRequest()
                    for try await result in await speechRecognitionManager.start(request: request) {
                        await MainActor.run {
                            let text = result.bestTranscription.formattedString
                            searshTextField.text = text
                            presenter?.search(text, complition: nil)
                        }
                    }
                }
            }
        case false:
            Task {
                await speechRecognitionManager.finish()
            }
        }
    }
}

// MARK: - FoodCollectionViewController Delegate

extension AddFoodViewController: FoodCollectionViewControllerDelegate {
    func didSelectCell(_ type: Food) {
        presenter?.didTapCell(type)
    }
}

// MARK: - FoodCollectionViewController DataSource

extension AddFoodViewController: FoodCollectionViewControllerDataSource {
    func foodsCount() -> Int {
        self.foods.count
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        getCell(collectionView: collectionView, indexPath: indexPath)
    }
}

// MARK: - AddFoodViewController Interface

extension AddFoodViewController: AddFoodViewControllerInterface {
    func setFoods(_ foods: [Food]) {
        self.foods = foods
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
        view.selectedButtonType = .frequent
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
        button.setTitle(R.string.localizable.addFoodCreate(), .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.imageView.tintColor = R.color.foodViewing.basicGrey()
        button.aspectRatio()
        return button
    }
    
    func getScanButton() -> VerticalButton {
        let button = VerticalButton()
        button.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        button.setImage(R.image.addFood.tabBar.scan(), .normal)
        button.setTitle(R.string.localizable.addFoodScan(), .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        button.imageView.tintColor = R.color.foodViewing.basicGrey()
        return button
    }
    
    func getCaloriesButton() -> VerticalButton {
        let button = VerticalButton()
        button.addTarget(self, action: #selector(didTapCalorieButton), for: .touchUpInside)
        button.setImage(R.image.addFood.tabBar.calories(), .normal)
        button.setTitle(R.string.localizable.kcal(), .normal)
        button.setTitleColor(R.color.addFood.recipesCell.basicGray(), .normal)
        button.titleLabel.font = R.font.sfProDisplaySemibold(size: 9)
        button.titleLabel.textAlignment = .center
        button.aspectRatio()
        return button
    }
    
    func getMenuCreateView() -> MenuView<FoodCreate> {
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
        view.backgroundColor = R.color.keyboardLightColor()
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
    
    func getDoneButton() -> UIButton {
        let button = UIButton()
        button.isHidden = true
        button.contentMode = .right
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        button.backgroundColor = R.color.foodViewing.basicPrimary()
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.setTitle(R.string.localizable.addFoodDone(), for: .normal)
        button.titleLabel?.font = R.font.sfProDisplaySemibold(size: 18)
        return button
    }
}
