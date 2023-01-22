//
//  FiltersScreenTopCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import AlignedCollectionViewFlowLayout
import UIKit

final class FiltersScreenTopCell: UICollectionViewCell {
    static let identifier = String(describing: FiltersScreenTopCell.self)
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0C695E")
        label.font = R.font.sfProRoundedBold(size: 24)
        label.text = "Filter your search".localized.uppercased()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
