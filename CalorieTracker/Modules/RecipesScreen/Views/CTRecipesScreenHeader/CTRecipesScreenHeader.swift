//
//  LayoutControlHeaderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import UIKit
// TODO: - СДелать блюр фон
final class CTRecipesScreenHeader: UIView {
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
}
