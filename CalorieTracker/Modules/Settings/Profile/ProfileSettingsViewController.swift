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
    
    private lazy var backButton: UIButton = getBackButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.mainBackground()
    }
    
    private func addSubviews() {
        view.addSubviews(backButton)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func didTapBackButton() {
        presenter?.didTapBackButton()
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewControllerInterface {
    
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
}
