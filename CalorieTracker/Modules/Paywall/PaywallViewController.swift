//
//  PaywallViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import ApphudSDK
import UIKit

protocol PaywallViewControllerInterface: AnyObject {}

final class PaywallViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PaywallPresenterInterface?
    var subscriptionViewModel: SubscriptionViewModel?
    
    // MARK: - Views properties
    
    let logoView = AnimatableBorderLogoImageView()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let subscriptionBenefitsContainerView: UIView = .init()
    private let convenientCalorieSubscriptionBenefits = SubscriptionBenefits(
        text: R.string.localizable.paywallConvenientCalorie()
    )
    
    private let effectiveWeightSubscriptionBenefits = SubscriptionBenefits(
        text: R.string.localizable.paywallEffectiveWeight()
    )
    
    private let recipesForDifferentSubscriptionBenefits = SubscriptionBenefits(
        text: R.string.localizable.paywallRecipesForDifferent()
    )
    
    private let bestWaySubscriptionBenefits = SubscriptionBenefits(
        text: R.string.localizable.paywallBestWay()
    )
    private let subscriptionAmount: SubscriptionAmount = .init()
    
    private let startNowCommonButton: CommonButton = .init(
        style: .gradientBordered,
        text: R.string.localizable.paywallStartNow().uppercased()
    )
    
    private lazy var cancelAnyTime: UIButton =  {
        let button = CancelAnytime()
        return button
    }()
    
    private lazy var privacyPolicyButton: UIButton = getPolicyButton()
    private lazy var termOfUseButton: UIButton = getTermsButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var restorePurchasesButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.restorePurchases(),
            attributes: [
                .font: R.font.sfProRoundedBold(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor(hex: "292D32")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.addTarget(self, action: #selector(restorePurchasesTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.waterWidget.closeSettings(), for: .normal)
        button.tintColor = UIColor(hex: "192621").withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private let label3days: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 16)
        
        let attrText = NSAttributedString(
            string: "Try 3 days\nfor free",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 16.fitH) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white,
                .kern: 0.8
            ]
        )
        label.textAlignment = .right
        label.attributedText = attrText
        label.numberOfLines = 2
        return label
    }()
    
    let label3daysBackground: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "FF8A00")
        return view
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureViews()
        configureLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        subscriptionViewModel?.loadProducts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoView.startAnimating()
        startNowCommonButton.startAnimating()
    }
    
    private func registerCell() {
        collectionView.register(SubscriptionAmountCollectionViewCell.self)
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
    
    private func configureViews() {
//        view.backgroundColor = R.color.mainBackground()
        
        imageView.image = R.image.paywall.bg_Paywall()
        
        titleLabel.text = R.string.localizable.paywallTitle()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = R.font.sfProRoundedBold(size: 28)
        
        subscriptionBenefitsContainerView.backgroundColor = .clear
    
        
        startNowCommonButton.addTarget(
            self,
            action: #selector(didTapStartNow),
            for: .touchUpInside
        )
        
        privacyPolicyButton.addTarget(
            self,
            action: #selector(didTapPrivacyPolicy),
            for: .touchUpInside
        )
        
        termOfUseButton.addTarget(
            self,
            action: #selector(didTapTermOfUse),
            for: .touchUpInside
        )
        
        subscriptionViewModel?.reloadHandler = { [weak self] experimentType in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    self?.collectionView.reloadData()
                    self?.collectionView.selectItem(
                        at: IndexPath(item: 0, section: 0),
                        animated: true,
                        scrollPosition: .top
                    )
                }
                
                if let experimentType,
                   experimentType == .variant2 {
                    self?.updateForExperiment()
                }
            }
        }
    }
    
    private func updateForExperiment() {
        let attrTitle = NSAttributedString(
            string: R.string.localizable.tryFreeSubscribe(),
            attributes: [
                .font: R.font.sfProRoundedBold(size: 18) ?? .systemFont(ofSize: 18),
                .foregroundColor: UIColor.white
            ]
        )
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        label3days.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.font = R.font.sfProRoundedBold(size: 24)
        titleLabel.textAlignment = .left
        
        startNowCommonButton.setAttributedTitle(attrTitle, for: .normal)
        
        view.addSubviews(label3daysBackground, label3days)
        
        label3days.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(self.view.snp.leading)
            make.centerY.equalTo(titleLabel)
        }
        
        label3daysBackground.snp.makeConstraints { make in
            make.top.equalTo(label3days).offset(-12)
            make.bottom.equalTo(label3days).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalTo(label3days).offset(16)
        }
        
        self.view.layoutIfNeeded()
        
        titleLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(imageView.snp.top).offset(UIDevice.isSmallDevice ? 50 : 257.fitH)
        }
        
        label3days.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualTo(titleLabel.snp.leading).offset(-28)
            make.centerY.equalTo(titleLabel)
        }
        
      
        
//        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.titleLabel.sizeToFit()
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubviews(
            imageView,
            titleLabel,
            subscriptionBenefitsContainerView,
            collectionView,
            privacyPolicyButton,
            termOfUseButton,
            startNowCommonButton,
            closeButton,
            logoView,
            cancelAnyTime,
            restorePurchasesButton
        )
        
        subscriptionBenefitsContainerView.addSubviews(
            convenientCalorieSubscriptionBenefits,
            effectiveWeightSubscriptionBenefits,
            recipesForDifferentSubscriptionBenefits,
            bestWaySubscriptionBenefits
        )
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelAnyTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.isSmallDevice ? 4 : 24)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.width.equalTo(75)
            make.trailing.equalToSuperview().inset(75.fitW)
            make.top.equalToSuperview().offset(95.fitH )
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(imageView.snp.top).offset(UIDevice.isSmallDevice ? 60 : 257.fitH)
        }
        
        subscriptionBenefitsContainerView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(48.fitW)
//            $0.bottom.equalTo(startNowCommonButton.snp.top).inset(-29)
        }
        
        convenientCalorieSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(subscriptionBenefitsContainerView.snp.top)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right)
        }
        
        effectiveWeightSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(convenientCalorieSubscriptionBenefits.snp.bottom).offset(12)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right)
        }
        
        recipesForDifferentSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(effectiveWeightSubscriptionBenefits.snp.bottom).offset(12)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right)
        }
        
        bestWaySubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(recipesForDifferentSubscriptionBenefits.snp.bottom).offset(12)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right)
            $0.bottom.equalTo(subscriptionBenefitsContainerView.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.fitH)
            make.leading.trailing.equalToSuperview()
        }
        
        startNowCommonButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(64)
            $0.bottom.equalToSuperview().offset(-96.fitH)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(UIDevice.isSmallDevice ? -5 : -26)
        }
        
        termOfUseButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(UIDevice.isSmallDevice ? -5 : -26)
        }
        
        restorePurchasesButton.snp.makeConstraints { make in
            make.top.equalTo(startNowCommonButton.snp.bottom).offset(16)
            make.centerX.equalTo(cancelAnyTime)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.trailing.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(53.fitH)
        }
        
        if UIDevice.isSmallDevice {
            logoView.alpha = 0
        }
    }
    
    @objc private func didTapStartNow() {
        #if DEBUG
        presenter?.continueToAppNonConditionally()
        return
        #endif
        
        guard let product = subscriptionViewModel?.getProductToPurchase() else {
            presenter?.continueToAppNonConditionally()
            return
        }

        presenter?.productPurchase(product)
    }
    
    @objc private func didTapPrivacyPolicy() {
        presenter?.didTapPrivacyPolicy()
    }
    
    @objc private func restorePurchasesTapped() {
        Apphud.restorePurchases { [weak self] subscriptions, _, error in
            if let error = error {
                let alertController = 
                self?.showSimpleAlert(title: "Error", message: error.localizedDescription)
            }
            
            if subscriptions?.first?.isActive() ?? false {
                self?.didTapCloseButton()
                return
            }
            
            if Apphud.hasActiveSubscription() {
                self?.didTapCloseButton()
                return
            } else {
                self?.showSimpleAlert(title: "No subscription", message: "No active subscriptions found")
            }
        }
    }
    
    @objc private func didTapTermOfUse() {
        presenter?.didTapTermOfUse()
    }
}

extension PaywallViewController: PaywallViewControllerInterface {}

// MARK: - CollectionView Delegate

extension PaywallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? SubscriptionAmountCollectionViewCell else { return }
        collectionView.visibleCells
            .map { $0 as? SubscriptionAmountCollectionViewCell }
            .forEach { $0?.isSelectedCell = cell == $0 }
        if indexPath.item == 0 {
            cell.isProfitable = true
        }
        subscriptionViewModel?.selectedIndex = indexPath.row
    }
}

// MARK: - CollectionView FlowLayout

extension PaywallViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 56
        let height: CGFloat = 56
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}

// MARK: - CollectionView DataSource

extension PaywallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        subscriptionViewModel?.numberOfProducts() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SubscriptionAmountCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.model = subscriptionViewModel?.makeModelForProduct(at: indexPath)
        if indexPath.item == 0 {
            cell.isProfitable = true
        } else {
            cell.isProfitable = false
        }
        return cell
    }
}

// MARK: - Factory

extension PaywallViewController {
    private func getTermsButton() -> UIButton {
        let button = TermOfUse()
        return button
    }
    
    private func getPolicyButton() -> UIButton {
        let button = PrivacyPolicy()
        return button
    }
    
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
}
