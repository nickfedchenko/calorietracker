//
//  ProfileSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

protocol ProfileSettingsViewControllerInterface: AnyObject {
    func getName() -> String?
    func getLastName() -> String?
    func getCity() -> String?
    func getSex() -> String?
    func getHeight() -> String?
    func getDate() -> String?
}

final class ProfileSettingsViewController: UIViewController {
    var presenter: ProfileSettingsPresenterInterface?
    var viewModel: SettingsProfileViewModel?
    var keyboardManager: KeyboardManagerProtocol?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var dateFormatter: DateFormatter = getDateFormatter()
    
    private var firstDraw = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupView()
        setupKeyboard()
        addSubviews()
        setupConstraints()
        addTapToHideKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let index = viewModel?.getIndexType(.dietary) else { return }
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.saveUserData()
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
        
        collectionView.contentInset = .init(
            top: 76,
            left: 0,
            bottom: 0,
            right: 0
        )
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
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {
    func getName() -> String? {
        getCellText(.name)
    }
    
    func getLastName() -> String? {
        getCellText(.lastName)
    }
    
    func getSex() -> String? {
        getCellText(.sex)
    }
    
    func getCity() -> String? {
        getCellText(.city)
    }
    
    func getHeight() -> String? {
        getCellText(.height)
    }
    
    func getDate() -> String? {
        getCellText(.date)
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
        guard let type = viewModel?.getTypeCell(indexPath) else {
            return
        }
        
        switch type {
        case .sex:
            break
        case .date:
            guard let cell = collectionView.cellForItem(at: indexPath)
                    as? SettingsProfileTextFieldCollectionViewCell else {
                return
            }
            presenter?.didTapDateCell { date in
                cell.text = self.dateFormatter.string(from: date)
            }
        case .height:
            guard let cell = collectionView.cellForItem(at: indexPath)
                    as? SettingsProfileTextFieldCollectionViewCell else {
                return
            }
            presenter?.didTapHeightCell { value in
                cell.text = BAMeasurement(value, .lenght).string
            }
        case .dietary:
            presenter?.didTapDietaryCell()
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleHeaderLabel.isHidden = !(scrollView.contentOffset.y > -75)
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
            "PREFERENCES".attributedSring(
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
    
    private func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "PROFILE"
        label.font = R.font.sfProDisplaySemibold(size: 22)
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
