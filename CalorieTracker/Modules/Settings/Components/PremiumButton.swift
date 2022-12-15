//
//  PremiumButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

final class PremiumButton: UIControl {
    
    var isSubscribe: Bool = true {
        didSet {
            didChangeState()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = isSubscribe ? 12 : frame.height / 2.0
    }
    
    private func setupView() {
        backgroundColor = R.color.settings.premium()
        layer.cornerCurve = .circular
        layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func didChangeState() {
        titleLabel.text = isSubscribe ? "PREMIUM" : "Upgrade to Premium"
        titleLabel.font = R.font.sfProTextMedium(size: isSubscribe ? 16 : 13)
        
        titleLabel.snp.updateConstraints { make in
            make.leading.trailing.equalToSuperview().inset(isSubscribe ? 38 : 10)
        }
        
        setNeedsLayout()
    }
}
