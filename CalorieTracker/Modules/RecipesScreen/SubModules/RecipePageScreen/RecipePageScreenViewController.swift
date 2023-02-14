//
//  RecipePageScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 12.01.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import AlignedCollectionViewFlowLayout
import UIKit

protocol RecipePageScreenViewControllerInterface: AnyObject {
    func shouldUpdateIngredients(with models: [RecipeIngredientModel])
    func shouldUpdateProgressView(
        carbsData: RecipeRoundProgressView.ProgressMode,
        kcalData: RecipeRoundProgressView.ProgressMode,
        fatData: RecipeRoundProgressView.ProgressMode,
        proteinData: RecipeRoundProgressView.ProgressMode
    )
}

class RecipePageScreenViewController: CTViewController {
    var presenter: RecipePageScreenPresenterInterface?
    var defaultOffset: CGPoint = .zero
    var defaultContentSize: CGSize = .zero
    var backButtonTitle: String
//    private var isFavorite: Bool {
//        UserDefaultsManager.favoritesRecipeIds.contains(viewModel.recipe.id)
//    }
    
    private var tagsHeight: CGFloat {
        return 32
    }
    
    private lazy var tagsCollection: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.estimatedItemSize = AlignedCollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        let collection = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
//        collection.delegate = self
        collection.register(ColorfulTagCell.self, forCellWithReuseIdentifier: ColorfulTagCell.identifier)
        collection.backgroundColor = .clear
        collection.bounces = false
        collection.contentInsetAdjustmentBehavior = .never
        return collection
    }()

    private lazy var header: RecipePageScreenHeader = {
       let header = RecipePageScreenHeader()
        header.setTitle(title: presenter?.getHeaderTitle() ?? "")
        header.setBackButtonTitle(title: backButtonTitle)
        header.delegate = self
        return header
    }()
    
    let containerView = UIView()
    
    let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset.top = 136
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var mainImageView: RecipeMainImageView = {
        let view = RecipeMainImageView()
        view.delegate = self
        return view
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textColor = UIColor(hex: "0C695E")
        label.text = "Ingredients".localized
        return label
    }()
    
    private lazy var servingSelector: RecipeServingSelector = {
       let selector = RecipeServingSelector()
        selector.delegate = self
        return selector
    }()
    
    lazy var ingredientViews: [IngredientView] = {
        var views: [IngredientView] = []
        for ingredientModel in presenter?.getModelsForIngredients() ?? [] {
            let view = IngredientView()
            view.configure(with: ingredientModel)
            views.append(view)
        }
        return views
    }()
    
    let ingredientsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textColor = UIColor(hex: "0C695E")
        label.text = "Instructions".localized
        return label
    }()
    
    private lazy var instructionsViews: [InstructionView] = {
        var views: [InstructionView] = []
        guard let instructions = presenter?.getInstructions() else {
            print("failed to get instructions")
            return []
        }
        print("Instructions are \(instructions)")
        for (index, instruction) in instructions.enumerated() {
            let view = InstructionView()
            view.setStepNumber(num: index + 1)
            view.setInstruction(instruction: instruction)
            views.append(view)
        }
        return views
    }()
    
    let instructionsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var dailyProgressView: RecipeProgressView = {
        let view = RecipeProgressView(
            carbsData: presenter?.getModeForCarbs() ?? .undefined,
            kcalData: presenter?.getModeForKcal() ?? .undefined,
            fatData: presenter?.getModeForFat() ?? .undefined,
            proteinData: presenter?.getModeForProtein() ?? .undefined
        )
        return view
    }()
    
    private let servingCountField = RecipePageServingTextField()
    
    // TODO: - Сделать нормальный селектор как будет дизайн
    private let servingSelectorLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedMedium(size: 22)
        label.textColor = UIColor(hex: "192621")
        label.textAlignment = .left
        label.text = "Serving".localized
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(hex: "B3EFDE").cgColor
        label.layer.cornerRadius = 16
        label.layer.cornerCurve = .continuous
        label.clipsToBounds = true
        label.setMargins(margin: 16)
        return label
    }()
    
    private let addToDiary: RecipeMainGreenGradientButton = {
        let button = RecipeMainGreenGradientButton(type: .system)
        let attrTitle = NSAttributedString(
            string: "Add to diary".localized,
            attributes: [
                .font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
                .foregroundColor: UIColor(hex: "B3EFDE")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        return button
    }()
    
    private let describingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#192621")
        label.textAlignment = .left
        label.font = R.font.sfProTextRegular(size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    init(backButtonTitle: String) {
        self.backButtonTitle = backButtonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubviews()
        configureContent()
        setupActions()
        setupKeyboardObservers()
        setupDelegates()
        presenter?.createFoodData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        header.releaseBlurAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsCollection.reloadData()
        dailyProgressView.animateProgress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        contentScrollView.contentInset.bottom = view.safeAreaInsets.bottom + 10
    }
    
    private func setupDelegates() {
        servingCountField.delegate = self
    }
    
    private func setupAppearance() {
        view.backgroundColor = UIColor(hex: "E5F5F3")
        mainImageView.setIsFavorite(shouldSetFavorite: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillShow(_:)),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil
                )

                // Subscribe to Keyboard Will Hide notifications
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillHide(_:)),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil
                )
    }
    
    @objc private func addToDiaryDidTapped() {
        Vibration.success.vibrate()
        presenter?.addToDiaryTapped()
    }
    
    private func setupActions() {
        addToDiary.addTarget(self, action: #selector(addToDiaryDidTapped), for: .touchUpInside)
    }
    
    private func configureContent() {
        if let dish = presenter?.getDish() {
            mainImageView.setupFor(dish: dish)
            servingSelector.setCountInitially(to: dish.totalServings ?? 0)
            header.setTitle(title: dish.title.uppercased())
            describingLabel.text = dish.description
        }
        mainImageView.setIsFavorite(shouldSetFavorite: presenter?.isFavoritesDish ?? false)
    }
    
    // swiftlint:disable:next function_body_length
    private func setupSubviews() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(containerView)
        containerView.addSubview(tagsCollection)
        containerView.addSubview(mainImageView)
        containerView.addSubview(ingredientsLabel)
        containerView.addSubview(servingSelector)
        containerView.addSubview(ingredientsStack)
        containerView.addSubview(instructionsLabel)
        containerView.addSubview(instructionsStack)
        containerView.addSubview(dailyProgressView)
        containerView.addSubview(servingCountField)
        containerView.addSubview(servingSelectorLabel)
        containerView.addSubview(addToDiary)
        containerView.addSubview(describingLabel)
        
        view.addSubview(header)
        
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(136)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalToSuperview()
        }
        
        tagsCollection.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollection.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(244)
        }
        
        dailyProgressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(mainImageView.snp.bottom).offset(16)
        }
        
        servingCountField.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(112)
            make.leading.equalTo(dailyProgressView)
            make.top.equalTo(dailyProgressView.snp.bottom).offset(16)
        }
        
        servingSelectorLabel.snp.makeConstraints { make in
            make.leading.equalTo(servingCountField.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalTo(servingCountField)
        }
        
        addToDiary.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(servingCountField.snp.bottom).offset(12)
        }
        
        describingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(addToDiary.snp.bottom).offset(32)
        }
        
        ingredientsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(describingLabel.snp.bottom).offset(24)
        }
        
        servingSelector.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(ingredientsLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }

        ingredientsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainImageView)
            make.top.equalTo(servingSelector.snp.bottom).offset(16)
        }
        
        instructionsLabel.snp.makeConstraints { make in
            make.leading.equalTo(ingredientsStack)
            make.top.equalTo(ingredientsStack.snp.bottom).offset(24)
        }
        
        instructionsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainImageView)
            make.top.equalTo(instructionsLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        ingredientViews.forEach {
            ingredientsStack.addArrangedSubview($0)
        }
        
        instructionsViews.forEach {
            instructionsStack.addArrangedSubview($0)
        }
    }
}

extension RecipePageScreenViewController: RecipePageScreenHeaderDelegate {
    func backButtonTapped() {
        dismiss(animated: true)
    }
}
//
extension RecipePageScreenViewController: RecipeMainImageViewDelegate {
    func addToFavoritesTapped(_ flag: Bool) {
        presenter?.addToFavoritesTapped(flag)
    }
    
    func shareButtonTapped() {
        guard
            let id = presenter?.getDish()?.id,
            let url = URL(string: "com.Calorie.tracker://recipe?id=\(id)")
        else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
}

extension RecipePageScreenViewController: RecipePageScreenViewControllerInterface {
    func shouldUpdateProgressView(
        carbsData: RecipeRoundProgressView.ProgressMode,
        kcalData: RecipeRoundProgressView.ProgressMode,
        fatData: RecipeRoundProgressView.ProgressMode,
        proteinData: RecipeRoundProgressView.ProgressMode
    ) {
        dailyProgressView.redrawWithNewData(
            carbsData: carbsData,
            kcalData: kcalData,
            fatData: fatData,
            proteinData: proteinData
        )
    }
    
    func shouldUpdateIngredients(with models: [RecipeIngredientModel]) {
        for (index, model) in models.enumerated() {
            guard index < ingredientViews.count else { return }
            ingredientViews[index].configure(with: model)
        }
    }
}

extension RecipePageScreenViewController: RecipeServingSelectorDelegate {
    func servingChangedTo(count: Int) {
        presenter?.didChangeServing(to: count)
    }
}

extension RecipePageScreenViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let model = presenter?.getTagModel(for: indexPath),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorfulTagCell.identifier,
                for: indexPath
            ) as? ColorfulTagCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.askForNumberOfTags() ?? 0
    }
}

extension RecipePageScreenViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Keayboard handling
extension RecipePageScreenViewController {
    @objc func keyboardWillShow(
        _ notification: NSNotification
    ) {
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        guard let value = notification.userInfo?[frameKey] as? NSValue else {
            return
        }
        defaultOffset = contentScrollView.contentOffset
        defaultContentSize = contentScrollView.contentSize
        let topCoordinate = value.cgRectValue.origin.y
//        let animationDuration = durationValue.timeValue.seconds
        let targetFrame = servingCountField.frame
        contentScrollView.setContentOffset(
            CGPoint(x: 0, y: targetFrame.origin.y - topCoordinate + targetFrame.height),
            animated: true
        )
    }
    
    @objc func keyboardWillHide(
        _ notification: NSNotification
    ) {
        contentScrollView.setContentOffset(defaultOffset, animated: true)
        contentScrollView.contentSize = defaultContentSize
    }
}

extension RecipePageScreenViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let fullText = text + string
        guard let int = Int(fullText),
              int <= 15 else { return false }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            presenter?.didChangeAmountToEat(amount: Int(textField.text ?? "1") ?? 1)
        }
    }
}
