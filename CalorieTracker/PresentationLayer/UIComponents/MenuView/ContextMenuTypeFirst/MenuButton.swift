//
//  MenuButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.10.2022.
//

import UIKit

final class MenuButton: UIControl {
    
    var completion: ((@escaping (MenuView.MenuCellViewModel) -> Void) -> Void)?
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.addFood.menu.downArrow()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18)
        label.textColor = R.color.addFood.menu.isSelectedText()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MenuView.MenuCellViewModel?) {
        titleLabel.text = model?.title ?? ""
        leftImageView.image = model?.image
    }
    
    private func setupView() {
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubviews(leftImageView, rightImageView, titleLabel)
    }
    
    private func setupConstraints() {
        leftImageView.aspectRatio()
        leftImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(leftImageView.snp.trailing).offset(8)
        }
        
        rightImageView.aspectRatio()
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func didTapButton() {
        completion? { data in
            self.titleLabel.text = data.title
            self.leftImageView.image = data.image
        }
    }
}