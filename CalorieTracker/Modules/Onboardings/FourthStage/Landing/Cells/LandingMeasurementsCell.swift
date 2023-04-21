//
//  LandingMeasurementsCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingMeasurementsCell: UICollectionViewCell {
    static let identifier = String(describing: LandingMeasurementsCell.self)
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let weightsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let weightsTransform = CGAffineTransform(scaleX: 0.05, y: 0.05)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWeights() {
        UIView.animate(
            withDuration: 1,
            delay: 0.3,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.3,
            options: .allowAnimatedContent,
            animations: {
                self.weightsImage.transform = .identity
            }
        )
    }
    
    func hideWeights(shouldAnimate: Bool = false) {
        if shouldAnimate {
            UIView.animate(withDuration: 0.4){
                self.weightsImage.transform = self.weightsTransform
            }
        } else {
            weightsImage.transform = weightsTransform
        }
    }
    
    func configure(with model: MeasurementsSectionModel) {
        mainTitle.text = model.titleString
        mainTitle.font = model.titleFont
        mainTitle.textColor = model.titleColor
        mainImage.image = model.mainImage
        weightsImage.image = model.weightsImage
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubviews(mainTitle, mainImage)
        mainImage.addSubview(weightsImage)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        weightsImage.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(174)
            make.centerX.centerY.equalToSuperview()
        }
        
        hideWeights()
    }
}
