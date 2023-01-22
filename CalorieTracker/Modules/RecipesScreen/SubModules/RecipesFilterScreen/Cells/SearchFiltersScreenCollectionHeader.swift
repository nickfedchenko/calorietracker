//
//  SearchFiltersScreenCollectionHeader.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import UIKit

final class SearchFiltersScreenCollectionHeader: UICollectionReusableView {
    static let identifier = String(describing: SearchFiltersScreenCollectionHeader.self)
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0C695E")
        label.font = R.font.sfProRoundedBold(size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        headerTitleLabel.text = title.uppercased()
    }
    
    private func addSubviews() {
        addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}
