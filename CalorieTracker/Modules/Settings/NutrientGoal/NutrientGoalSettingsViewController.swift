//
//  NutrientGoalSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

protocol NutrientGoalSettingsViewControllerInterface: AnyObject {
    func updateCell(_ type: NutrientGoalSettingsCategoryType)
    func updateNutrientCell(_ nutrientPercent: NutrientPercent)
    func needUpdateParentVC()
}

final class NutrientGoalSettingsViewController: UIViewController {
    var presenter: NutrientGoalSettingsPresenterInterface?
    var viewModel: NutrientGoalSettingsViewModel?
    var needUpdate: (() -> Void)?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var nutrientMenuView: MenuView<NutrientGoalType> = getNutrientMenuView()
    private lazy var saveButton: BasicButtonView = getSaveButton()
    private lazy var resetButton: BasicButtonView = getResetButton()
    
    private var nutrientMenuController: BAMenuController?
    
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
                - resetButton.frame.minY
                - view.safeAreaInsets.bottom
                + 16,
            right: 0
        )
    }
    
    private func registerCell() {
        collectionView.register(SettingsGoalCollectionViewCell.self)
        collectionView.register(SettingsProfileHeaderCollectionViewCell.self)
        collectionView.register(SettingsNutrientGoalCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupView() {
        view.backgroundColor = R.color.mainBackground()
        
        nutrientMenuView.complition = { nutrientGoal in
            self.presenter?.setNutrientGoal(nutrientGoal)
        }
        
        nutrientMenuController = .init(
            nutrientMenuView,
            width: view.frame.width * 0.7
        )
    }
    
    private func addSubviews() {
        view.addSubviews(
            collectionView,
            headerView,
            titleHeaderLabel,
            backButton,
            resetButton,
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
        
        resetButton.aspectRatio(0.171)
        resetButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
    }
    
    private func showGoalMenu(_ point: CGPoint) {
        guard let nutrientMenuController = nutrientMenuController else {
            return
        }
        nutrientMenuController.anchorPoint = point

        present(nutrientMenuController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
    
    @objc private func didTapSaveButton() {
        presenter?.didTapSaveButton()
    }
    
    @objc private func didTapResetButton() {
        presenter?.didTapResetButton()
    }
}

extension NutrientGoalSettingsViewController: NutrientGoalSettingsViewControllerInterface {
    func needUpdateParentVC() {
        needUpdate?()
    }
    
    func updateCell(_ type: NutrientGoalSettingsCategoryType) {
        guard let row = viewModel?.getIndexType(type) else {
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func updateNutrientCell(_ nutrientPercent: NutrientPercent) {
        guard let rowProtein = viewModel?.getIndexType(.protein),
              let rowFat = viewModel?.getIndexType(.fat),
              let rowCarbs = viewModel?.getIndexType(.carbs) else {
            return
        }
        
        let cellProtein = collectionView
            .cellForItem(at: IndexPath(row: rowProtein, section: 0))
            as? SettingsNutrientGoalCollectionViewCell
        let cellFat = collectionView
            .cellForItem(at: IndexPath(row: rowFat, section: 0))
            as? SettingsNutrientGoalCollectionViewCell
        let cellCarbs = collectionView
            .cellForItem(at: IndexPath(row: rowCarbs, section: 0))
            as? SettingsNutrientGoalCollectionViewCell
        
        cellProtein?.viewModel?.setPercent(Int(nutrientPercent.protein * 100))
        cellFat?.viewModel?.setPercent(Int(nutrientPercent.fat * 100))
        cellCarbs?.viewModel?.setPercent(Int(nutrientPercent.carbs * 100))
    }
}

// MARK: - CollectionView FlowLayout

extension NutrientGoalSettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.getCellSize(
            width: view.frame.width,
            indexPath: indexPath
        ) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

// MARK: - CollectionView Delegate

extension NutrientGoalSettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = viewModel?.getTypeCell(indexPath),
              let cell = collectionView.cellForItem(at: indexPath) else { return }
       
        switch type {
        case .nutrition:
            Vibration.selection.vibrate()
            let rect = collectionView.convert(cell.frame, to: view)
            let anchorPoint = CGPoint(x: view.frame.width - 20, y: rect.midY)
            showGoalMenu(anchorPoint)
        default:
            return
        }
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

extension NutrientGoalSettingsViewController: UICollectionViewDataSource {
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

extension NutrientGoalSettingsViewController {
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            "MY GOALS".attributedSring(
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
        label.text = R.string.localizable.settingsNutrientGoalTitle().uppercased()
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
    
    private func getResetButton() -> BasicButtonView {
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
        button.defaultTitle = " \(R.string.localizable.settingsNutrientGoalReset())"
        button.isPressTitle = " \(R.string.localizable.settingsNutrientGoalReset())"
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }
}
