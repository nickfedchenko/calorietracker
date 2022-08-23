//
//  PreviousApplicationViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol PreviousApplicationViewControllerInterface: AnyObject {}

final class PreviousApplicationViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PreviousApplicationPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let myFitnessPalAnswerOption: AnswerOption = .init(text: "MyFitnessPal")
    private let weightWatchersAnswerOption: AnswerOption = .init(text: "WW (formerly Weight Watchers)")
    private let noomAnswerOption: AnswerOption = .init(text: "Noom")
    private let kcalcAnswerOption: AnswerOption = .init(text: "Kcalc")
    private let fitbitAnswerOption: AnswerOption = .init(text: "Fitbit")
    private let loseItAnswerOption: AnswerOption = .init(text: "Lose It!")
    private let anotherAppAnswerOption: AnswerOption = .init(text: "Another app")
    private let dontRememberAnswerOption: AnswerOption = .init(text: "I don’t remember")
    private let nextCommonButton: CommonButton = .init(style: .filled, text: "Next".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "History"
        
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "Which app did you use?"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        myFitnessPalAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        weightWatchersAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        noomAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        kcalcAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        fitbitAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        loseItAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        anotherAppAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        dontRememberAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(myFitnessPalAnswerOption)
        stackView.addArrangedSubview(weightWatchersAnswerOption)
        stackView.addArrangedSubview(noomAnswerOption)
        stackView.addArrangedSubview(kcalcAnswerOption)
        stackView.addArrangedSubview(fitbitAnswerOption)
        stackView.addArrangedSubview(loseItAnswerOption)
        stackView.addArrangedSubview(anotherAppAnswerOption)
        stackView.addArrangedSubview(dontRememberAnswerOption)
        
        contentView.addSubview(nextCommonButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrolView.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(scrolView.snp.bottom)
        }
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
        }
        
        nextCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(44)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        sender.isSelected = !sender.isSelected
        nextCommonButton.isHidden = !nextCommonButton.isHidden
    }
    
    @objc func didTapNextCommonButton() {
        presenter?.didTapNextCommonButton()
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
}

extension PreviousApplicationViewController: PreviousApplicationViewControllerInterface {}
