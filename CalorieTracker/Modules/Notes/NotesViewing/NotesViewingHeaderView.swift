//
//  NotesViewingHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.01.2023.
//

import UIKit

final class NotesViewingHeaderView: UIView {
    enum State {
        case viewing
        case edit
    }
    
    private lazy var estimationView: EstimationSmileSelectionView = .init(frame: .zero)
    private lazy var smileImageView: UIImageView = .init(frame: .zero)
    
    private lazy var doneButton: UIButton = getDoneButton()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var textView: UITextView = getTextView()
    private lazy var photoView: UIImageView = getPhotoView()
    private lazy var dateLabel: UILabel = getDateLabel()
    private lazy var weightLabel: UILabel = getWeightLabel()
    private lazy var weightBackgroundView: UIView = getWeightBackgroundView()
    private lazy var shareButton: UIButton = getShareButton()
    private lazy var deleteButton: UIButton = getDeleteButton()
    
    var complitionPhotoButton: (() -> Void)?
    var complitionCloseButton: (() -> Void)?
    var complitionAllNotesButton: (() -> Void)?
    var complitionDoneButton: (() -> Void)?
    var complitionDeleteButton: (() -> Void)?
    var complitionShareButton: (() -> Void)?
    
    var text: String? {
        get { textView.text }
        set { textView.text = newValue }
    }
    
    var selectedEstimation: Estimation? { estimationView.selectedEstimation }
    
    var viewModel: NotesCellViewModel? {
        didSet {
            didChangeModel()
        }
    }
    
    var state: State = .viewing {
        didSet {
            didChangeState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePath = UIBezierPath(rect: self.convert(photoView.frame, to: textView))
        textView.textContainer.exclusionPaths = [imagePath]
    }
    
    private func setupView() {
        backgroundColor = R.color.notes.background()
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        
        estimationView.didChangeValue = { estimation in
            self.smileImageView.image = estimation.getEstimationSmile()
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        addSubviews(
            smileImageView,
            dateLabel,
            weightBackgroundView,
            closeButton,
            doneButton,
            textView,
            photoView,
            estimationView,
            shareButton,
            deleteButton
        )
        
        weightBackgroundView.addSubview(weightLabel)
        
        smileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.top.leading.equalToSuperview().offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(smileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(smileImageView)
            make.top.greaterThanOrEqualToSuperview()
        }
        
        weightBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(24)
            make.leading.greaterThanOrEqualTo(dateLabel.snp.trailing).offset(8)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(photoView.snp.bottom).offset(14)
            make.height.greaterThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(300)
        }
        
        doneButton.aspectRatio(0.482)
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(textView.snp.bottom).offset(11)
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(40)
        }
        
        estimationView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalTo(doneButton)
            make.trailing.lessThanOrEqualTo(doneButton.snp.leading).offset(-10)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13)
        }
        
        shareButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.trailing.bottom.equalToSuperview().offset(-13)
            make.top.equalTo(textView.snp.bottom).offset(11)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.bottom.equalToSuperview().offset(-13)
            make.leading.equalToSuperview().offset(13)
            make.top.equalTo(textView.snp.bottom).offset(11)
        }
    }
    
    private func didChangeState() {
        switch state {
        case .viewing:
            textView.isEditable = false
            layer.maskedCorners = .allCorners
            estimationView.isHidden = true
            doneButton.isHidden = true
            shareButton.isHidden = false
            closeButton.isHidden = false
            deleteButton.isHidden = false
        case .edit:
            textView.isEditable = true
            textView.becomeFirstResponder()
            layer.maskedCorners = .topCorners
            estimationView.isHidden = false
            doneButton.isHidden = false
            shareButton.isHidden = true
            closeButton.isHidden = true
            deleteButton.isHidden = true
        }
    }
    
    private func didChangeModel() {
        guard let model = viewModel else { return }

        smileImageView.image = model.estimation.getEstimationSmile()
        textView.text = model.text
        dateLabel.text = getDateString(model.date)
        weightLabel.text = BAMeasurement(model.weight, .weight, isMetric: true).string
        
        if let photo = model.image {
            photoView.image = photo
            photoView.isHidden = false
            photoView.snp.makeConstraints { make in
                make.top.equalTo(weightBackgroundView.snp.bottom).offset(16)
                make.leading.trailing.greaterThanOrEqualToSuperview().inset(20)
                make.height.lessThanOrEqualTo(self.snp.width).multipliedBy(0.6)
                make.centerX.equalToSuperview()
            }
            
        } else {
            photoView.isHidden = true
            photoView.snp.makeConstraints { make in
                make.top.equalTo(weightBackgroundView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(0)
            }
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
    
    @objc private func didTapShareButton() {
        complitionShareButton?()
    }
    
    @objc private func didTapDeleteButton() {
        complitionDeleteButton?()
    }
    
    @objc private func didTapDoneButton() {
        complitionDoneButton?()
    }
    
    @objc private func didTapCloseButton() {
        complitionCloseButton?()
    }
    
    @objc private func didTapAllNotesButton() {
        complitionAllNotesButton?()
    }
}

// MARK: - Factory

extension NotesViewingHeaderView {
    private func getTextView() -> UITextView {
        let textView = UITextView()
        textView.font = R.font.sfProTextMedium(size: 16.fontScale())
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = R.color.notes.text()
        textView.tintColor = R.color.notes.noteAccent()
        return textView
    }
    
    private func getDoneButton() -> UIButton {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(R.color.notes.noteAccent(), for: .normal)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = R.color.notes.noteAccent()?.cgColor
        return button
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.burnedKcalTextField.chevron(), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.imageView?.tintColor = R.color.notes.noteAccent()
        return button
    }
    
    private func getShareButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.notes.share(), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }
    
    private func getDeleteButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.notes.delete(), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }
    
    private func getPhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }
    
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
    
    private func getWeightBackgroundView() -> UIView {
        let view = RoundedView()
        view.backgroundColor = R.color.notes.noteAccent()
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        return view
    }
}
