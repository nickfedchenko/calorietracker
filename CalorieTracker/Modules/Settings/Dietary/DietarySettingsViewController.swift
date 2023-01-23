//
//  DietarySettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

protocol DietarySettingsViewControllerInterface: AnyObject {
    
}

final class DietarySettingsViewController: UIViewController {
    var presenter: DietarySettingsPresenterInterface?
    var viewModel: DietarySettingsViewModel?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    private func registerCell() {
        collectionView.register(SettingsCategoryCollectionViewCell.self)
        collectionView.register(SettingsProfileHeaderCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupView() {
        view.backgroundColor = R.color.mainBackground()
        
        collectionView.contentInset = .init(
            top: 76,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
    private func addSubviews() {
        view.addSubviews(collectionView, backButton)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
}

extension DietarySettingsViewController: DietarySettingsViewControllerInterface {
    
}

// MARK: - CollectionView FlowLayout

extension DietarySettingsViewController: UICollectionViewDelegateFlowLayout {
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
        return 16
    }
}

// MARK: - CollectionView Delegate

extension DietarySettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Vibration.selection.vibrate()
        guard let type = viewModel?.getTypeCell(indexPath),
              type != .title,
              let cell = collectionView.cellForItem(at: indexPath)
                as? SettingsCategoryCollectionViewCell
        else { return }
        
        presenter?.saveDietary(
            {
                switch type {
                case .title:
                    return .classic
                case .classic:
                    return .classic
                case .pescatarian:
                    return .pescatarian
                case .vegetarian:
                    return .vegetarian
                case .vegan:
                    return .vegan
                }
            }()
        )
        
        self.collectionView
            .visibleCells
            .compactMap { $0 as? SettingsCategoryCollectionViewCell }
            .forEach { $0.cellState = $0 == cell ? .isSelected : .isNotSelected }
    }
}

// MARK: - CollectionView DataSource

extension DietarySettingsViewController: UICollectionViewDataSource {
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

extension DietarySettingsViewController {
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            "PROFILE".attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0],
                        attributes: [
                            .font(R.font.sfProDisplaySemibold(size: 22)),
                            .color(R.color.foodViewing.basicGrey())
                        ]
                    )
                ],
                image: .init(
                    image: R.image.settings.leftChevron(),
                    font: R.font.sfProDisplaySemibold(size: 22),
                    position: .left
                )
            ),
            for: .normal
        )
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
}
