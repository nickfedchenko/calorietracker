//
//  NothingWasFoundView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.11.2022.
//

import UIKit

final class NothingWasFoundView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 22)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.text = "nothing was found".uppercased()
        return label
    }()
    
    private lazy var createButton: VerticalButton = {
        let button = VerticalButton()
        button.setTitle("CREATE", .normal)
        button.setImage(R.image.addFood.tabBar.pencil(), .normal)
        button.setTitleColor(R.color.foodViewing.basicPrimary(), .normal)
        button.imageView.tintColor = R.color.foodViewing.basicPrimary()
        return button
    }()
    
    private lazy var backgroundButtonView: ViewWithShadow = {
        let view = ViewWithShadow([ShadowConst.firstShadow, ShadowConst.secondShadow])
        view.backgroundColor = .white
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func addSubviews() {
        backgroundButtonView.addSubview(createButton)
        addSubviews(titleLabel, backgroundButtonView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        backgroundButtonView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.centerX.bottom.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.top.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Const

extension NothingWasFoundView {
    struct ShadowConst {
        static let firstShadow = Shadow(
            color: R.color.addFood.menu.firstShadow() ?? .black,
            opacity: 0.2,
            offset: CGSize(width: 0, height: 4),
            radius: 10
        )
        static let secondShadow = Shadow(
            color: R.color.addFood.menu.secondShadow() ?? .black,
            opacity: 0.25,
            offset: CGSize(width: 0, height: 0.5),
            radius: 2
        )
    }
}