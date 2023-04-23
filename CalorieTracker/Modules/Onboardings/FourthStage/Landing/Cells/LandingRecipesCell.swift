//
//  LandingrecipesCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingRecipesCell: UICollectionViewCell {
    static let identifier = String(describing: LandingRecipesCell.self)
    
    private let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: RecipesSectionModel) {
        mainImage.image = model.mainImage
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubviews(mainImage)
        mainImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
