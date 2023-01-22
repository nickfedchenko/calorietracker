//
//  LayoutControlHeaderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import UIKit

final class CTRecipesScreenHeader: UIView {
    
    private let layoutChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.layoutGridSectionsIcon(), for: .normal)
        button.tintColor = UIColor(hex: "62D3B4")
        return button
    }()
    
    private let createFolderButton: CTAddFolderButton = {
        let button = CTAddFolderButton(type: .system)
        let title = NSAttributedString(
            string: "Create Folder",
            attributes: [
                .font: R.font.sfProRoundedSemibold(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12)
        return button
    }()
    
    private let addToCartButton: CTAddToCartButton = {
        let button = CTAddToCartButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        clipsToBounds = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {

addSubviews(layoutChangeButton, createFolderButton, addToCartButton)
        
        layoutChangeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
           
        }
        
        createFolderButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
//            make.height.equalTo(40)
//            make.width.equalTo(146)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(40)
        }
    }
}
