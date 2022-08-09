//
//  RecipesGroupHeader.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 04.08.2022.
//

import AsyncDisplayKit

class RecipesFolderHeader: UICollectionReusableView {
    static let identifier = String(describing: RecipesFolderHeader.self)
    
    private let folderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.folderIcon()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let folderTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 16)
        label.textColor = R.color.folderTitleText()
        label.text = ["Breakfast", "Lunch", "Dinner"].randomElement()
        return label
    }()
    
    private let recipesCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 16)
        label.textColor = R.color.grayBasicGray()
        label.text = ["128", "280", "175"].randomElement()
        return label
    }()
    
    private let chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.chevronRight()
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
       addSubviews(folderIcon, folderTitleLabel, recipesCountLabel, chevronIcon)
        
        folderIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.width.height.equalTo(24)
            make.top.bottom.equalToSuperview()
        }
        
        folderTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(folderIcon)
            make.leading.equalTo(folderIcon.snp.trailing).offset(6)
        }
        
        chevronIcon.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        recipesCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(chevronIcon)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(chevronIcon.snp.leading).inset(-8)
        }
    }
}
