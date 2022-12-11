//
//  NutritionFactsCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class NutritionFactsCellView: UIView {
    var viewModel: NutritionFactsCellVM! {
        didSet {
            configureView()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.foodViewing.basicDark()
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.foodViewing.basicDark()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.foodViewing.basicPrimary()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        titleLabel.font = viewModel.font.rawValue
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.font = viewModel.font.rawValue
        
        separatorLineView.snp.makeConstraints { make in
            make.height.equalTo(viewModel.separatorLineHeight.rawValue)
        }
    }
    
    private func setupConstraints() {
        addSubviews(
            titleLabel,
            subtitleLabel,
            separatorLineView
        )
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(separatorLineView.snp.top)
        }
        
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subtitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalTo(separatorLineView.snp.top)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(0).priority(.low)
        }
    }
}
