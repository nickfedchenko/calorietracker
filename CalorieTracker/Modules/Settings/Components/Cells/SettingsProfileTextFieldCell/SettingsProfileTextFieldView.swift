//
//  SettingsProfileTextFieldView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.12.2022.
//

import UIKit

final class SettingsProfileTextFieldView: UIView {
    var viewModel: SettingsProfileTextFieldViewModel? {
        didSet {
            updateViewModel()
        }
    }
    
    var text: String? {
        get { textField.value }
        set { textField.value = newValue }
    }
    
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var textField = FormView<EmptyGetTitle>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    private func setupConstraints() {
        addSubviews(titleLabel, textField)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
        }
        
        textField.aspectRatio(0.128)
        textField.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    private func updateViewModel() {
        guard let viewModel = viewModel else { return }
       
        titleLabel.text = viewModel.title
        
        textField.isUserInteractionEnabled = viewModel.isEnabled
        textField.model = .init(width: .large, value: viewModel.value)
    }
}

extension SettingsProfileTextFieldView {
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 17.fontScale())
        label.textColor = R.color.foodViewing.basicGrey()
        return label
    }
}
