//
//  RecomendationsCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.03.2023.
//

import UIKit

final class RecommendationsTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: RecommendationsTableViewCell.self)
    
    // MARK: - Property list
    private let circleView = UIView()
    private let linkTextLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(with model: RecomendationsSectionModel, row: Int) {
        setupLinkLabel(text: model.links[row].text)
    }
    
    // MARK: - Private methods
    private func configureUI() {
        addSubViews()
        setupConstraints()
        configureView()
        configureCircleView()
        configureLinkLabel()
    }
    
    private func addSubViews() {
        contentView.addSubview(circleView)
        contentView.addSubview(linkTextLabel)
    }
    
    private func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    // MARK: - CIRCLE VIEW
    private func configureCircleView() {
        circleView.layer.cornerCurve = .continuous
        circleView.layer.cornerRadius = 2.5
        circleView.layer.backgroundColor = UIColor(hex: "192621").cgColor
    }
    
    // MARK: - LINK LABEL
    private func configureLinkLabel() {
        linkTextLabel.font = R.font.sfProTextMedium(size: 16)
        linkTextLabel.textColor = UIColor(hex: "192621")
        linkTextLabel.textAlignment = .left
        linkTextLabel.numberOfLines = 0
    }
    
    // MARK: - SETUP
    private func setupLinkLabel(text: String) {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        linkTextLabel.attributedText = underlineAttributedString
    }
}

// MARK: - Constraints
extension RecommendationsTableViewCell {
    
    private func setupConstraints() {
        
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(5)
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(13)
        }
        
        linkTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).inset(-10)
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

