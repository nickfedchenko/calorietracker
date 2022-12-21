//
//  GoalsSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

protocol GoalsSettingsViewControllerInterface: AnyObject {
    func updateCell(_ type: GoalsSettingsCategoryType)
}

final class GoalsSettingsViewController: UIViewController {
    var presenter: GoalsSettingsPresenterInterface?
    var viewModel: GoalsSettingsViewModel?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var goalMenuView: MenuView<GoalType> = getGoalMenuView()
    private lazy var activityMenuView: MenuView<ActivityLevel> = getActivityMenuView()
    
    private var goalMenuController: BAMenuController?
    private var activityMenuController: BAMenuController?
    
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
            bottom: view.frame.height - backButton.frame.minY - view.safeAreaInsets.bottom,
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
        
        goalMenuView.complition = { goalType in
            UDM.goalType = goalType
            self.presenter?.updateCell(type: .goal)
        }
        
        activityMenuView.complition = { activity in
            UDM.activityLevel = activity
            self.presenter?.updateCell(type: .activityLevel)
        }
        
        goalMenuController = .init(goalMenuView, width: 243.fontScale())
        activityMenuController = .init(activityMenuView, width: 243.fontScale())
    }
    
    private func addSubviews() {
        view.addSubviews(collectionView, backButton, headerView, titleHeaderLabel)
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
    }
    
    private func showGoalMenu(_ point: CGPoint) {
        guard let goalMenuController = goalMenuController else {
            return
        }
        goalMenuController.anchorPoint = point

        present(goalMenuController, animated: true)
    }
    
    private func showActivityMenu(_ point: CGPoint) {
        guard let activityMenuController = activityMenuController else {
            return
        }
        activityMenuController.anchorPoint = point

        present(activityMenuController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
}

extension GoalsSettingsViewController: GoalsSettingsViewControllerInterface {
    func updateCell(_ type: GoalsSettingsCategoryType) {
        guard let row = viewModel?.getIndexType(type) else {
            return
        }
        
        collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }
}

// MARK: - CollectionView FlowLayout

extension GoalsSettingsViewController: UICollectionViewDelegateFlowLayout {
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

extension GoalsSettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = viewModel?.getTypeCell(indexPath),
              let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let rect = collectionView.convert(cell.frame, to: view)
        let anchorPoint = CGPoint(x: view.frame.width - 20, y: rect.midY)
        switch type {
        case .goal:
            showGoalMenu(anchorPoint)
        case .activityLevel:
            showActivityMenu(anchorPoint)
        default:
            presenter?.didTapCell(type)
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

extension GoalsSettingsViewController: UICollectionViewDataSource {
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

extension GoalsSettingsViewController {
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            "PREFERENCES".attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0],
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
    
    private func getGoalMenuView() -> MenuView<GoalType> {
        MenuView<GoalType>([.loseWeight, .buildMuscle, .maintainWeight])
    }
    
    private func getActivityMenuView() -> MenuView<ActivityLevel> {
        MenuView<ActivityLevel>([.low, .moderate, .high, .veryHigh])
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "MY GOALS"
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
}
