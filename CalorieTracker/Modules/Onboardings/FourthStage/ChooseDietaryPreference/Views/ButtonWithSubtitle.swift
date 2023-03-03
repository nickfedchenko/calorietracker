//
//  ButtonWithSubtitle.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 02.03.2023.
//

import UIKit

final class ButtonWithSubtitle: ControlWithShadow {
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProTextMedium(size: 17.fitH)
        label.textColor = UIColor(hex: "192621")
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProTextMedium(size: 14.fitH)
        label.textColor = UIColor(hex: "192621")
        label.numberOfLines = 0
        return label
    }()
    
    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = R.image.onboardings.off()
        return imageView
    }()
    
    var viewModel: ButtonWithSubtitleViewModel? {
        didSet {
            updateSubviews()
        }
    }
    
    override init(_ shadows: [Shadow]) {
        super.init(shadows)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        if isSelected {
            shadowLayer.opacity = 0
            layer.borderWidth = 2
            layer.borderColor = UIColor(hex: "62D3B4").cgColor
            checkmarkImage.image = R.image.onboardings.dieatryCheckMarkOn()
        } else {
            shadowLayer.opacity = 1
            layer.borderWidth = 0
            checkmarkImage.image = R.image.onboardings.off()
        }
    }
    
    private func updateSubviews() {
        guard let viewModel = viewModel else { return }
        imageView.image = viewModel.image
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
    }
    
    private func setupSubviews() {
        addSubviews(imageView, title, subtitle, checkmarkImage)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.5)
            make.leading.equalTo(imageView.snp.trailing).offset(14)
            make.trailing.equalTo(checkmarkImage.snp.leading).offset(-14)
        }
        
        subtitle.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(4)
            make.trailing.equalTo(title)
            make.bottom.equalToSuperview().inset(15.5)
        }
        
        checkmarkImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
}

//extension ButtonWithSubtitle {
//    enum Constants {
//        static let shadows: [Shadow] = [
//            .init(
//                color: R.color.widgetShadowColorSecondaryLayer()!,
//                opacity: 0.2,
//                offset: .init(width: 0, height: 0.5),
//                radius: 2,
//                shape: .rectangle(radius: 16)
//            ),
//            .init(
//                color: R.color.widgetShadowColorMainLayer()!,
//                opacity: 0.25,
//                offset: .init(width: 0, height: 4),
//                radius: 10,
//                shape: .rectangle(radius: 16)
//            )
//        ]
//    }
//}
