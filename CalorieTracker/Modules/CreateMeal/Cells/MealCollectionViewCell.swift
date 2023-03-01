//
//  MealCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 27.02.2023.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    var viewModel: MealCellViewModel?
    
    private let separator = UIView()
    private let titleLabel = UILabel()
    private let tagView = UIView()
    private let tagLabel = UILabel()
    private let kcalLabel = UILabel()
    private let weightLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [titleLabel, tagLabel, kcalLabel, weightLabel].forEach {
            $0.text = nil
        }
    }
    
    private func addSubviews() {
        contentView.addSubviews(
            separator,
            titleLabel,
            tagView,
            tagLabel,
            kcalLabel,
            weightLabel
        )
    }
    
    private func setupConstraints() {
        separator.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(54)
            
        }
        
        tagView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(8)
            make.height.equalTo(18)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(tagView)
            make.bottom.equalTo(tagView)
            make.left.equalTo(tagView.snp.left).offset(5)
            make.right.equalTo(tagView.snp.right).offset(-5)
        }
        
        kcalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(8)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(kcalLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(8)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .white
        separator.backgroundColor = UIColor(hex: "#B3EFDE")
        
        titleLabel.font = R.font.sfProTextMedium(size: 15)
        titleLabel.textColor = UIColor(hex: "#111111")
        
        tagView.backgroundColor = UIColor(hex: "#AFBEB8")
        tagView.layer.cornerRadius = 4
        
        tagLabel.font = R.font.sfProTextMedium(size: 15)
        tagLabel.textColor = UIColor(hex: "#FFFFFF")
        
        kcalLabel.font = R.font.sfProTextMedium(size: 15)
        kcalLabel.textColor = UIColor(hex: "#E46840")
        
        weightLabel.font = R.font.sfProTextMedium(size: 15)
        weightLabel.textColor = UIColor(hex: "#547771")
        
        addSubviews()
        setupConstraints()
    }
    
    func configure(with viewModel: MealCellViewModel) {
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
}
