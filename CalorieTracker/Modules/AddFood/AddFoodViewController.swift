//
//  AddFoodViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

// swiftlint:disable file_length
protocol AddFoodViewControllerInterface: AnyObject {
    func setFoods(_ foods: [Food])
    func getFoodInfoType() -> FoodInfoCases
    func updateState(for state: AddFoodVCState)
    func setSearchField(to text: String)
    func updateSelectedFoodFromSearch(_ food: Food)
    func updateSelectedFoodFromCustomEntry(_ food: Food)
    func getMealTime() -> MealTime?
    func realoadCollectionView()
}

// swiftlint:disable:next type_body_length
final class AddFoodViewController: UIViewController {
    var presenter: AddFoodPresenterInterface?
    var keyboardManager: KeyboardManagerProtocol?
    
    // MARK: - Private Propertys
    
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
    private lazy var microphoneButton: MicrophoneButton = getMicrophoneButton()
    private lazy var doneButton: UIButton = getDoneButton()
    private lazy var titleLabelFromMealSearch: UILabel = getTitleLabelFromMealSearch()
    private lazy var bottomCloseButton: UIButton = getBottomCloseButton()
    
    private lazy var bottomGradientView = UIView()
    private lazy var bottomGradientViewExtended: GradientUndercover =  {
        let view = GradientUndercover(
            with: [.white, .white.withAlphaComponent(0)],
            axis: .vertical(.bottom),
            locations: [0.7, 1]
        )
        return view
    }()
    private lazy var menuMealView = MenuView(Const.menuModels, shouldShowTitleLabel: false)
    private lazy var menuNutrientView = ContextMenuTypeSecondView(Const.menuTypeSecondModels)
    private lazy var menuButton = MenuButton<MealTime>()
    private lazy var staticSearchTextField: SearchView = {
        let view = SearchView()
        view.turnOffTextFieldInteractions()
        view.isStatic = true
        return view
    }()
    private lazy var actualSearchTextField: SearchView = {
        let view = SearchView()
        return view
    }()
    private lazy var foodCollectionViewController = FoodCollectionViewController()
    private lazy var searchHistoryViewController = SearchHistoryViewController()
    private lazy var counterKcalControl = CounterKcalControl()
    private let addToEatenButton = AddFoodFromBufferButton()
    
    private var menuMealController: BAMenuController?
    private var menuCreateController: BAMenuController?
    private var menuNutrientController: BAMenuController?
    
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
    private var foods: [Food] = [] {
        didSet {
            if foods.isEmpty {
                UIView.animate(withDuration: 0.3) {
                    self.infoButtonsView.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.infoButtonsView.alpha = 1
                }
            }
        }
    }
    
    private var selectedFood: [Food]? {
        didSet {
            didChangeSelectedFood()
        }
    }
    
    private var isSelectedType: AddFood = .recent {
        didSet {
            if oldValue != isSelectedType && oldValue != .search {
                previousSelectedType = oldValue
            }
            foodCollectionViewController.shouldShowNothingFound = isSelectedType == .search ? true : false
            self.foodCollectionViewController.isSelectedType = self.isSelectedType
            presenter?.setFoodType(isSelectedType)
           
        }
    }
    
    private var selectedFoodInfo: FoodInfoCases = .off {
        didSet {
            foodCollectionViewController.reloadData()
        }
    }
    
    private var previousSelectedType: AddFood?
    
    private var state: AddFoodVCState = .default {
        didSet {
            didChangeState(shouldAnimate: oldValue != state)
        }
    }
    
    private var searchFieldYCoordinate: CGFloat
    private var isFirstAppear = true
    var mealTime: MealTime = .breakfast
    var tabBarIsHidden = false
    var searchText: String?
    var wasFromMealCreateVC: Bool = false {
        didSet {
            wasFromMealCreateVC ? changeSegmentControl() : ()
        }
    }
    
    init(searchFieldYCoordinate: CGFloat) {
        self.searchFieldYCoordinate = searchFieldYCoordinate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHandlers()
        addSubviews()
        setupConstraints()
        didChangeState()
        addTapToHideKeyboardGesture()
        transitioningDelegate = self
        suggestMealTime()
    }
    
    private func suggestMealTime() {
        var mealTime: MealTime = .breakfast
        let date = Date()
        var mealIndex: Int = 0
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        if
            let hours = components.hour,
            let minutes = components.minute {
            switch (hours, minutes) {
            case (4...11, 0...59), (12, 0):
                mealTime = .breakfast
                mealIndex = 0
            case (12, 1), (12...15, 0...59), (16, 0) :
                mealTime = .launch
                mealIndex = 1
            case (22, 0), (18...21, 0...59):
                mealTime = .dinner
                mealIndex = 2
            default:
                mealTime = .snack
                mealIndex = 3
            }
        }
        self.mealTime = mealTime
        
        menuMealView.selectCell(at: mealIndex)
        menuButton.configure(mealTime)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw,
               keyboardHeaderView.frame != .zero
        else { return }
        
        setupShadow()
        configureKeyboardManager()
        menuMealController?.anchorPoint = menuButton.frame.origin
        menuNutrientController?.anchorPoint = CGPoint(
            x: infoButtonsView.frame.maxX - 45,
            y: infoButtonsView.frame.origin.y
        )
        menuCreateController?.anchorPoint = CGPoint(
            x: (view.frame.width - Const.menuCreateViewWidth) / 2.0,
            y: staticSearchTextField.frame.maxY
        )
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        guard !isFirstAppear else {
            isFirstAppear.toggle()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.presenter?.setFoodType(self.isSelectedType)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        turnOffSpeechRecognitionIfNeed()
    }
    
    // MARK: - Private functions
    
    private func turnOffSpeechRecognitionIfNeed() {
        if microphoneButtonSelected {
            didTapMicrophoneButton()
        }
    }
    
    private func setupView() {
        presenter?.setFoodType(.recent)
        
        view.backgroundColor = .white
        foodCollectionViewController.view.backgroundColor = .white
        
        staticSearchTextField.textField.keyboardAppearance = .light
        staticSearchTextField.textField.keyboardType = .webSearch
        staticSearchTextField.placeholderText = R.string.localizable.addFoodPlaceholder()
    
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
        let recognier = UITapGestureRecognizer(target: self, action: #selector(showSearchHeader))
        staticSearchTextField.addGestureRecognizer(recognier)
        
        tabBarStackView.isHidden = tabBarIsHidden
        titleLabelFromMealSearch.text = searchText
        menuButton.isHidden = tabBarIsHidden
    }
    
    // swiftlint:disable:next function_body_length
    private func setupHandlers() {
        addToEatenButton.addAction(
            UIAction { [weak self] _ in
                Vibration.success.vibrate()
                guard let mealTime = self?.mealTime else {
                    return
                }
                LoggingService.postEvent(event: .diaryfoodadded(count: self?.selectedFood?.count ?? 0))
                self?.presenter?.saveMeal(mealTime, foods: self?.selectedFood ?? [])
                DispatchQueue.main.async {
//                    self?.selectedFood = []
//                    self?.presenter?.setFoodType(self?.previousSelectedType ?? .recent)
                    self?.presenter?.didTapBackButton(shouldShowReview: true)
                }
            },
            for: .touchUpInside
        )
        
        actualSearchTextField.didBeginEditing = { [weak self] text in
            Vibration.selection.vibrate()
            guard let self = self else { return }
            self.isSelectedType = .search

            guard !text.isEmpty && text.count > 2 else {
                if self.state != .search(.recent) {
                    self.state = .search(.recent)
                }
                return
            }
            self.createTimer()
        }
        
        actualSearchTextField.didChangeValue = { [weak self] text in
            guard let self = self else { return }
            guard !text.isEmpty && text.count > 2 else {
                self.staticSearchTextField.text = text
                if self.state != .search(.recent) {
                    self.state = .search(.recent)
                }
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            
            self.staticSearchTextField.textField.text = text
            self.createTimer()
        }
        
        staticSearchTextField.didChangeValue = { [weak self] text in
            self?.actualSearchTextField.text = text
            if text == "" {
                self?.state = .search(.recent)
            }
        }
        
        actualSearchTextField.didEndEditing = { text in
            guard !text.isEmpty else {
                self.isSelectedType = self.previousSelectedType ?? .recent
                if self.state == .search(.recent) {
                    self.staticSearchTextField.endEditing(true)
                    return
                } else {
                    self.staticSearchTextField.endEditing(true)
                    self.state = .default
                    return
                }
            }
            self.staticSearchTextField.endEditing(true)
            self.staticSearchTextField.text = text
            FDS.shared.rememberSearchQuery(text)
        }
        
        menuMealController = .init(menuMealView, width: Const.menuMealViewWidth)
        menuCreateController = .init(menuCreateView, width: Const.menuCreateViewWidth)
        menuNutrientController = .init(menuNutrientView, width: Const.menulNutrientViewWidth)
        
        menuButton.configure(mealTime)
        menuButton.completion = { [weak self] complition in
            self?.showMealMenu()
            self?.menuMealView.complition = { model in
                self?.mealTime = model
                complition(model)
            }
        }
        
        menuNutrientController?.didClose = {
            self.infoButtonsView.tryToShowView(at: 0)
        }
        
        infoButtonsView.completion = { [weak self] complition in
            self?.showNutrientMenu()
            self?.menuNutrientView.complition = { model in
                switch model {
                case .carb, .fat, .kcal, .protein:
                    complition(.configurable(model))
                case .off:
                    complition(.settings)
                }
                UIView.animate(withDuration: 0.3) {
                    self?.infoButtonsView.tryToShowView(at: 0)
                }
                self?.selectedFoodInfo = model
            }
        }
        
        segmentedControl.onSegmentChanged = { model in
            self.isSelectedType = model.id
            
            switch model.id {
            case .frequent, .recent, .favorites:
                self.infoButtonsView.isHidden = false
                self.updateCollectionViewTopOffsetPoint(model.id)
            case .myRecipes, .myFood:
                self.infoButtonsView.isHidden = true
                self.updateCollectionViewTopOffsetPoint(model.id)
            case .myMeals:
                self.infoButtonsView.isHidden = true
                self.updateCollectionViewTopOffsetPoint(model.id)
            case .search:
                break
            }
        }
        
        searchHistoryViewController.complition = { [weak self] search in
            self?.actualSearchTextField.text = search
            self?.staticSearchTextField.text = search
            self?.didEndTimer()
        }
        
        menuCreateController?.didClose = {
            self.presenter?.createFood()
        }
        menuCreateView.complition = { type in
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
        
        keyboardHeaderView.addSubviews(hideKeyboardButton, actualSearchTextField)
        segmentedScrollView.addSubview(segmentedControl)
        view.addSubviews(
            tabBarStackView,
            foodCollectionViewController.view,
            searchHistoryViewController.view,
            menuButton,
            titleLabelFromMealSearch,
            infoButtonsView,
            segmentedScrollView,
            counterKcalControl,
            bottomGradientViewExtended,
            bottomGradientView,
            microphoneButton,
            keyboardHeaderView,
            staticSearchTextField,
//            doneButton,
            addToEatenButton,
            bottomCloseButton
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        let widget = CTWidgetNode(with: .init(type: .compact))
        let inset = widget.constants.suggestedTopSafeAreaOffset
        let interIteminset = widget.constants.suggestedInterItemSpacing
        let sideInset = widget.constants.suggestedSideInset
        let height = widget.constants.height
        searchTextFieldBottomAnchor = staticSearchTextField.bottomAnchor.constraint(
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
            make.height.equalTo(64)
        }
        
        collectionViewTopSecondAnchor = foodCollectionViewController
            .view
            .topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        foodCollectionViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoButtonsView.snp.bottom).offset(4).priority(.low)
            make.bottom.equalTo(staticSearchTextField.snp.top)
        }
        
        searchHistoryViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoButtonsView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(segmentedScrollView.snp.bottom).offset(16)
        }
        
        staticSearchTextField.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.bottom.equalTo(tabBarStackView.snp.top).offset(-12).priority(.low)
            make.trailing.equalTo(microphoneButton.snp.leading).inset(-interIteminset)
            make.top.equalToSuperview().offset(searchFieldYCoordinate)
            make.leading.equalToSuperview().offset(sideInset)
        }
        
        microphoneButton.aspectRatio()
//        microphoneButton.snp.makeConstraints { make in
//            make.width.height.equalTo(staticSearchTextField.snp.height)
////            make.trailing.equalToSuperview().offset(-20)
////            make.leading.equalTo(searchTextField.snp.trailing).offset(12)
//            make.trailing.equalToSuperview().inset(Constants.searchFieldSideInset)
//            make.bottom.equalTo(staticSearchTextField)
//        }
        
        keyboardHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(staticSearchTextField).offset(40)
        }
        
        hideKeyboardButton.aspectRatio()
        hideKeyboardButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        actualSearchTextField.snp.makeConstraints { make in
            make.top.bottom.equalTo(hideKeyboardButton)
            make.leading.equalTo(hideKeyboardButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(204)
        }
        
        bottomGradientViewExtended.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(393)
            make.top.equalTo(keyboardHeaderView).offset(-25)
        }
        
        counterKcalControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
//        doneButtonWidthAnchor = doneButton
//            .widthAnchor
//            .constraint(equalTo: view.widthAnchor, multiplier: 0.71)
//        doneButton.snp.makeConstraints { make in
//            make.trailing.equalTo(microphoneButton)
//            make.bottom.top.equalTo(searchTextField)
//            make.leading.greaterThanOrEqualTo(searchTextField.snp.trailing).offset(12)
//            make.width.equalTo(0).priority(.low)
//        }
        
        microphoneButton.snp.remakeConstraints { make in
            make.trailing.equalTo(addToEatenButton.snp.leading)
            make.width.height.equalTo(staticSearchTextField.snp.height)
            //            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(addToEatenButton)
        }
        
        addToEatenButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(sideInset)
            make.width.equalTo(0)
            make.height.equalTo(microphoneButton.snp.height)
            make.top.equalTo(searchFieldYCoordinate)
        }
        
        addToEatenButton.alpha = 0
        
        titleLabelFromMealSearch.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(81)
            make.bottom.equalTo(segmentedControl.snp.top).offset(-16)
        }
        
        bottomCloseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.155)
        }
    }
    
    private func updateCollectionViewTopOffsetPoint(_ foodType: AddFood) {
        switch foodType {
        case .frequent, .recent, .favorites, .myRecipes, .myFood, .search:
            foodCollectionViewController.view.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(infoButtonsView.snp.bottom).offset(4).priority(.low)
                make.bottom.equalTo(staticSearchTextField.snp.top)
            }
    
        case .myMeals:
            foodCollectionViewController.view.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(segmentedScrollView.snp.bottom).offset(19).priority(.low)
                make.bottom.equalTo(staticSearchTextField.snp.top)
            }
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
        
//        bottomGradientViewExtended.layer.addSublayer(
//            GradientLayer(
//                .init(
//                    bounds: bottomGradientView.bounds,
//                    colors: [.white, .white.withAlphaComponent(0)],
//                    axis: .vertical(.bottom),
//                    locations: [0.7, 1]
//                )
//            )
//        )
    }
    
    private func changeSegmentControl() {
        segmentedControl = SegmentedControl<AddFood>(
            Const.segmentedModels.filter({
                $0.title != "My Meals" })
        )
        
        segmentedControl.backgroundColor = UIColor(hex: "E4FFF7")
        segmentedControl.font = R.font.sfProTextSemibold(size: 16)
        segmentedControl.selectedButtonType = .recent
    }
    
    private func showMealMenu() {
        guard let menuMealController = menuMealController else {
            return
        }

        present(menuMealController, animated: true)
    }
    
    private func showCreateMenu() {
        guard let menuCreateController = menuCreateController else {
            return
        }

        present(menuCreateController, animated: true)
    }
    
    private func showNutrientMenu() {
        guard let menuNutrientController = menuNutrientController else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.infoButtonsView.tryToHideView(at: 0)
        }
        present(menuNutrientController, animated: true)
    }
    
    private func getCell(collectionView: UICollectionView,
                         indexPath: IndexPath) -> UICollectionViewCell {
        switch isSelectedType {
        case .frequent, .recent, .favorites, .search:
            let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let food = foods[safe: indexPath.row]
            var finalFoodModel: Food?
            if let selectedFood = selectedFood,
               selectedFood.contains(food!) {
                if isSelectedType == .search {
                    finalFoodModel = selectedFood.first(where: { $0.foodDataId == food?.foodDataId }) ?? food
                } else {
                    finalFoodModel = food
                }
            } else {
                finalFoodModel = food
            }
            let foodPlaceholder: Food = .customEntry(
                .init(title: "", nutrients: .init(kcal: 0, carbs: 0, proteins: 0, fats: 0), mealTime: .breakfast)
            )
            cell.viewModel = .init(
                cellType: .table,
                food: finalFoodModel,
                buttonType: (selectedFood ?? [])
                    .contains(food ?? foodPlaceholder) && state != .default
                ? .delete
                : wasFromMealCreateVC ? .addToMeal : .add,
                subInfo: presenter?.getSubInfo(food, selectedFoodInfo),
                colorSubInfo: selectedFoodInfo.getColor()
            )
            cell.didTapButton = { [weak self] food, buttonType in
                switch buttonType {
                case .delete:
                    self?.selectedFood?.removeAll(where: { $0.id == food.id })
                case .add:
                    self?.selectedFood = (self?.selectedFood ?? []) + [food]
                    LoggingService.postEvent(event: .diaryquickadd)
                case .addToMeal:
                    self?.presenter?.dismissToCreateMeal(with: food)
                }
                
                DispatchQueue.main.async {
                    FDS.shared.foodUpdate(food: food, favorites: false)
                }
            }
            
            let frame = view.convert(infoButtonsView.getInfoButtonFrame(), from: infoButtonsView)
            let targetFrame = cell.convert(frame, from: view)
            cell.infoCenterX = targetFrame.midX
            return cell
        case .myMeals:
            let cell: MealsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let food = foods[indexPath.item]
            if case .meal(let meal) = food {
                cell.meal = meal
                cell.editMealButton.addTarget(self, action: #selector(editMealButtonTapped), for: .touchUpInside)
                
                cell.didTapButton = { [weak self] buttonType in
                    switch buttonType {
                    case .delete:
                        self?.selectedFood?.removeAll(where: { $0.id == meal.id })
                    case .add:
                        self?.selectedFood = (self?.selectedFood ?? []) + [.meal(meal)]
                        LoggingService.postEvent(event: .diaryaddfooditem)
                    }
                }
            }
            
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
            cell.didTapButton = { food, buttonType in
                if buttonType == .add {
                    self.selectedFood = (self.selectedFood ?? []) + [food]
                } else {
                    self.selectedFood?.removeAll(where: { $0.id == food.id })
                }
            }
            return cell
        }
    }
    
    private func didChangeSelectedFood() {
        guard let selectedFood = selectedFood, !selectedFood.isEmpty else {
            UIView.animate(withDuration: 0.3) {
                self.counterKcalControl.isHidden = true
            }
            showDoneButton(false)
            updateCounterAppearanceIfNeeded()
            return
        }
        updateCounterAppearanceIfNeeded()
        let sumKcal = selectedFood.compactMap { $0.foodInfo[.kcal] }.sum()
        counterKcalControl.isHidden = false
        showDoneButton(true)
        counterKcalControl.configure(.init(
            kcal: sumKcal,
            count: selectedFood.count
        ))
    }
    
    private func didChangeState(shouldAnimate: Bool = true) {
        switch self.state {
        case .search(let state):
            switch state {
            case .recent:
                setupSearchRecentState()
            case .noResults:
                setupSearchFoundResultsState()
                foodCollectionViewController.shouldShowNothingFound = true
            case .foundResults:
                setupSearchFoundResultsState(shouldAnimate: shouldAnimate)
            }
            showDoneButton(false)
            LoggingService.postEvent(event: .diarysearch)
        case .default:
            menuButton.alpha = 1
            showDoneButton((selectedFood ?? []).isEmpty ? false : true)
            setupDefaultState()
        }
    }
    
    private func setupDefaultState() {
        collectionViewTopSecondAnchor?.isActive = false
        
        view.sendSubviewToBack(tabBarStackView)
        view.sendSubviewToBack(staticSearchTextField)
        view.sendSubviewToBack(microphoneButton)
        view.sendSubviewToBack(bottomGradientView)
        if isFirstAppear {
            view.sendSubviewToBack(searchHistoryViewController.view)
        }
        
        view.sendSubviewToBack(foodCollectionViewController.view)
        view.sendSubviewToBack(keyboardHeaderView)
        foodCollectionViewController.shouldShowNothingFound = false
        UIView.animate(withDuration: 0.3) {
            self.searchHistoryViewController.view.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            if !self.isFirstAppear {
                self.view.sendSubviewToBack(self.searchHistoryViewController.view)
            }
        }
    }
    
    private func setupSearchRecentState() {
        searchHistoryViewController.view.alpha = 0
        searchHistoryViewController.view.isHidden = false
        view.bringSubviewToFront(searchHistoryViewController.view)
        view.bringSubviewToFront(bottomGradientView)
        view.bringSubviewToFront(keyboardHeaderView)
        view.bringSubviewToFront(staticSearchTextField)
        view.bringSubviewToFront(microphoneButton)
        view.bringSubviewToFront(tabBarStackView)
        UIView.animate(withDuration: 0.3) {
            self.searchHistoryViewController.view.alpha = 1
        }
    }
    
    private func setupSearchFoundResultsState(shouldAnimate: Bool = true) {
        if shouldAnimate {
            foodCollectionViewController.view.alpha = 0
        }
        
        menuButton.alpha = 0
      
        collectionViewTopSecondAnchor?.isActive = true
        if shouldAnimate {
            UIView.animate(withDuration: 0.3) {
                self.searchHistoryViewController.view.alpha = 0
                self.foodCollectionViewController.view.alpha = 1
            }
        }
        view.bringSubviewToFront(foodCollectionViewController.view)
        view.bringSubviewToFront(bottomGradientView)
        view.bringSubviewToFront(bottomGradientViewExtended)
        view.bringSubviewToFront(keyboardHeaderView)
        view.bringSubviewToFront(staticSearchTextField)
        view.bringSubviewToFront(microphoneButton)
        view.bringSubviewToFront(tabBarStackView)
       
    }
    
    private func showDoneButton(_ flag: Bool) {
        addToEatenButton.updateCount(to: selectedFood?.count ?? 0)
        let widget = CTWidgetNode(with: .init(type: .compact))
        let inset = widget.constants.suggestedTopSafeAreaOffset
        let interIteminset = widget.constants.suggestedInterItemSpacing
        let sideInset = widget.constants.suggestedSideInset
        let height = widget.constants.height
        if flag {
            if case .search = state {
                return
            }
            
            staticSearchTextField.text = ""
            staticSearchTextField.placeholderText = ""
          
            staticSearchTextField.textField.endEditing(true)

            staticSearchTextField.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(sideInset)
                make.height.equalTo(height)
                make.width.equalTo(staticSearchTextField.snp.height).multipliedBy(1)
//                make.bottom.lessThanOrEqualTo(keyboardHeaderView.snp.bottom).offset(-20)
                make.bottom.equalTo(tabBarStackView.snp.top).offset(-12).priority(.low)
            }
            
            microphoneButton.snp.makeConstraints { make in
                make.leading.equalTo(staticSearchTextField.snp.trailing).offset(12)
                make.height.equalTo(addToEatenButton)
                make.top.equalTo(addToEatenButton)
                make.width.equalTo(height)
                make.trailing.equalTo(addToEatenButton.snp.leading).inset(-12)
            }
            
            addToEatenButton.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().inset(20)
                make.top.equalTo(staticSearchTextField)
                make.height.equalTo(microphoneButton.snp.height)
            }
            
        } else {
            staticSearchTextField.placeholderText = R.string.localizable.addFoodPlaceholder()
            staticSearchTextField.snp.remakeConstraints { make in
                make.height.equalTo(height)
                make.bottom.equalTo(tabBarStackView.snp.top).offset(-12).priority(.low)
                make.trailing.equalTo(microphoneButton.snp.leading).inset(-interIteminset)
                make.top.equalToSuperview().offset(searchFieldYCoordinate)
                make.leading.equalToSuperview().offset(sideInset)
            }
            
            addToEatenButton.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().inset(sideInset)
                make.width.equalTo(0)
                make.height.equalTo(microphoneButton.snp.height)
                make.top.equalTo(searchFieldYCoordinate)
            }
            
            microphoneButton.snp.remakeConstraints { make in
                make.trailing.equalTo(addToEatenButton.snp.leading)
                make.width.height.equalTo(staticSearchTextField.snp.height)
                //            make.trailing.equalToSuperview().offset(-20)
                make.bottom.equalTo(addToEatenButton)
            }
        }
        addToEatenButton.setNeedsDisplay()
      
        UIView.animate(withDuration: 0.25) {
            if !self.firstDraw {
                self.view.layoutIfNeeded()
            }
            if flag {
                self.addToEatenButton.alpha = 1
            } else {
                self.addToEatenButton.alpha = 0
            }
        }
    }
    
    private func createTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.3,
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
    
    private func updateCounterAppearanceIfNeeded(shouldAnimate: Bool = false) {
        if case .search(let extraState) = state {
            if extraState == .foundResults {
                if selectedFood?.isEmpty ?? true {
                    self.collectionViewTopSecondAnchor?.constant = 0
                    UIView.animate(withDuration: 0.3) {
                        self.counterKcalControl.alpha = 0
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        self.menuButton.alpha = 1
                    }
                } else {
                    self.collectionViewTopSecondAnchor?.constant = 50
                    self.menuButton.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        self.counterKcalControl.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc private func showSearchHeader() {
        actualSearchTextField.textField.becomeFirstResponder()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
        presenter?.stopSearchQuery()
        state = .default
        isSelectedType = previousSelectedType ?? .recent
        staticSearchTextField.text = ""
        actualSearchTextField.text = ""
        staticSearchTextField.state = .largeNotEdit
    }
    
    @objc private func didTapBackButton() {
        Vibration.rigid.vibrate()
        guard state == .default else {
            state = .default
            presenter?.setFoodType(previousSelectedType ?? .recent)
            segmentedControl.selectedButtonType = previousSelectedType
            staticSearchTextField.text = ""
            staticSearchTextField.state = .largeNotEdit
            actualSearchTextField.text = ""
            return
        }
        presenter?.didTapBackButton(shouldShowReview: false)
    }
    
    @objc private func didTapCreateButton() {
        Vibration.rigid.vibrate()
        showCreateMenu()
    }
    
    @objc private func didTapCalorieButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapCalorieButton(mealTime: mealTime)
    }
    
    @objc private func didTapScanButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapScannerButton()
    }
    
    @objc private func didEndTimer() {
        guard let searchText = actualSearchTextField.text, !searchText.isEmpty else { return }
        presenter?.search(searchText, complition: { flag in
            self.state = flag ? .search(.foundResults) : .search(.noResults)
        })
    }
    
    @objc private func didTapCounterControl() {
        Vibration.rigid.vibrate()
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
        microphoneButton.isSelected = !microphoneButton.isSelected
        switch microphoneButtonSelected {
        case true:
            state = .search(.foundResults)
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
                            staticSearchTextField.text = text
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
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapCloseButton()
    }
    
    @objc private func editMealButtonTapped(sender: UIButton) {
        Vibration.rigid.vibrate()
        var view = sender.superview
        while view != nil && !(view is MealsCollectionViewCell) {
            view = view?.superview
        }

        if let cell = view as? MealsCollectionViewCell,
           let meal = cell.meal {
            presenter?.openEditMeal(meal: meal)
        }
    }
}

// MARK: - FoodCollectionViewController Delegate

extension AddFoodViewController: FoodCollectionViewControllerDelegate {
    func didSelectCell(_ type: Food) {
        Vibration.selection.vibrate()
        presenter?.didTapCell(type)
    }
}

// MARK: - FoodCollectionViewController DataSource

extension AddFoodViewController: FoodCollectionViewControllerDataSource {
    func foodsOverAll() -> [Food] {
        foods
    }
    
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
    
    func getMealTime() -> MealTime? {
        self.mealTime
}

    func updateState(for state: AddFoodVCState) {
        self.state = state
    }
    
    func setSearchField(to text: String) {
        staticSearchTextField.text = text
    }
    
    func updateSelectedFromCustomEntry(_ food: Food) {
        selectedFood = (selectedFood ?? []) + [food]
        foodCollectionViewController.reloadData()
    }
    
    func updateSelectedFoodFromSearch(_ food: Food) {
        if isSelectedType == .search {
            LoggingService.postEvent(event: .diaryaddfromsearch)
        }
        isSelectedType = previousSelectedType ?? .recent
        selectedFood = (selectedFood ?? []) + [food]
        foodCollectionViewController.reloadData()
    }
    
    func updateSelectedFoodFromCustomEntry(_ food: Food) {
        selectedFood = (selectedFood ?? []) + [food]
        state = .default
        foodCollectionViewController.reloadData()
    }
    
    func realoadCollectionView() {
        foodCollectionViewController.mealCellsHeight = Array(
            repeating: 104,
            count: FDS.shared.getAllMeals().count
        )
        
//        presenter?.setFoodType(.myMeals)
        foodCollectionViewController.reloadData()
    }
}

// MARK: - Factory

private extension AddFoodViewController {
    func getSegmentedControl() -> SegmentedControl<AddFood> {
        let view = SegmentedControl<AddFood>(Const.segmentedModels)
        view.backgroundColor = UIColor(hex: "E4FFF7")
        view.font = R.font.sfProTextSemibold(size: 16)
        view.selectedButtonType = .recent
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
        button.setTitle(R.string.localizable.kcal().uppercased(), .normal)
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
    
    func getKeyboardHeaderView() -> RecipesSearchFooter {
        let view = RecipesSearchFooter()
        view.hideRecipeSearchElements()
        return view
    }
    
    func getHideKeyboardButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.addFood.tabBar.chevronLeft(), for: .normal)
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
    
    func getMicrophoneButton() -> MicrophoneButton {
        let button = MicrophoneButton()
        button.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
//        let button = UIButton()
//        button.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
//        button.setImage(R.image.addFood.menu.micro(), for: .normal)
//        button.backgroundColor = UIColor(hex: "B3EFDE")
//        button.imageView?.tintColor = R.color.addFood.menu.isSelectedBorder()
//        button.layer.cornerRadius = 16
//        button.layer.borderWidth = 1
//        button.layer.borderColor = R.color.addFood.menu.isSelectedBorder()?.cgColor
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
    
    func getTitleLabelFromMealSearch() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 20)
        label.textColor = R.color.createMeal.basicPrimary()
        label.isHidden = tabBarIsHidden ? false : true
        return label
    }
    
    func getBottomCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.isHidden = tabBarIsHidden ? false : true
        return button
    }
}

extension AddFoodViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
//        AddFoodAppearingTransitionController()
        return nil
    }
    
    func setToStartTransitionState() {
        staticSearchTextField.alpha = 0
        microphoneButton.alpha = 0
    }
    
    func setToEndTransitionState() {
//        UIView.animate(withDuration: 0.1) {
            self.staticSearchTextField.alpha = 1
            self.microphoneButton.alpha = 1
//        }
    }
    
    func getCurrentSearchFieldFrame() -> CGRect {
        staticSearchTextField.layoutIfNeeded()
        return staticSearchTextField.frame
    }
    
    func getCurrentSearchFieldSnapshot() -> UIView {
        staticSearchTextField.layoutIfNeeded()
        let view = UIImageView(image: staticSearchTextField.snapshotNewView(scale: 0, isOpaque: false))
        return view
    }
    
    func getCurrentMicrophoneButtonSnapshot() -> UIView {
        microphoneButton.layoutIfNeeded()
        let view = UIImageView(image: microphoneButton.snapshotNewView(isOpaque: false))
        return view
    }
    
    func getCurrentMicrophoneButtonFrame() -> CGRect {
        microphoneButton.layoutIfNeeded()
        return microphoneButton.frame
    }
}

extension AddFoodViewController {
    enum Constants {
        static var searchFieldSideInset: CGFloat {
            switch UIDevice.screenType {
            case .h19x430:
                return 20
            case .h19x428:
                return 20
            case .h19x414:
                return 20
            case .h19x393:
                return 18
            case .h19x390:
                return 18
            case .h19x375:
                return 18
            case .h16x414:
                return 20
            case .h16x375:
                return 18
            case .unknown:
                return 20
            }
        }
    }
}
