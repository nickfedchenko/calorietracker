//
//  ProfileSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

protocol ProfileSettingsViewControllerInterface: AnyObject {
    func updateCell(_ type: ProfileSettingsCategoryType)
    func getNameStr() -> String?
    func getLastNameStr() -> String?
    func getCityStr() -> String?
    func needUpdateParentVC()
}

final class ProfileSettingsViewController: UIViewController {
    var presenter: ProfileSettingsPresenterInterface?
    var viewModel: SettingsProfileViewModel?
    var keyboardManager: KeyboardManagerProtocol?
    var needUpdate: (() -> Void)?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    
    private lazy var userSexMenuView: MenuView<UserSex> = getUserSexMenuView()
    
    private var userSexMenuController: BAMenuController?
    
    private var firstDraw = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupView()
        addSubviews()
        setupConstraints()
        addTapToHideKeyboardGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw, backButton.frame != .zero else { return }
        collectionView.contentInset = .init(
            top: 76,
            left: 0,
            bottom: view.frame.height - backButton.frame.minY - view.safeAreaInsets.bottom,
            right: 0
        )
        setupKeyboard()
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let index = viewModel?.getIndexType(.dietary) else { return }
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    private func registerCell() {
        collectionView.register(SettingsProfileTextFieldCollectionViewCell.self)
        collectionView.register(SettingsCategoryCollectionViewCell.self)
        collectionView.register(SettingsProfileHeaderCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupKeyboard() {
        keyboardManager?.bindToKeyboardNotifications(scrollView: collectionView)
    }
    
    private func setupView() {
        view.backgroundColor = R.color.mainBackground()
        
        userSexMenuController = .init(userSexMenuView, width: 200)
        
        userSexMenuView.complition = { userSex in
            self.presenter?.setUserSex(userSex)
        }
    }
    
    private func addSubviews() {
        view.addSubviews(
            collectionView,
            backButton,
            headerView,
            titleHeaderLabel
        )
    }
    
    private func setupConstraints() {
        titleHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(headerView.snp.bottom).offset(-8)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(219)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getCellText(_ type: ProfileSettingsCategoryType) -> String? {
        guard let row = viewModel?.getIndexType(type) else { return nil }
        let cell = collectionView
            .cellForItem(at: IndexPath(row: row, section: 0))
        as? SettingsProfileTextFieldCollectionViewCell
        
        return cell?.text
    }
    
    private func showUserSexMenu(_ point: CGPoint) {
        guard let userSexMenuController = userSexMenuController else {
            return
        }
        userSexMenuController.anchorPoint = point

        present(userSexMenuController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        Vibration.rigid.vibrate()
        presenter?.didTapBackButton()
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {
    func needUpdateParentVC() {
        self.needUpdate?()
    }
    
    func updateCell(_ type: ProfileSettingsCategoryType) {
        guard let row = viewModel?.getIndexType(type) else { return }
        collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }
    
    func getCityStr() -> String? {
        getCellText(.city)
    }
    
    func getNameStr() -> String? {
        getCellText(.name)
    }
    
    func getLastNameStr() -> String? {
        getCellText(.lastName)
    }
}

// MARK: - CollectionView FlowLayout

extension ProfileSettingsViewController: UICollectionViewDelegateFlowLayout {
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

extension ProfileSettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Vibration.selection.vibrate()
        guard let type = viewModel?.getTypeCell(indexPath),
               let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        let rect = collectionView.convert(cell.frame, to: view)
        let anchorPoint = CGPoint(x: view.frame.width - 20, y: rect.midY)
        
        switch type {
        case .sex:
            showUserSexMenu(anchorPoint)
        case .date:
            presenter?.didTapDateCell()
        case .height:
            presenter?.didTapHeightCell()
        case .dietary:
            presenter?.didTapDietaryCell()
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

extension ProfileSettingsViewController: UICollectionViewDataSource {
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

extension ProfileSettingsViewController {
    private func getBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            R.string.localizable.settingsPreferencesTitle().attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0],
                        attributes: [
                            .font(R.font.sfProDisplaySemibold(size: 22.fontScale())),
                            .color(R.color.foodViewing.basicGrey())
                        ]
                    )
                ]
            ),
            for: .normal
        )
        button.setImage(R.image.settings.leftChevron(), for: .normal)
        button.titleEdgeInsets.left = 25
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
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "PROFILE"
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
    
    private func getUserSexMenuView() -> MenuView<UserSex> {
        MenuView<UserSex>([.male, .famale])
    }
}
