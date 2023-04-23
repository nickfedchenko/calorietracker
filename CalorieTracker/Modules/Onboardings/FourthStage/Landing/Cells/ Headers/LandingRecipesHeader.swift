//
//  LandingRecipesHEader.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

class LandingRecipesHeader: UICollectionReusableView {
    static let identifier = String(describing: LandingRecipesHeader.self)
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: RecipesSectionModel) {
        headerTitle.text = model.titleString
        headerTitle.font = model.titleFont
        headerTitle.textColor = model.titleColor
    }

    private func setupSubviews() {
       addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview()
        }
    }
}
