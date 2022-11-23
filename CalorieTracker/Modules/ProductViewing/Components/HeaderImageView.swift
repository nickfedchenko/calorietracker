//
//  HeaderImageView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.11.2022.
//

import Kingfisher
import UIKit

final class HeaderImageView: UIView {
    
    var didTapLike: ((Bool) -> Void)?
    
    // MARK: - Private Property
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private lazy var checkedImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.setImageColor(R.color.foodViewing.basicDarkGrey(), .isNotSelected)
        button.setImageColor(R.color.foodViewing.basicDarkGrey(), .isSelected)
        button.addTarget(
            self,
            action: #selector(didTapLikeButton),
            for: button.event
        )
        return button
    }()
    
    private var firstDraw = true
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
    }
    
    // MARK: - Public Functions
    
    func configure(imageUrl: URL?, check: Bool, favorite: Bool) {
        likeButton.likeButtonState = .init(favorite)
        checkedImageView.isHidden = !check
        
        if let imageUrl = imageUrl {
            imageView.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(),
                options: [
                    .processor(DownsamplingImageProcessor(
                        size: CGSize(width: 374, height: 244)
                    ))
                ]
            )
        }
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        imageView.layer.cornerRadius = 12
    }
    
    private func addSubviews() {
        addSubviews(imageView, checkedImageView, likeButton)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkedImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.height.width.equalTo(32)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerX.equalTo(checkedImageView)
            make.bottom.equalToSuperview().offset(-18)
            make.height.width.equalTo(20)
        }
    }
    
    private func setupShadow() {
        layer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: 12
        )
        layer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: 12
        )
    }
    
    @objc private func didTapLikeButton(_ sender: LikeButton) {
        didTapLike?(sender.likeButtonState.value)
    }
}

// MARK: - Const

extension HeaderImageView {
    struct ShadowConst {
        static let firstShadow = Shadow(
            color: R.color.addFood.menu.firstShadow() ?? .black,
            opacity: 0.1,
            offset: CGSize(width: 0, height: 4),
            radius: 10
        )
        static let secondShadow = Shadow(
            color: R.color.addFood.menu.secondShadow() ?? .black,
            opacity: 0.15,
            offset: CGSize(width: 0, height: 0.5),
            radius: 2
        )
    }
}
