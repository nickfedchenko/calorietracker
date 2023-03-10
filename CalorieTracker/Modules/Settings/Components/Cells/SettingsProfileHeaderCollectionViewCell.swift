//
//  SettingsProfileHeaderCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

final class SettingsProfileHeaderCollectionViewCell: UICollectionViewCell {
    
    var type: ProfileSettingsCategoryType?
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    private var lastUpdatedInterval: TimeInterval = Date().timeIntervalSince1970

    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextBold(size: 17)
        label.textColor = R.color.foodViewing.basicPrimary()
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        label.textColor = R.color.foodViewing.basicPrimary()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPercentLabel(value: Double) {
        var currentInterval = Date().timeIntervalSince1970
//        guard
//            let currentValue = Double(percentLabel.text ?? "0"),
//            abs(currentValue - value) > 1 else { return }
        if value > 100 {
            percentLabel.textColor = UIColor(hex: "FF0000")
        } else {
            percentLabel.textColor = UIColor(hex: "AFBEB8")
        }
     
 let transition = CATransition()
        percentLabel.text = String(format: "%.0f", value) + " %"
    }
    
    private func setupConstraints() {
        contentView.addSubviews(titleLabel, percentLabel)
  
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
