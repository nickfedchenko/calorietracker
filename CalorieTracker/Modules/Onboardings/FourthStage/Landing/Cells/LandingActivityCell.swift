//
//  LandingActivityCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingActivityCell: UICollectionViewCell {
    static let identifier = String(describing: LandingActivityCell.self)
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let sportsLine: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var startAnimator: UIViewPropertyAnimator?
    var endAnimator: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startAnimator?.stopAnimation(true)
        startAnimator?.finishAnimation(at: .end)
        startAnimator = nil
        endAnimator?.stopAnimation(true)
        endAnimator?.finishAnimation(at: .end)
        endAnimator = nil
    }
    
    func startAnimation() {
        self.sportsLine.snp.remakeConstraints { make in
            make.centerY.equalTo(self.mainImage)
            make.height.equalTo(152)
            make.leading.equalToSuperview()
        }
        startAnimator?.stopAnimation(true)
        startAnimator?.finishAnimation(at: .end)
        startAnimator = nil
        startAnimator = UIViewPropertyAnimator(duration: 10, curve: .linear) {
            self.layoutIfNeeded()
        }
        
        startAnimator?.addCompletion({ [weak self] position in
            if position == .end {
                self?.endAnimator?.stopAnimation(true)
                self?.endAnimator = nil
                self?.startBackAnimation()
            } else {
                self?.startAnimator?.stopAnimation(true)
                self?.startAnimator = nil
                self?.startAnimation()
            }
        })
        startAnimator?.startAnimation(afterDelay: 0.3)
    }
    
    func startBackAnimation() {
        self.sportsLine.snp.remakeConstraints { make in
            make.centerY.equalTo(self.mainImage)
            make.height.equalTo(152)
            make.trailing.equalToSuperview()
        }
        endAnimator?.stopAnimation(false)
        endAnimator?.finishAnimation(at: .end)
        endAnimator = nil
        endAnimator = UIViewPropertyAnimator(duration: 10, curve: .linear) {
            self.layoutIfNeeded()
        }
        
        endAnimator?.addCompletion({ [weak self] position in
            if position == .end {
                self?.startAnimator?.stopAnimation(true)
                self?.startAnimator?.finishAnimation(at: .end)
                self?.startAnimator = nil
                self?.startAnimation()
            } else {
                self?.endAnimator?.stopAnimation(true)
                self?.endAnimator?.finishAnimation(at: .end)
                self?.endAnimator = nil
                self?.startBackAnimation()
            }
        })
        
        endAnimator?.startAnimation(afterDelay: 0.3)
    }
    
    func configure(with model: ActivitySectionModel) {
        mainTitle.text = model.titleString
        mainTitle.font = model.titleFont
        mainTitle.textColor = model.titleColor
        mainImage.image = model.mainImage
        sportsLine.image = model.sportsImage
    }
     
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubviews(mainTitle, sportsLine, mainImage)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(40.fitW)
            make.bottom.equalToSuperview()
            make.height.equalTo(215)
        }
        
        sportsLine.snp.makeConstraints { make in
            make.centerY.equalTo(mainImage)
            make.height.equalTo(152)
            make.trailing.equalToSuperview()
        }
    }
}
