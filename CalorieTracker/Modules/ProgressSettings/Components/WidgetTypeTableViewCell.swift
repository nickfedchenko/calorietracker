//
//  WidgetTypeTableViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 12.09.2022.
//

import UIKit

final class WidgetTypeTableViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .circular
        return view
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView()
        view.layer.addSublayer(ringShape)
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.progressScreen.enter()
        view.contentMode = .center
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18)
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.progressScreen.drag(), for: .normal)
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        return button
    }()
    
    private var ringShape = CAShapeLayer()
    private var color: UIColor?
    
    var type: WidgetType?
    
    var isSelectedCell: Bool = false {
        didSet {
            didChangeSelected()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height / 2.0 - 4
        setupShape(rect: CGRect(
            origin: .zero,
            size: CGSize(width: frame.height - 24, height: frame.height - 24)
        ))
    }

    func configure(type: WidgetType, color: UIColor?) {
        self.type = type
        self.color = color
        titleLabel.text = type.getTitle()
        didChangeSelected()
    }
    
    private func setupShape(rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        ringShape.path = path.cgPath
        ringShape.lineWidth = 2
        ringShape.fillColor = UIColor.clear.cgColor
        ringShape.strokeColor = isSelectedCell ? UIColor.white.cgColor : color?.cgColor
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        leftView.addSubview(leftImageView)
        containerView.addSubviews(
            leftView,
            titleLabel,
            rightButton
        )
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
        }
        leftImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(leftView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftView.snp.trailing).offset(12)
            make.top.bottom.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(rightButton.snp.height)
        }
    }
    
    private func didChangeSelected() {
        switch isSelectedCell {
        case true:
            containerView.backgroundColor = color
            titleLabel.textColor = .white
            leftImageView.isHidden = false
            rightButton.isHidden = false
            ringShape.strokeColor = UIColor.white.cgColor
        case false:
            containerView.backgroundColor = .clear
            titleLabel.textColor = color
            leftImageView.isHidden = true
            rightButton.isHidden = true
            ringShape.strokeColor = color?.cgColor
        }
    }
    
    @objc private func didTapRightButton(_ sender: UIButton) {
    }
}
