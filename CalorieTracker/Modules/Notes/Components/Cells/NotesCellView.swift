//
//  NotesCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.01.2023.
//

import UIKit

final class NotesCellView: UIView {
    var model: NotesCellViewModel? {
        didSet {
            didChangeModel()
        }
    }
    
    private lazy var dateLabel: UILabel = getDateLabel()
    private lazy var weightLabel: UILabel = getWeightLabel()
    private lazy var textLabel: UILabel = getTextLabel()
    private lazy var weightBackgroundView: UIView = getWeightBackgroundView()
    
    private lazy var smileImageView: UIImageView = .init(frame: .zero)
    private lazy var photoImageView: UIImageView = .init(frame: .zero)
    
    private var photoWidthConstraints: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didChangeModel() {
        guard let model = model else { return }

        smileImageView.image = model.estimation.getEstimationSmile()
        textLabel.text = model.text
        dateLabel.text = getDateString(model.date)
        weightLabel.text = BAMeasurement(model.weight, .weight, isMetric: true).string
        
        if let photo = model.image {
            photoImageView.image = photo
            photoWidthConstraints?.isActive = false
            photoImageView.isHidden = false
        } else {
            photoWidthConstraints?.isActive = true
            photoImageView.isHidden = true
        }
    }
    
    private func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        if Day(date).year > Day(Date()).year {
            dateFormatter.dateFormat = "yyyy MMM d"
        } else {
            dateFormatter.dateFormat = "MMM d"
        }
        
        return dateFormatter.string(from: date).uppercased()
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        photoImageView.layer.cornerCurve = .continuous
        photoImageView.layer.cornerRadius = 12
        photoImageView.layer.masksToBounds = true
        
        backgroundColor = R.color.notes.noteBG()
    }
    
    private func setupConstraints() {
        addSubviews(
            dateLabel,
            textLabel,
            weightBackgroundView,
            smileImageView,
            photoImageView
        )
        
        weightBackgroundView.addSubview(weightLabel)
        
        smileImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(4)
            make.height.width.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.height.equalTo(smileImageView)
            make.leading.equalTo(smileImageView.snp.trailing).offset(10)
        }
        
        weightBackgroundView.snp.makeConstraints { make in
            make.trailing.equalTo(-4)
            make.top.height.equalTo(smileImageView)
            make.leading.greaterThanOrEqualTo(dateLabel.snp.trailing).offset(10)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(smileImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalTo(photoImageView.snp.leading).offset(-4)
        }
        
        photoWidthConstraints = photoImageView.widthAnchor.constraint(equalToConstant: 0)
        photoImageView.aspectRatio()
        photoImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalTo(weightBackgroundView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}

// MARK: - Factory

extension NotesCellView {
    private func getDateLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18.fontScale())
        label.textColor = R.color.notes.noteAccent()
        return label
    }
    
    private func getWeightLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 14.fontScale())
        label.textColor = .white
        return label
    }
    
    private func getTextLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16.fontScale())
        label.textColor = R.color.notes.text()
        label.numberOfLines = 0
        return label
    }
    
    private func getWeightBackgroundView() -> UIView {
        let view = RoundedView()
        view.backgroundColor = R.color.notes.noteAccent()
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        return view
    }
}
