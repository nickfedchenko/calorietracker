//
//  CounterKcalControl.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 29.11.2022.
//

import UIKit

final class CounterKcalControl: UIControl {
    struct Model {
        let kcal: Double
        let count: Int
    }
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.sfProDisplaySemibold(size: 18)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var kcalLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.addFood.recipesCell.kalories()
        label.font = R.font.sfProDisplaySemibold(size: 18)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var countLabelBackgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 4
        view.backgroundColor = R.color.foodViewing.basicSecondaryDark()
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.15,
                delay: !isHighlighted ? 0.15 : 0.0,
                options: .allowUserInteraction,
                animations: {
                    self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.95, y: 0.95)
                    : CGAffineTransform.identity
                },
                completion: nil
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(_ model: Model) {
        countLabel.text = String(model.count)
        kcalLabel.text = String(model.kcal)
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerCurve = .continuous
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
    }
    
    private func addSubviews() {
        countLabelBackgroundView.addSubview(countLabel)
        addSubviews(countLabelBackgroundView, kcalLabel)
    }
    
    private func setupConstraints() {
        countLabelBackgroundView.setContentCompressionResistancePriority(
            .init(rawValue: 701),
            for: .horizontal
        )
        countLabelBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(countLabelBackgroundView.snp.height)
        }
        
        countLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview()
        }
        
        kcalLabel.snp.makeConstraints { make in
            make.leading.equalTo(countLabelBackgroundView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().offset(-6)
            make.top.bottom.equalToSuperview()
        }
    }
}
