//
//  LogoView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import UIKit

final class LogoView: UIView {
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = R.image.settings.logo()
        return view
    }()
    
    private lazy var logoTextImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.settings.logoText()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubviews(logoImageView, logoTextImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
        }
        
        logoTextImageView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(9)
//            make.top.greaterThanOrEqualToSuperview()
        }
    }
}
