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
}

final class AddFoodViewController: UIViewController {
    var presenter: AddFoodPresenterInterface?
    var flag = false
    
    private let menuView = MenuView(Const.menuModels)
    private let menuTypeSecondView = ContextMenuTypeSecondView(Const.menuTypeSecondModels)
    private let menuButton = MenuButton()
    private let searshTextField = SearchTextField()
    
    private lazy var segmentedControl: SegmentedControl<AddFood> = {
        let view = SegmentedControl<AddFood>(Const.segmentedModels)
        view.backgroundColor = R.color.addFood.menu.background()
        return view
    }()
    
    private lazy var segmentedScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        return layout
    }()
    
    private lazy var tabBarStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.addFood.tabBar.chevronLeft(), for: .normal)
        button.aspectRatio()
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.addFood.tabBar.pencil(), for: .normal)
        button.setTitle("CREATE", for: .normal)
        button.aspectRatio()
        return button
    }()
    
    private lazy var keyboardHeaderView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = .topCorners
        view.backgroundColor = .gray
        view.layer.cornerRadius = 32
        return view
    }()
    
    private var contentViewBottomAnchor: NSLayoutConstraint?
    private var searchTextFieldBottomAnchor: NSLayoutConstraint?
    
    private var isSelectedType: AddFood = .recent {
        didSet {
            presenter?.setFoodType(isSelectedType)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        menuButton.configure(Const.menuModels.first)
        menuButton.completion = { complition in
            self.menuView.showAndCloseView(true)
            self.menuView.complition = { model in
                complition(model)
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
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func addSubviews() {
        tabBarStackView.addArrangedSubview(createButton)
        tabBarStackView.addArrangedSubview(backButton)
        segmentedScrollView.addSubview(segmentedControl)
        view.addSubviews(
            tabBarStackView,
            collectionView,
            keyboardHeaderView,
            searshTextField,
            menuButton,
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
            make.top.equalTo(menuButton.snp.top)
            make.leading.equalTo(menuButton.snp.leading)
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
            make.top.equalTo(segmentedScrollView.snp.bottom).offset(4)
            make.bottom.equalTo(tabBarStackView.snp.top)
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
}

// MARK: - CollectionView Delegate

extension AddFoodViewController: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension AddFoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch isSelectedType {
        case .frequent:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .recent:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .favorites:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .myMeals:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .myRecipes:
            let cell: RecipesColectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .myFood:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
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
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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
        
    }
    
    func setProducts(_ products: [Product]) {
        
    }
    
    func setMeals(_ meals: [Meal]) {
        
    }
}

// MARK: - Const

extension AddFoodViewController {
    private struct Const {
        static let menuModels: [MenuView.MenuCellViewModel] = [
            .init(title: "BREAKFAST", image: R.image.addFood.menu.breakfast()),
            .init(title: "LUNCH", image: R.image.addFood.menu.lunch()),
            .init(title: "DINNER", image: R.image.addFood.menu.dinner()),
            .init(title: "SNACK", image: R.image.addFood.menu.snack())
        ]
        
        static let menuTypeSecondModels: [ContextMenuTypeSecondView.MenuCellViewModel] = [
            .init(title: "Off", color: .yellow),
            .init(title: "Carbohydrates", color: .green),
            .init(title: "Protein", color: .blue),
            .init(title: "Fat", color: .cyan)
        ]
        
        static let segmentedModels: [SegmentedButton<AddFood>.Model] = [
            .init(
                title: AddFood.frequent.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .frequent
            ),
            .init(
                title: AddFood.recent.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .recent
            ),
            .init(
                title: AddFood.favorites.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .favorites
            ),
            .init(
                title: AddFood.myMeals.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myMeals
            ),
            .init(
                title: AddFood.myRecipes.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myRecipes
            ),
            .init(
                title: AddFood.myFood.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myFood
            )
        ]
    }
}

enum AddFood {
    case frequent
    case recent
    case favorites
    case myMeals
    case myRecipes
    case myFood
    
    func getTitle() -> String {
        switch self {
        case .frequent:
            return "Frequent"
        case .recent:
            return "Recent"
        case .favorites:
            return "Favorites"
        case .myMeals:
            return "My Meals"
        case .myRecipes:
            return "My Recipes"
        case .myFood:
            return "My Food"
        }
    }
}
