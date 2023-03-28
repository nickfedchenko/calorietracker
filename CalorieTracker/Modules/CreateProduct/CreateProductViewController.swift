//
//  CreateProductViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 11.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol CreateProductViewControllerInterface: AnyObject {
    func getFormValues() -> [CreateProductViewController.ProductFormSegment: String?]
    func getImage() -> UIImage?
    func getBrand() -> String?
    func getBarcode() -> String?
    func getProductName() -> String?
    func getServingDescription() -> String?
    func getServingWeight() -> Double?
}

final class CreateProductViewController: UIViewController {
    var presenter: CreateProductPresenterInterface?
    var keyboardManager: KeyboardManagerProtocol?
    
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var titleFirstPageLabel: UILabel = getTitleLabel()
    private lazy var descriptionFirstPageLabel: UILabel = getDescriptionLabel()
    private lazy var titleSecondPageLabel: UILabel = getTitleLabel()
    private lazy var descriptionSecondPageLabel: UILabel = getDescriptionLabel()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var backButton: UIButton = getBackButton()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var mainScrollView: UIScrollView = getMainScrollView()
    private lazy var leftScrollView: UIScrollView = getScrollView()
    private lazy var rightScrollView: UIScrollView = getScrollView()
    private lazy var nutritionView: NutritionFactsCellView = getNutritionView()
    private lazy var servingSizeView: NutritionFactsCellView = getServingSizeView()
    
    private lazy var imageView: SelectImageView = .init(self)
    private lazy var formsView: FormsView = .init(Const.formModels)
    private lazy var firstPageFormView = FirstPageFormView()
    private lazy var secondPageFormView = SecondPageFormView()
    private lazy var saveButton = BasicButtonView(type: .next)
    
    private var firstDraw = true
    
    private var currentPage: Int = 0 {
        didSet {
            if currentPage == 1 {
                LoggingService.postEvent(event: .diarycreatefoodstep2)
            }
            didChangePage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupFistPageConstraints()
        setupSecondPageConstraints()
        didChangePage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard headerView.frame != .zero, firstDraw else { return }
        let insets = UIEdgeInsets(
            top: headerView.bounds.height,
            left: 0,
            bottom: view.frame.height - (saveButton.frame.minY - 10),
            right: 0
        )
        leftScrollView.contentInset = insets
        rightScrollView.contentInset = insets

        setupKeyboardManager()
        firstDraw = false
    }
    
    private func setupView() {
        view.backgroundColor = R.color.createProduct.background()
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        let stepStr = R.string.localizable.createDescriptionFirst()
        let ofStr = R.string.localizable.createDescriptionSecond()
        descriptionFirstPageLabel.text = "\(stepStr) \(1) \(ofStr) \(2)"
        descriptionSecondPageLabel.text = "\(stepStr) \(2) \(ofStr) \(2)"
        
        firstPageFormView.complition = { complition in
            self.presenter?.didTapScanButton({ barcode in
                complition(barcode)
            })
        }
    }
    
    private func addSubviews() {
        view.addSubviews(
            mainScrollView,
            headerView,
            titleHeaderLabel,
            closeButton,
            backButton,
            saveButton
        )
        
        mainScrollView.addSubviews(
            leftScrollView,
            rightScrollView
        )
        
        leftScrollView.addSubviews(
            titleFirstPageLabel,
            descriptionFirstPageLabel,
            firstPageFormView,
            imageView
        )
        
        rightScrollView.addSubviews(
            titleSecondPageLabel,
            descriptionSecondPageLabel,
            secondPageFormView,
            nutritionView,
            servingSizeView,
            formsView
        )
    }
    
    // swiftlint:disable:next function_body_length
    private func setupFistPageConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        titleHeaderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(16)
            make.trailing.equalTo(closeButton.snp.leading).offset(-16)
        }
        
        mainScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        leftScrollView.snp.makeConstraints { make in
            make.width.height.equalTo(view)
            make.leading.top.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(7)
        }
        
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(closeButton)
        }
        
        titleFirstPageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        descriptionFirstPageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleFirstPageLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        firstPageFormView.setContentHuggingPriority(.init(800), for: .vertical)
        firstPageFormView.setContentCompressionResistancePriority(.init(800), for: .vertical)
        firstPageFormView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(descriptionFirstPageLabel.snp.bottom).offset(16)
            make.width.equalTo(view).offset(-40)
        }
        
        imageView.aspectRatio(0.652)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(firstPageFormView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(view).offset(-40)
            make.bottom.equalToSuperview()
        }
        
        saveButton.aspectRatio(0.171)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
    }
    
    private func setupSecondPageConstraints() {
        rightScrollView.snp.makeConstraints { make in
            make.width.height.equalTo(view)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(leftScrollView.snp.trailing)
            make.trailing.equalToSuperview()
        }
        
        titleSecondPageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        descriptionSecondPageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleSecondPageLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        secondPageFormView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(descriptionSecondPageLabel.snp.bottom).offset(16)
        }
        
        nutritionView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(secondPageFormView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        servingSizeView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(nutritionView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        formsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(view).offset(-40)
            make.top.equalTo(servingSizeView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func didChangePage() {
        switch currentPage {
        case 0:
            changePage(currentPage)
            setupFirstPage()
        case 1:
            changePage(currentPage)
            setupSecondPage()
        case 2:
            presenter?.saveProduct()
        default:
            return
        }
    }
    
    private func changePage(_ page: Int) {
        mainScrollView.setContentOffset(
            CGPoint(
                x: CGFloat(page) * self.view.bounds.width,
                y: 0
            ),
            animated: true
        )
    }
    
    private func setupFirstPage() {
        backButton.isHidden = true
        titleHeaderLabel.text = R.string.localizable.createTitle()
        titleHeaderLabel.isHidden = checkTitleIsHidden(leftScrollView)
        saveButton.updateNode(type: .next)
    }
    
    private func setupSecondPage() {
        backButton.isHidden = false
        titleSecondPageLabel.text = firstPageFormView.name
        titleHeaderLabel.text = firstPageFormView.name
        titleHeaderLabel.isHidden = checkTitleIsHidden(rightScrollView)
        saveButton.updateNode(type: .save)
    }
    
    private func checkFirstPage() {
        guard let name = firstPageFormView.name, !name.isEmpty else { return }
        currentPage = 1
    }
    
    private func checkSecondPage() {
        let all = formsView.values
        let required = Const.formModels.filter {
            switch $0.value {
            case .optional:
                return false
            case .required:
                return true
            }
        }
        
        if required.allSatisfy({
            guard let form = all[$0.type] else { return false }
            return form != nil
        }) {
            currentPage = 2
        }
    }
    
    private func checkTitleIsHidden(_ scrollView: UIScrollView) -> Bool {
        return !(scrollView.contentOffset.y > -50)
    }
    
    private func setupKeyboardManager() {
        addTapToHideKeyboardGesture()
        keyboardManager?.bindToKeyboardNotifications(scrollView: leftScrollView)
        keyboardManager?.bindToKeyboardNotifications(scrollView: rightScrollView)
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapCloseButton()
    }
    
    @objc private func didTapSaveButton() {
        Vibration.success.vibrate()
        switch currentPage {
        case 0:
            checkFirstPage()
        case 1:
            checkSecondPage()
        default:
            return
        }
    }
    
    @objc private func didTapBackButton() {
        Vibration.rigid.vibrate()
        currentPage = 0
    }
}

extension CreateProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleHeaderLabel.isHidden = checkTitleIsHidden(scrollView)
    }
}

extension CreateProductViewController: CreateProductViewControllerInterface {
    func getFormValues() -> [ProductFormSegment: String?] {
        return formsView.values
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
    
    func getBrand() -> String? {
        return firstPageFormView.brand
    }
    
    func getBarcode() -> String? {
        return firstPageFormView.barcode
    }
    
    func getProductName() -> String? {
        return firstPageFormView.name
    }
    
    func getServingDescription() -> String? {
        return secondPageFormView.title?.isEmpty ?? true ? R.string.localizable.gram() : secondPageFormView.title
    }
    
    func getServingWeight() -> Double? {
        return secondPageFormView.weight
    }
}

// MARK: - Factory

extension CreateProductViewController {
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 24)
        label.textColor = R.color.foodViewing.basicGrey()
        return label
    }
    
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 24)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.text = R.string.localizable.createTitle().uppercased()
        return label
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.createProduct.close(), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }
    
    private func getMainScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = false
        return scrollView
    }
    
    private func getHeaderView() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.tintColor = R.color.foodViewing.basicPrimary()
        button.setImage(R.image.addFood.tabBar.chevronLeft(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }
    
    private func getNutritionView() -> NutritionFactsCellView {
        let view = NutritionFactsCellView()
        view.viewModel = .init(
            title: R.string.localizable.createNutrition().uppercased(),
            subtitle: "",
            font: .average,
            cellWidth: .large,
            separatorLineHeight: .small
        )
        return view
    }
    
    private func getServingSizeView() -> NutritionFactsCellView {
        let view = NutritionFactsCellView()
        view.viewModel = .init(
            title: R.string.localizable.createServing(),
            subtitle: nil,
            font: .average,
            cellWidth: .large,
            separatorLineHeight: .large
        )
        return view
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 17)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.textAlignment = .center
        return label
    }
}
