//
//  SubscriptionAmount.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

final class SubscriptionAmount: UIView {    
    
    // MARK: - Public properties
    
    var model: SubscriptionAmountModel? {
        didSet {
            didChangeModel()
        }
    }
    
    var isSelected: Bool = false {
        didSet { didChageIsSelected() }
    }
    
    var isProfitable: Bool = false {
        didSet {
            setIsProfitable(isProfitable)
        }
    }
    
    // MARK: - View properties
    
    private let stackView: UIStackView = .init()
    private let nameLabel: UILabel = .init()
    private let describeLabel: UILabel = .init()
    private let checkMarkImageView: UIImageView = .init()
    private let profitBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "179458")
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.topLeft, .bottomRight]
        view.alpha = 0
        return view
    }()
    
    private let profitLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedSemibold(size: 13)
        label.text = "save".localized.capitalized + " 85%"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
        didChageIsSelected()
    }
    
    private func configureViews() {
        backgroundColor = R.color.mainBackground()
        checkMarkImageView.alpha = 0
        layer.borderColor = UIColor(named: R.color.onboardings.radialGradientFirst.name)?.cgColor

        layer.cornerRadius = 16
        layer.borderWidth = 2
        
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        nameLabel.font = R.font.sfProRoundedBold(size: 16)
        nameLabel.text = "Annually — $24.40 (3 days free)"
        nameLabel.textColor = UIColor(hex: "292D32")
        
        describeLabel.font = R.font.sfProRoundedRegular(size: 18)
        describeLabel.textColor = UIColor(hex: "2E3844")
        describeLabel.text = "$0,46 — week / 3 days free"
    }
    
    private func configureLayouts() {
        addSubview(stackView)
        addSubview(profitBackgroundView)
        profitBackgroundView.addSubview(profitLabel)
        
        profitBackgroundView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(22)
        }
        
        profitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(describeLabel)
        
        addSubview(checkMarkImageView)
                
        stackView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(15)
            $0.left.equalTo(snp.left).offset(20)
            $0.bottom.equalTo(snp.bottom).offset(-15)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.left.equalTo(stackView.snp.right).offset(16)
            $0.right.equalTo(snp.right).offset(-16)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.size.equalTo(24)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            layer.borderColor = UIColor(hex: "179458").cgColor
            layer.borderWidth = 2
            checkMarkImageView.image = R.image.onboardings.complet()
        } else {
            layer.borderColor = UIColor(hex: "568189").cgColor
            checkMarkImageView.image = R.image.paywall.dottedLine()
        }
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        nameLabel.text = model.title
        describeLabel.text = model.describe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setIsProfitable(_ isProfitable: Bool) {
        profitBackgroundView.alpha = isProfitable ? 1 : 0
    }
}
