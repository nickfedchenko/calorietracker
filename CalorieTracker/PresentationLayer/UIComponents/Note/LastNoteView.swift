//
//  LastNoteView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.01.2023.
//

import UIKit

class LastNoteView: UIView {
    struct Model {
        let estimation: Estimation?
        let text: String
        let photo: UIImage?
    }
    
    private lazy var textView: SLTextView = getTextView()
    private lazy var photoImageView: UIImageView = getPhotoImageView()
    private lazy var estimationImageView: UIImageView = getEstimationImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePath = UIBezierPath(rect: self.convert(estimationImageView.frame, to: textView))
        textView.textContainer.exclusionPaths = [imagePath]
    }
    
    func configure(_ model: Model) {
        textView.text = model.text
        estimationImageView.image = model.estimation?.getEstimationSmile()
        
        if let photo = model.photo {
            photoImageView.image = photo
            photoImageView.isHidden = false
            
            if photo.size.height > photo.size.width {
                photoImageView.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-5)
                    make.top.bottom.equalToSuperview().inset(5)
                    make.width.equalTo(self.snp.height).multipliedBy(0.607)
                }
            } else {
                photoImageView.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-5)
                    make.top.greaterThanOrEqualToSuperview().offset(5)
                    make.bottom.lessThanOrEqualToSuperview().offset(-5)
                    make.width.equalTo(self.snp.height).multipliedBy(0.607)
                    make.height.equalTo(photoImageView.snp.width)
                    make.centerY.equalToSuperview()
                }
            }
            
        } else {
            photoImageView.isHidden = true
            
            photoImageView.snp.remakeConstraints { make in
                make.width.equalTo(0)
                make.trailing.equalToSuperview().offset(-5)
                make.top.bottom.equalToSuperview().inset(5)
            }
        }
        
        setNeedsDisplay()
    }
    
    private func setupView() {
        
    }
    
    private func setupConstraints() {
        addSubviews(
            textView,
            estimationImageView,
            photoImageView
        )
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(photoImageView.snp.leading).offset(-7)
            make.top.bottom.equalToSuperview().inset(21)
        }
        
        estimationImageView.snp.makeConstraints { make in
            make.leading.equalTo(textView.snp.leading)
            make.centerY.equalTo(textView.snp.top)
            make.height.width.equalTo(24.fontScale())
        }
        
        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(0)
            make.trailing.equalToSuperview().offset(-5)
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Factory

extension LastNoteView {
    private func getTextView() -> SLTextView {
        let textView = SLTextView()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 17.fontScale()
        paragraphStyle.maximumLineHeight = 17.fontScale()
        textView.typingAttributes = [
            .font: R.font.sfProTextMedium(size: 11.fontScale())!,
            .paragraphStyle: paragraphStyle
        ]
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = R.color.notes.text()
        textView.tintColor = R.color.notes.noteAccent()
        textView.separatorLinesColor = R.color.notes.noteGray()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }
    
    private func getPhotoImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }
    
    private func getEstimationImageView() -> UIImageView {
        let view = UIImageView()
        
        return view
    }
}
