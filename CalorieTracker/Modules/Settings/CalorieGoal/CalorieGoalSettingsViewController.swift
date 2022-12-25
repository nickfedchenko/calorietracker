//
//  CalorieGoalSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

protocol CalorieGoalSettingsViewControllerInterface: AnyObject {
    func updateCell(_ type: CalorieGoalSettingsCategoryType)
}

final class CalorieGoalSettingsViewController: UIViewController {
    var presenter: CalorieGoalSettingsPresenterInterface?
    var viewModel: CalorieGoalSettingsViewModel?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var saveButton: BasicButtonView = getSaveButton()
    private lazy var recalculateButton: BasicButtonView = getRecalculateButton()
    
    private var firstDraw = true

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = .init(
            top: 76,
            left: 0,
            bottom: view.frame.height
                - recalculateButton.frame.minY
                - view.safeAreaInsets.bottom
                + 16,
            right: 0
        )
    }
    
    private func registerCell() {
        collectionView.register(SettingsGoalCollectionViewCell.self)
        collectionView.register(SettingsProfileHeaderCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupView() {
        view.backgroundColor = R.color.mainBackground()
    }
    
    private func addSubviews() {
        view.addSubviews(
            collectionView,
            headerView,
            titleHeaderLabel,
            backButton,
            recalculateButton,
            saveButton
        )
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(headerView.snp.bottom).offset(-8)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        saveButton.aspectRatio(0.171)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(backButton.snp.top).offset(-20)
        }
        
        recalculateButton.aspectRatio(0.171)
        recalculateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
    }
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
    
    @objc private func didTapSaveButton() {
        presenter?.didTapSaveButton()
    }
    
    @objc private func didTapResetButton() {
        presenter?.didTapRecalculateButton()
    }
}

extension CalorieGoalSettingsViewController: CalorieGoalSettingsViewControllerInterface {
    func updateCell(_ type: CalorieGoalSettingsCategoryType) {
        guard let row = viewModel?.getIndexType(type) else {
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionView FlowLayout

extension CalorieGoalSettingsViewController: UICollectionViewDelegateFlowLayout {
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
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - CollectionView Delegate

extension CalorieGoalSettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = viewModel?.getTypeCell(indexPath) else { return }
        presenter?.didTapCell(type)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let row = viewModel?.getIndexType(.title),
              let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) else {
            return
        }
        let frameCell = collectionView.convert(cell.frame, to: view)
        titleHeaderLabel.isHidden = frameCell.maxY > headerView.frame.maxY
    }
}

// MARK: - CollectionView DataSource

extension CalorieGoalSettingsViewController: UICollectionViewDataSource {
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

extension CalorieGoalSettingsViewController {
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            R.string.localizable.settingsMyGoalsTitle().attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0, 1],
                        attributes: [
                            .font(R.font.sfProDisplaySemibold(size: 22.fontScale())),
                            .color(R.color.foodViewing.basicGrey())
                        ]
                    )
                ],
                image: .init(
                    image: R.image.settings.leftChevron(),
                    font: R.font.sfProDisplaySemibold(size: 22.fontScale()),
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }
    
    private func getNutrientMenuView() -> MenuView<NutrientGoalType> {
        MenuView<NutrientGoalType>([.default, .lowCarb, .highProtein, .lowFat])
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.settingsCalorieGoalTitle()
        label.font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        label.textColor = R.color.foodViewing.basicPrimary()
        label.isHidden = true
        return label
    }
    
    private func getHeaderView() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    private func getSaveButton() -> BasicButtonView {
        let button = BasicButtonView(type: .save)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }
    
    private func getRecalculateButton() -> BasicButtonView {
        let button = BasicButtonView(type: .custom(
            .init(
                image: .init(
                    isPressImage: R.image.settings.reset(),
                    defaultImage: R.image.settings.reset(),
                    inactiveImage: nil
                ),
                title: .init(
                    isPressTitleColor: R.color.foodViewing.basicPrimary(),
                    defaultTitleColor: R.color.foodViewing.basicPrimary()
                ),
                backgroundColorInactive: nil,
                backgroundColorDefault: R.color.foodViewing.basicSecondary(),
                backgroundColorPress: R.color.foodViewing.basicSecondaryDark(),
                gradientColors: nil,
                borderColorInactive: nil,
                borderColorDefault: R.color.foodViewing.basicSecondaryDark(),
                borderColorPress: R.color.foodViewing.basicSecondary()
            )
        ))
        button.defaultTitle = " \(R.string.localizable.settingsCalorieGoalRecalculate())"
        button.isPressTitle = " \(R.string.localizable.settingsCalorieGoalRecalculate())"
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }
}
