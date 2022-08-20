//
//  WelcomeView.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

final class WelcomeView: UIView {
    
    // MARK: - Views properties

    private let welcomBackButton: BackButton = .init()
    private let arrowImageView: UIImageView = .init()
    private let backLabel: UILabel = .init()
    private let welcomImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let historyDotImageView: UIImageView = .init()
    private let historyLabel: UILabel = .init()
    private let userDataDotImageView: UIImageView = .init()
    private let userDataLabel: UILabel = .init()
    private let motivationImageView: UIImageView = .init()
    private let motivationLabel: UILabel = .init()
    private let habitsImageView: UIImageView = .init()
    private let habitsLabel: UILabel = .init()
    private let delimeterView: UIView = .init()
    private let welcomCommonButton: CommonButton = .init(style: .filled, text: "Let’s Go!")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .white
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        welcomBackButton.addGestureRecognizer(gesture)
        
        welcomImageView.image = R.image.onboardings.welcom()
        
        titleLabel.text = "Welcome!"
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        titleLabel.textColor = R.color.onboardings.basicDark()
        
        descriptionLabel.text = "We’re happy to have you here. We’ll walk\nwalk you through these steps to get you \n set upfor weight loss success:"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.textColor = R.color.onboardings.basicDarkGray()
   
        historyDotImageView.image = R.image.onboardings.dotOn()
        
        historyLabel.text = "History"
        historyLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        historyLabel.textColor = R.color.onboardings.basicDark()
        
        userDataDotImageView.image = R.image.onboardings.dotOff()
        
        userDataLabel.text = "User data"
        userDataLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        userDataLabel.textColor = R.color.onboardings.basicDark()
        
        motivationImageView.image = R.image.onboardings.dotOff()
        
        motivationLabel.text = "Motivation / Goal"
        motivationLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        motivationLabel.textColor = R.color.onboardings.basicDark()
        
        habitsImageView.image = R.image.onboardings.dotOff()
        
        habitsLabel.text = "Habits"
        habitsLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        habitsLabel.textColor = R.color.onboardings.basicDark()
        
        delimeterView.backgroundColor = .black
        
        welcomCommonButton.addTarget(self, action: #selector(didTapWelcomCommonButton),
                                     for: .touchUpInside)
    }
    
    private func configureLayouts() {
        addSubview(welcomBackButton)
    
        addSubview(welcomImageView)
        
        addSubview(titleLabel)
        
        addSubview(descriptionLabel)
        
        addSubview(delimeterView)
        
        addSubview(historyDotImageView)
        addSubview(historyLabel)
        
        addSubview(userDataDotImageView)
        addSubview(userDataLabel)
        
        addSubview(motivationImageView)
        addSubview(motivationLabel)
        
        addSubview(habitsImageView)
        addSubview(habitsLabel)
        
        addSubview(welcomCommonButton)
        
        welcomBackButton.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(56)
            $0.left.equalTo(snp.left).offset(24)
        }
        
        welcomImageView.snp.makeConstraints {
            $0.top.equalTo(welcomBackButton.snp.bottom).offset(36)
            $0.centerX.equalTo(snp.centerX)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(welcomImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.left.equalTo(snp.left).offset(42)
            $0.right.equalTo(snp.right).offset(-42)
        }
    
        historyDotImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.left.equalTo(snp.left).offset(100)
        }
        
        historyLabel.snp.makeConstraints {
            $0.left.equalTo(historyDotImageView.snp.right).offset(24)
            $0.centerY.equalTo(historyDotImageView.snp.centerY)
        }
        
        userDataDotImageView.snp.makeConstraints {
            $0.top.equalTo(historyDotImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(historyDotImageView.snp.centerX)
        }
        
        userDataLabel.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(24)
            $0.left.equalTo(historyLabel.snp.left)
            $0.centerY.equalTo(userDataDotImageView.snp.centerY)
        }
        
        motivationImageView.snp.makeConstraints {
            $0.top.equalTo(userDataDotImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(userDataDotImageView.snp.centerX)
        }
        
        motivationLabel.snp.makeConstraints {
            $0.top.equalTo(userDataLabel.snp.bottom).offset(24)
            $0.left.equalTo(userDataLabel.snp.left)
            $0.centerY.equalTo(motivationImageView.snp.centerY)
        }
        
        habitsImageView.snp.makeConstraints {
            $0.top.equalTo(motivationImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(motivationImageView.snp.centerX)
        }
        
        habitsLabel.snp.makeConstraints {
            $0.top.equalTo(motivationLabel.snp.bottom).offset(24)
            $0.left.equalTo(motivationLabel.snp.left)
            $0.centerY.equalTo(habitsImageView.snp.centerY)
        }
        
        delimeterView.snp.makeConstraints {
            $0.top.equalTo(historyDotImageView.snp.top).offset(-16)
            $0.bottom.equalTo(habitsImageView.snp.bottom).offset(16)
            $0.centerX.equalTo(historyDotImageView.snp.centerX)
            $0.width.equalTo(1)
        }
    
        welcomCommonButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
         print("back")
    }
    
    @objc private func didTapWelcomCommonButton() {
        print("didTapWelcomCommonButton")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
