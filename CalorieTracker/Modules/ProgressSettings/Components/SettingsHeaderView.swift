//
//  SettingsHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 12.09.2022.
//

import UIKit

final class SettingsHeaderView: UIView {
    private lazy var lineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.cornerCurve = .circular
        view.backgroundColor = R.color.progressScreen.line()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }
    }
}
