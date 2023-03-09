//
//  CreateMealPageScreenHeader.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 04.03.2023.
//

import Kingfisher
import UIKit

protocol CreateMealPageScreenHeaderDelegate: AnyObject {
    func didTapCloseButton()
    func openGallery()
}

final class CreateMealPageScreenHeader: UIView {
    weak var delegate: CreateMealPageScreenHeaderDelegate?
    
    private lazy var containerView: UIView = getContainerView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var addPhotoButton: UIButton = getAddPhotoButton()
    private lazy var titleHeaderLabel: UILabel = getTitleHeaderLabel()
    private lazy var containerPhotoView: UIView = getContainerPhotoView()
    private lazy var mealPhoto: UIImageView = getMealPhoto()
    
    private func getContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F3FFFE").withAlphaComponent(0.7)
        return view
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.createMeal.close(), for: .normal)
        button.imageView?.tintColor = R.color.createMeal.basicGray()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getAddPhotoButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.createMeal.photo(), for: .normal)
        button.imageView?.tintColor = R.color.createMeal.basicGray()
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        return button
    }
    
    private func getTitleHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.addFoodMealCreation()
        label.font = R.font.sfProRoundedBold(size: 16)
        label.textColor = R.color.createMeal.basicPrimary()
        label.isHidden = true
        return label
    }
    
    private func getContainerPhotoView() -> UIView {
        let containerView = UIView()
        
        containerView.isHidden = true
        containerView.backgroundColor = R.color.createMeal.basicSecondary()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false

        containerView.layer.addShadow(
            shadow: Shadow(
                color: UIColor(hex: "06BBBB"),
                opacity: 0.2,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            ),
            rect: containerView.bounds,
            cornerRadius: 8
        )
        
        containerView.layer.addShadow(
            shadow: Shadow(
                color: UIColor(hex: "000000"),
                opacity: 0.25,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            rect: containerView.bounds,
            cornerRadius: 8
        )
        
        containerView.layer.addShadow(
            shadow: Shadow(
                color: UIColor(hex: "FFE665"),
                opacity: 0.25,
                offset: CGSize(width: 0, height: 6),
                radius: 12
            ),
            rect: containerView.bounds,
            cornerRadius: 8
        )

        return containerView
    }
    
    private func getMealPhoto() -> UIImageView {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .brown
        imageView.layer.borderColor = R.color.createMeal.basicSecondary()?.cgColor
        imageView.layer.borderWidth = 2.0
        addTapGestureRecognizer(to: imageView, with: #selector(openGallery))
        return imageView
    }
    
    let blurView = UIVisualEffectView(effect: nil)
    private var blurRadiusDriver: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reinitBlurView()
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(blurView)
        
        blurView.contentView.addSubview(closeButton)
        blurView.contentView.addSubview(addPhotoButton)
        blurView.contentView.addSubview(titleHeaderLabel)
        blurView.contentView.addSubview(containerPhotoView)
        blurView.contentView.addSubview(mealPhoto)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        titleHeaderLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(58)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        closeButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(52)
            make.leading.equalToSuperview().inset(25)
            make.width.height.equalTo(30)
        }
        
        addPhotoButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(56)
            make.trailing.equalToSuperview().inset(25)
            make.width.equalTo(30)
            make.height.equalTo(22)
        }
        
        containerPhotoView.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(47)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        mealPhoto.snp.remakeConstraints { make in
            make.edges.equalTo(containerPhotoView)
        }
    }
    
    private func addTapGestureRecognizer(to view: UIView, with selector: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapCloseButton() {
        self.delegate?.didTapCloseButton()
    }
    
    @objc private func openGallery() {
        self.delegate?.openGallery()
    }
    
    func setImage(with imageURL: URL) {
        mealPhoto.isHidden = false
        containerPhotoView.isHidden = false
        mealPhoto.kf.setImage(with: imageURL)
    }
    
    func hidePhoto() {
        mealPhoto.isHidden = true
        containerPhotoView.isHidden = true
    }
    
    func hiddenTitle(_ isHidden: Bool) {
        titleHeaderLabel.isHidden = isHidden ? true : false
        layer.borderColor = isHidden ? UIColor.clear.cgColor : UIColor(hex: "#FFFFFF").cgColor
    }
        
    func releaseBlurAnimation() {
        blurRadiusDriver?.stopAnimation(true)
    }
    
    func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.1
    }
}
