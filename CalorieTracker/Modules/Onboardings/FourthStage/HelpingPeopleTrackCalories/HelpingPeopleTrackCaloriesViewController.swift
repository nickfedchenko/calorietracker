//
//  HelpingPeopleTrackCaloriesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol HelpingPeopleTrackCaloriesViewControllerInterface: AnyObject {}

final class HelpingPeopleTrackCaloriesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: HelpingPeopleTrackCaloriesPresenterInterface?
    
    // MARK: - Views properties

    private let plugView: UIView = .init()
    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "continue".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "Habits"
        
        view.backgroundColor = R.color.mainBackground()
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.axis = .vertical
        
        imageView.image = UIImage(named: R.image.onboardings.calendar.name)
        
        titleLabel.text = "We’ve been helping people track calories since 2015."
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton),
                                       for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        view.addSubview(continueCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerY.equalTo(view.snp.centerY)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(96)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-34)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - HelpingPeopleTrackCaloriesViewControllerInterface

extension HelpingPeopleTrackCaloriesViewController: HelpingPeopleTrackCaloriesViewControllerInterface {}
