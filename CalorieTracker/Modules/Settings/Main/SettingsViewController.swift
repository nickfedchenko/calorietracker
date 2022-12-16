//
//  SettingsViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol SettingsViewControllerInterface: AnyObject {
    func updatePremiumButton(_ isSubscribe: Bool)
}

final class SettingsViewController: UIViewController {
    var presenter: SettingsPresenterInterface?
    var viewModel: SettingsСategoriesViewModel?
    
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var shareButton: UIButton = getShareButton()
    private lazy var premiumButton: PremiumButton = getPremiumButton()
    
    private lazy var logoView: LogoView = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCell()
        addSubviews()
        setupConstraints()
        presenter?.updateViewController()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.foodViewing.background()
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubviews() {
        view.addSubviews(
            logoView,
            shareButton,
            premiumButton,
            collectionView,
            closeButton
        )
    }
    
    private func setupConstraints() {
        logoView.aspectRatio(0.344)
        logoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(31)
            make.leading.equalToSuperview().offset(31)
            make.width.equalToSuperview().multipliedBy(0.464)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(31)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-28)
            make.top.equalTo(logoView.snp.top)
        }
        
        premiumButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(logoView.snp.bottom)
        }
    }
    
    private func registerCell() {
        collectionView.register(SettingsProfileCollectionViewCell.self)
        collectionView.register(SettingsCategoryCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
    
    @objc private func didTapShareButton() {
        presenter?.didTapShareButton()
    }
    
    @objc private func didTapPremiumButton() {
        presenter?.didTapPremiumButton()
    }
}

extension SettingsViewController: SettingsViewControllerInterface {
    func updatePremiumButton(_ isSubscribe: Bool) {
        premiumButton.isSubscribe = isSubscribe
    }
}

// MARK: - CollectionView FlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.getCellSize(
            width: view.frame.width - 40,
            indexPath: indexPath
        ) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - CollectionView Delegate

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = viewModel?.getTypeCell(indexPath) else {
            return
        }
        
        presenter?.didTapCell(type)
    }
}

// MARK: - CollectionView DataSource

extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let cell = viewModel?.getCell(collectionView, indexPath: indexPath)
        return cell ?? defaultCell
    }
}

// MARK: - Factory

extension SettingsViewController {
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        return button
    }
    
    private func getCollectionView() -> UICollectionView {
        let collectionLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.layer.masksToBounds = false
        return collectionView
    }
    
    private func getPremiumButton() -> PremiumButton {
        let button = PremiumButton()
        button.addTarget(self, action: #selector(didTapPremiumButton), for: .touchUpInside)
        return button
    }
    
    private func getShareButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.setAttributedTitle(
            "Share".attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0],
                        attributes: [
                            .font(R.font.sfProTextMedium(size: 17.fontScale())),
                            .color(R.color.foodViewing.basicPrimary())
                        ]
                    )
                ],
                image: .init(
                    image: R.image.settings.share(),
                    font: R.font.sfProTextMedium(size: 14.fontScale()),
                    position: .right
                )
            ),
            for: .normal
        )
        
        return button
    }
}
