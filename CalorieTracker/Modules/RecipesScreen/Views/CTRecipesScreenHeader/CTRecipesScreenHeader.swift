//
//  LayoutControlHeaderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import UIKit

final class CTRecipesScreenHeader: UIView {
    let contentView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        return view
    }()
    
    private let layoutChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.layoutGridSectionsIcon(), for: .normal)
        return button
    }()
    
    private let createFolderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.addFolderIcon(), for: .normal)
        let title = NSAttributedString(
            string: "Create Folder",
            attributes: [
                .font: R.font.sfProRoundedSemibold(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    private let addToCartButton: CTAddToCartButton = {
       let button = CTAddToCartButton()
        return button
    }()
    
    private func setupSubviews() {
        addSubviews(contentView)
        contentView.addSubviews(layoutChangeButton, createFolderButton, addToCartButton)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layoutChangeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
        }
        
        createFolderButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
