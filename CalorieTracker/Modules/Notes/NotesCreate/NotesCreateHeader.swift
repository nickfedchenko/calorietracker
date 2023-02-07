//
//  NotesEnterValueHeader.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

final class NotesCreateHeader: UIView {
    private lazy var estimationView: EstimationSmileSelectionView = .init(frame: .zero)
    
    private lazy var photoButton: UIButton = getPhotoButton()
    private lazy var doneButton: UIButton = getDoneButton()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var allNotesButton: UIButton = getAllNotesButton()
    private lazy var textView: SLTextView = getTextView()
    private lazy var photoView: UIImageView = getPhotoView()
    
    var complitionPhotoButton: (() -> Void)?
    var complitionCloseButton: (() -> Void)?
    var complitionAllNotesButton: (() -> Void)?
    var complitionDoneButton: (() -> Void)?
    
    var photo: UIImage? {
        didSet {
            didChangePhoto()
        }
    }
    
    var text: String? {
        get { textView.text }
        set { textView.text = newValue }
    }
    
    var selectedEstimation: Estimation? { estimationView.selectedEstimation }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        addGestureRecognizerForPhotoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePath = UIBezierPath(rect: self.convert(photoView.frame, to: textView))
        textView.textContainer.exclusionPaths = [imagePath]
    }
    
    func textViewBecomeFirstResponder() {
        textView.becomeFirstResponder()
    }
    
    private func setupView() {
        backgroundColor = R.color.noteWidgetNode.background()
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        layer.maskedCorners = .topCorners
        
        estimationView.didChangeValue = { [weak self] _ in
            self?.doneButton.isEnabled = true
            self?.doneButton.layer.borderColor = R.color.notes.noteAccent()?.cgColor
            self?.doneButton.setTitleColor(R.color.notes.noteAccent(), for: .normal)
        }
    }
    
    private func setupConstraints() {
        addSubviews(
            allNotesButton,
            closeButton,
            doneButton,
            photoButton,
            textView,
            photoView,
            estimationView
        )
        
        allNotesButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        closeButton.aspectRatio()
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(allNotesButton)
        }
        
        photoButton.aspectRatio()
        photoButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(allNotesButton)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(allNotesButton.snp.bottom).offset(13)
            make.height.greaterThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(300)
        }

        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(textView.snp.bottom).offset(13)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(allNotesButton)
        }
        
        estimationView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalTo(doneButton)
            make.trailing.lessThanOrEqualTo(doneButton.snp.leading).offset(-10)
        }
        
        photoView.snp.makeConstraints { make in
            make.leading.equalTo(allNotesButton.snp.trailing).offset(12.5)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualTo(textView.snp.bottom)
            make.height.equalTo(0)
        }
    }
    
    private func addGestureRecognizerForPhotoView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhotoButton))
        photoView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func didChangePhoto() {
        guard let photo = photo else {
            photoView.image = nil
            photoView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
            textView.textContainer.exclusionPaths = []
            return
        }

        photoView.image = photo
        photoView.snp.remakeConstraints { make in
            make.height.equalTo(photoView.snp.width).multipliedBy(photo.size.height / photo.size.width)
            make.leading.equalTo(allNotesButton.snp.trailing).offset(12.5)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualTo(textView.snp.bottom)
        }
        
        textView.layoutIfNeeded()
    }
    
    @objc private func didTapPhotoButton() {
        complitionPhotoButton?()
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

extension NotesCreateHeader {
    private func getTextView() -> SLTextView {
        let textView = SLTextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = R.color.notes.text()
        textView.tintColor = R.color.notes.noteCursor()
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.lineHeightMultiple = 1.52
        textView.separatorLinesColor = R.color.notes.noteGray()
        textView.lineHeight = 28
        textView.textContainerInset = .init(top: 0, left: -4, bottom: 0, right: -4)
        var attributes = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.52
        attributes[.paragraphStyle] = paragraphStyle
        attributes[.foregroundColor] = R.color.notes.text()
        attributes[.font] = R.font.sfProTextRegular(size: 16)
        textView.typingAttributes = attributes
        return textView
    }
    
    private func getPhotoButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.notes.cameraNote(), for: .normal)
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        return button
    }
    
    private func getDoneButton() -> UIButton {
        let button = UIButton()
        button.setTitle(R.string.localizable.notesDone(), for: .normal)
        button.setTitleColor(R.color.notes.noteGray(), for: .normal)
        button.titleLabel?.font = R.font.sfProRoundedBold(size: 18)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = R.color.notes.noteGray()?.cgColor
        button.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        button.isEnabled = false
        return button
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.burnedKcalTextField.chevron(), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.imageView?.tintColor = R.color.notes.noteAccent()
        return button
    }
    
    private func getAllNotesButton() -> UIButton {
        let button = UIButton()
        let font = R.font.sfProRoundedBold(size: 18)
        let titleString = R.string.localizable.notesAllNotes()
        button.contentEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 16)
        button.setAttributedTitle(
            titleString.attributedString(
                [.init(worldIndex: [0, 1], attributes: [.color(.white), .font(font), .lineHeightMultiple(1.12)])],
                image: .init(
                    image: R.image.notes.note(),
                    font: font,
                    position: .left
                )
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(didTapAllNotesButton), for: .touchUpInside)
        button.backgroundColor = R.color.notes.noteAccent()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 8
        return button
    }
    
    private func getPhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }
}
