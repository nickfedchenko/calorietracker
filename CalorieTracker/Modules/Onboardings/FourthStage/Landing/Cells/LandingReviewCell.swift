//
//  LandingReviewCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingReviewCell: UICollectionViewCell {
    static let identifier = String(describing: LandingReviewCell.self)
    
    private let reviewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?) {
        reviewImage.image = image
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubview(reviewImage)
        reviewImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

