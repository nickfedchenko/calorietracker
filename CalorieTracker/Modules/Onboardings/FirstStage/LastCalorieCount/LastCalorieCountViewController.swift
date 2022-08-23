//
//  LastCalorieCountViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

protocol LastCalorieCountViewControllerInterface: AnyObject {}

final class LastCalorieCountViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: LastCalorieCountPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let usingAnAppAnswerOption: AnswerOption = .init(text: "Using an app")
    private let onWebsiteAnswerOption: AnswerOption = .init(text: "On a website")
    private let byTakingNotesAnswerOption: AnswerOption = .init(text: "By taking notes")
    private let usingSpreadsheetAnswerOption: AnswerOption = .init(text: "Using a spreadsheet")
    private let anotherWay: AnswerOption = .init(text: "Another way")
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
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "The last time you ", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        attributedString.append(NSAttributedString(string: "counted calories", attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: ", how were you doing it?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        usingAnAppAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        onWebsiteAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        byTakingNotesAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        usingSpreadsheetAnswerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        anotherWay.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(usingAnAppAnswerOption)
        stackView.addArrangedSubview(onWebsiteAnswerOption)
        stackView.addArrangedSubview(byTakingNotesAnswerOption)
        stackView.addArrangedSubview(usingSpreadsheetAnswerOption)
        stackView.addArrangedSubview(anotherWay)
        
        view.addSubview(nextCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(plugView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
        
        nextCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
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

extension LastCalorieCountViewController: LastCalorieCountViewControllerInterface {}
