//
//  MealTableViewCell.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 27.02.2023.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    private let separator = UIView()
    private let titleLabel = UILabel()
    private let tagView = UIView()
    private let tagLabel = UILabel()
    private let kcalLabel = UILabel()
    private let weightLabel = UILabel()
    let checkMarkImage = UIImageView(
        image: R.image.createMeal.checkMark()
    )
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [titleLabel, tagLabel, kcalLabel, weightLabel].forEach {
            $0.text = nil
        }
        
        containerView.layer.shadowColor = UIColor.clear.cgColor
        containerView.layer.shadowOpacity = 0
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 0
    }
    
    private func addSubviews() {
        
        contentView.addSubviews(
            containerView
        )
        
        containerView.addSubviews(
            separator,
            titleLabel,
            tagView,
            tagLabel,
            checkMarkImage,
            kcalLabel,
            weightLabel
        )
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
        separator.snp.makeConstraints { make in
            make.left.equalTo(containerView).offset(8)
            make.right.equalTo(containerView).inset(8)
            make.bottom.equalTo(containerView)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(10)
            make.left.equalTo(containerView).offset(8)
            make.right.equalTo(containerView).inset(54)
            
        }
        
        tagView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(containerView).inset(8)
            make.height.equalTo(18)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(tagView)
            make.bottom.equalTo(tagView)
            make.left.equalTo(tagView.snp.left).offset(5)
            make.right.equalTo(tagView.snp.right).offset(-5)
        }
                
        checkMarkImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            if tagView.isHidden {
                make.leading.equalTo(containerView).offset(8)
                make.top.equalTo(titleLabel.snp.bottom).offset(9)
            } else {
                make.leading.equalTo(tagView.snp.trailing).offset(7)
                make.centerY.equalTo(tagView.snp.centerY)
            }
        }
        
        kcalLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(10)
            make.right.equalTo(containerView).inset(8)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(kcalLabel.snp.bottom).offset(5)
            make.right.equalTo(containerView).inset(8)
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func configureView() {
        selectionStyle = .none
        layer.backgroundColor = UIColor.clear.cgColor
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
        let clearView = UIView()
        clearView.backgroundColor = .clear
        backgroundView = clearView
        
        separator.backgroundColor = UIColor(hex: "#B3EFDE")
        
        titleLabel.font = R.font.sfProTextMedium(size: 15)
        titleLabel.textColor = UIColor(hex: "#111111")
        
        tagView.backgroundColor = UIColor(hex: "#AFBEB8")
        tagView.layer.cornerRadius = 4
        tagView.isHidden = tagLabel.text?.isEmpty ?? true ? true : false
        
        tagLabel.font = R.font.sfProTextMedium(size: 15)
        tagLabel.textColor = UIColor(hex: "#FFFFFF")
        
        kcalLabel.font = R.font.sfProTextMedium(size: 15)
        kcalLabel.textColor = UIColor(hex: "#E46840")
        
        weightLabel.font = R.font.sfProTextMedium(size: 15)
        weightLabel.textColor = UIColor(hex: "#547771")
        
        addSubviews()
        setupConstraints()
        
        containerView.backgroundColor = .white
        
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self),
              let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section)
        else { return }
        
        var maskedCorners: CACornerMask = []
        
        switch (indexPath.row, cellCount) {
        case (0, 1):
            maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner
            ]
        case (0, _):
            maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        case (_, let count) where indexPath.row == count - 1:
            maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        default:
            maskedCorners = []
        }
        
        containerView.layer.cornerRadius = maskedCorners.isEmpty ? 0 : 8
        containerView.layer.maskedCorners = maskedCorners
    }
    
    func configure(with viewModel: CreateMealCellViewModel) {
        titleLabel.text = viewModel.title
        tagLabel.text = viewModel.tag
        kcalLabel.text = viewModel.kcal
        weightLabel.text = viewModel.weight
    }
    
    func showSeparator() {
        separator.isHidden = false
    }
    
    func hideSeparator() {
        separator.isHidden = true
    }
    
    func addShadow() {
        let layer = containerView.layer
        
        layer.addShadow(
            shadow: Shadow(
                color: UIColor(hex: "06BBBB"),
                opacity: 0.2,
                offset: CGSize(width: 2, height: 0),
                radius: 2,
                spread: 0
            ),
            rect: containerView.bounds,
            cornerRadius: layer.maskedCorners.isEmpty ? 0 : 8
        )
    }
    
    func removeShadow() {
        containerView.layer.sublayers?.first?.removeFromSuperlayer()
    }
}
