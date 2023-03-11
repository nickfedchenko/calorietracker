//
//  ReviewCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.03.2023.
//

import UIKit

final class ReviewCell: UICollectionViewCell {
    static let identifier = String(describing: ReviewCell.self)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        imageView.image = image
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
