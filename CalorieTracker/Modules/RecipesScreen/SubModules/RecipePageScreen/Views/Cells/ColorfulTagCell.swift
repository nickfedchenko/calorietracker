//
//  ColorfulTagCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.01.2023.
//

import UIKit

final class ColorfulTagCell: UICollectionViewCell {
    static let identifier = String(describing: ColorfulTagCell.self)
    private var tagModel: RecipeTagModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupAppearance()
    }
    
    func configure(with tagModel: RecipeTagModel) {
        self.tagModel = tagModel
        contentView.backgroundColor = tagModel.color
        titleLabel.text = tagModel.title
    }
    
    private func setupAppearance() {
        contentView.layer.cornerRadius = 4
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(7)
        }
    }
}
