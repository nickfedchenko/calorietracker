//
//  ProfileSettingsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

protocol ProfileSettingsViewControllerInterface: AnyObject {
    
}

final class ProfileSettingsViewController: UIViewController {
    var presenter: ProfileSettingsPresenterInterface?
    var viewModel: SettingsProfileViewModel?
    var keyboardManager: KeyboardManagerProtocol?
    
    private lazy var backButton: UIButton = getBackButton()
    private lazy var collectionView: UICollectionView = getCollectionView()
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

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {
    
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
}
