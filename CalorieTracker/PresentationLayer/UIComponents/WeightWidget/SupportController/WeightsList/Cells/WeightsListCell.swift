//
//  WeightsListCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 30.04.2023.
//

import UIKit

protocol WeightsListCellDelegate: AnyObject {
    func didTapToDelete(record: WeightsListCellType)
}

final class WeightsListCell: UITableViewCell {
    static let identifier = String(String(describing: WeightsListCell.self))
    weak var delegate: WeightsListCellDelegate?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProTextSemibold(size: 16)
        label.textColor = UIColor(hex: "828282")
        return label
    }()
    
    private let dailyAverageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProTextRegular(size: 14)
        label.textColor = UIColor(hex: "828282")
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextSemibold(size: 16)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.weightWidget.trashBinIcon(), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private var modelOwned: WeightsListCellType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsInitially()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: WeightsListCellType) {
        self.modelOwned = model
        switch model {
        case .daily(let model):
            configureContent(with: model)
        case .weekly(let model):
            configureContent(with: model)
        case .monthly(let model):
            configureContent(with: model)
        }
        setupConstraints(for: model)
    }
    
    private func resetDeleteButtonState() {
        deleteButton.snp.updateConstraints { make in
            make.width.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    private func setupActions() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(sender: ))
        )
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(resetTapHandler(sender:)))
        )
        
        deleteButton.addTarget(self, action: #selector(didTapToDeleteRecord), for: .touchUpInside)
    }
    
    private func setupConstraints(for mode: WeightsListCellType) {
        switch mode {
        case .daily:
            dailyAverageLabel.alpha = 0
            dateLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        case .weekly:
            dateLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(6)
            }
            
            dailyAverageLabel.alpha = 1
        case .monthly:
            dateLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(6)
            }
            
            dailyAverageLabel.alpha = 1
        }
    }
    
    private func configureContent(with cellModel: WeightsListCellModel) {
        dateLabel.text = cellModel.dateString
        dailyAverageLabel.text = cellModel.descriptionString
        valueLabel.text = cellModel.valueLabel
    }
    
    private func setupViewsInitially() {
        contentView.addSubviews(dateLabel, dailyAverageLabel, valueLabel, deleteButton)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        dailyAverageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(dateLabel)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    // swiftlint:disable:next function_body_length
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        var shouldContinue: Bool = false
        switch modelOwned {
        case .daily:
            shouldContinue = true
        default:
            shouldContinue = false
        }
        guard shouldContinue else { return }
        let translation = sender.translation(in: contentView).x / 4
        switch sender.state {
        case .changed:
            if translation < 0 {
                let possibleWidth = deleteButton.frame.width + abs(translation)
                deleteButton.snp.updateConstraints { make in
                    make.width.equalTo(
                        possibleWidth > 32 ? 32 : possibleWidth
                    )
                }
                sender.setTranslation(.zero, in: contentView)
            } else {
                let possibleWidth = deleteButton.frame.width - abs(translation)
                deleteButton.snp.updateConstraints { make in
                    make.width.equalTo(
                        possibleWidth < 0 ? 0 : possibleWidth
                    )
                }
            }
        case .ended:
            if translation < 0 {
                if deleteButton.frame.width >= 16 {
                    deleteButton.snp.updateConstraints { make in
                        make.width.equalTo(32)
                    }
                } else {
                    deleteButton.snp.updateConstraints { make in
                        make.width.equalTo(0)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    self.contentView.layoutIfNeeded()
                }
            } else {
                if deleteButton.frame.width <= 16 {
                    deleteButton.snp.updateConstraints { make in
                        make.width.equalTo(0)
                    }
                } else {
                    deleteButton.snp.updateConstraints { make in
                        make.width.equalTo(32)
                    }
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.contentView.layoutIfNeeded()
                }
            }
        default:
            return
        }
    }
    
    @objc private func resetTapHandler(sender: UITapGestureRecognizer) {
        resetDeleteButtonState()
    }
    
    @objc func didTapToDeleteRecord() {
        guard let modelOwned = modelOwned else { return }
        delegate?.didTapToDelete(record: modelOwned)
        resetDeleteButtonState()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let translation = gestureRecognizer.translation(in: contentView)
        if translation.y != 0 {
            return false
        } else {
            return true
        }
    }
}
