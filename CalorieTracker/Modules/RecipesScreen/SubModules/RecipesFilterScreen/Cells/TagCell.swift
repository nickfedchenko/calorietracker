//
//  TagCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import UIKit

final class TagCell: UICollectionViewCell {
    static let identifier = String(describing: TagCell.self)
    private var tagTitle: String = ""
    private let tagTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "1A2122")
        label.font = R.font.sfProTextMedium(size: 15)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = UIColor(hex: "0C695E")
                tagTitleLabel.textColor = .white
            } else {
                contentView.backgroundColor = .white
                tagTitleLabel.textColor = UIColor(hex: "1A2122")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupAppearance()
    }
    
    func configure(with title: String) {
        tagTitleLabel.text = title
        self.tagTitle = title
    }
    
    private func setupSubviews() {
        contentView.addSubview(tagTitleLabel)
        tagTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(hex: "E2E6EB").cgColor
        contentView.layer.cornerRadius = 4
    }
}
