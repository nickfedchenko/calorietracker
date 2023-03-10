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
        style: .filled,
        text: R.string.localizable.paywallStartNow()
    )

    private lazy var privacyPolicyButton: UIButton = getPolicyButton()
    private lazy var termOfUseButton: UIButton = getTermsButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.waterWidget.closeSettings(), for: .normal)
        button.tintColor = UIColor(hex: "192621").withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureViews()
        configureLayouts()
        subscriptionViewModel?.loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func registerCell() {
        collectionView.register(SubscriptionAmountCollectionViewCell.self)
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        imageView.image = R.image.paywall.woman()
        
        titleLabel.text = R.string.localizable.paywallTitle()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        
        subscriptionBenefitsContainerView.layer.cornerRadius = 20
        subscriptionBenefitsContainerView.backgroundColor = .white
        subscriptionBenefitsContainerView.layer.masksToBounds = false
        subscriptionBenefitsContainerView.layer.shadowColor = UIColor.black.cgColor
        subscriptionBenefitsContainerView.layer.shadowOpacity = 0.20
        subscriptionBenefitsContainerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        subscriptionBenefitsContainerView.layer.shadowRadius = 5
        
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
        
        subscriptionViewModel?.reloadHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
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
            closeButton
        )
        
        subscriptionBenefitsContainerView.addSubviews(
            convenientCalorieSubscriptionBenefits,
            effectiveWeightSubscriptionBenefits,
            recipesForDifferentSubscriptionBenefits,
            bestWaySubscriptionBenefits
        )
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(imageView.snp.top).offset(60)
        }
        
        subscriptionBenefitsContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        convenientCalorieSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(subscriptionBenefitsContainerView.snp.top).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        effectiveWeightSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(convenientCalorieSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        recipesForDifferentSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(effectiveWeightSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        bestWaySubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(recipesForDifferentSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
            $0.bottom.equalTo(subscriptionBenefitsContainerView.snp.bottom).offset(-25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subscriptionBenefitsContainerView.snp.bottom).offset(28)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        startNowCommonButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(64)
            $0.bottom.equalTo(privacyPolicyButton.snp.top).offset(-35)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        termOfUseButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.trailing.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(53.fitH)
        }
    }
    
    @objc private func didTapStartNow() {
        
        guard let product = subscriptionViewModel?.getProductToPurchase() else {
            presenter?.continueToAppNonConditionally()
            return
        }

        presenter?.productPurchase(product)
    }
    
    @objc private func didTapPrivacyPolicy() {
        presenter?.didTapPrivacyPolicy()
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
        
        subscriptionViewModel?.selectedIndex = indexPath.row
    }
}

// MARK: - CollectionView FlowLayout

extension PaywallViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 56
        let height = width * 0.2
        return CGSize(width: width, height: height)
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
        return cell
    }
}

// MARK: - Factory

extension PaywallViewController {
    private func getTermsButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Terms", for: .normal)
        button.titleLabel?.font = R.font.sfProDisplaySemibold(size: 12)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    private func getPolicyButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = R.font.sfProDisplaySemibold(size: 12)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
}
