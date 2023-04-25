//
//  WeightHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 26.08.2022.
//

import UIKit

final class WeightHeaderView: UIView {
    var userWantsChangeGoalWeight: (() -> Void)?
    struct Model {
        let start: String
        let now: String
        let goal: String
    }
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.weightWidget.backgroundLines()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rightLabel: UIButton = {
        let button = UIButton(type: .system)
        
        let attrTitle = NSAttributedString(
            string: "60",
            attributes: [
                .foregroundColor: R.color.weightWidget.weightTextColor() ?? UIColor.white,
                .font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22)
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        return button
    }()
    
    private lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.weightWidget.textColor()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var middleBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
        view.backgroundColor = R.color.weightWidget.backgroundLabelColor()
        return view
    }()
    
    private lazy var rightBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .circular
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.weightWidget.backgroundLabelColor()?.cgColor
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.2
//        view.alpha = 0
        return view
    }()
    
    var model: Model? {
        didSet {
            didChangeModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        rightLabel.addAction(
            UIAction { [weak self] _ in
                self?.userWantsChangeGoalWeight?()
        },
            for: .touchUpInside
        )
    }
    
    private func setupView() {
        let leftImageView: UIImageView = {
            let view = UIImageView()
            view.image = R.image.weightWidget.startArrow()
            return view
        }()
        
        let rightImageView: UIImageView = {
            let view = UIImageView()
            view.image = R.image.weightWidget.endArrow()
            return view
        }()
        
        middleBackgroundView.addSubview(middleLabel)
        rightBackgroundView.addSubview(rightLabel)
        
        addSubviews([
            leftLabel,
            middleBackgroundView,
//            rightLabel,
            rightBackgroundView,
            leftImageView,
            rightImageView
        ])
        
        middleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(75)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(75)
        }
        
        rightBackgroundView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(75)
        }
        
        middleBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.trailing).offset(4)
            make.trailing.equalTo(middleBackgroundView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(middleBackgroundView.snp.trailing).offset(4)
            make.trailing.equalTo(rightLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        leftLabel.text = model.start
        middleLabel.text = model.now
        let attrTitle = NSAttributedString(
            string: model.goal,
            attributes: [
                .foregroundColor: R.color.weightWidget.weightTextColor() ?? UIColor.white,
                .font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22)
            ]
        )
        rightLabel.setAttributedTitle(attrTitle, for: .normal)
    }
    
    func prepareForTransition() {
        middleBackgroundView.alpha = 0
    }
}
