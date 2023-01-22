//
//  File.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import UIKit

protocol SelectedTagCellDelegate: AnyObject {
    func didTaptoRemoveTag(at index: Int)
}

final class SelectedTagCell: UICollectionViewCell {
    static let identifier = String(describing: SelectedTagCell.self)
    private var index: Int = -1
    weak var delegate: SelectedTagCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let clearTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.clearTagIcon(), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAppearance()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, index: Int) {
        titleLabel.text = title
        self.index = index
    }
    
    private func setupActions() {
        clearTagButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func removeButtonTapped() {
        delegate?.didTaptoRemoveTag(at: index)
    }
    
    private func setupAppearance() {
        layer.cornerRadius = 4
        backgroundColor = UIColor(hex: "0C695E")
    }
    
    private func setupSubviews() {
        contentView.addSubviews(titleLabel, clearTagButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(32)
            make.top.bottom.equalToSuperview()
        }
        
        clearTagButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
