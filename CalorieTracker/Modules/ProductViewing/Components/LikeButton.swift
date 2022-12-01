//
//  LikeButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.11.2022.
//

import UIKit

final class LikeButton: UIControl {
    enum LikeButtonState: CaseIterable {
        case isSelected
        case isNotSelected
        
        var value: Bool {
            switch self {
            case .isSelected:
                return true
            case .isNotSelected:
                return false
            }
        }
        
        init(_ value: Bool) {
            self = value ? .isSelected : .isNotSelected
        }
    }
    
    var likeButtonState: LikeButtonState = .isNotSelected {
        didSet {
            didChangeState()
        }
    }
    
    let event: UIControl.Event
    
    private(set) var selectedImage: UIImage? = UIImage(systemName: "heart.fill")
    private(set) var notSelectedImage: UIImage? = UIImage(systemName: "heart")
    private(set) var imageColor: [LikeButtonState: UIColor?] = [:]
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Overridden properties
    
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
    
    // MARK: - Initialize
    
    init(_ event: UIControl.Event = .touchUpInside) {
        self.event = event
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    func setImage(_ image: UIImage?, _ state: LikeButtonState) {
        switch state {
        case .isSelected:
            selectedImage = image
        case .isNotSelected:
            notSelectedImage = image
        }
        didChangeState()
    }
    
    func setImageColor(_ color: UIColor?, _ state: LikeButtonState) {
        imageColor[state] = color
        didChangeState()
    }
    
    // MARK: - Private Functions
    
    private func didChangeState() {
        imageView.tintColor = imageColor[likeButtonState] ?? .white
        switch likeButtonState {
        case .isSelected:
            imageView.image = selectedImage
        case .isNotSelected:
            imageView.image = notSelectedImage
        }
    }
    
    private func setupView() {
        addTarget(
            self,
            action: #selector(didTapButton),
            for: self.event
        )
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapButton() {
        likeButtonState = LikeButtonState.allCases
            .first(where: { $0 != likeButtonState }) ?? .isNotSelected
    }
}

// MARK: - Touches

extension LikeButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layer.opacity = 0.8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        layer.opacity = 1
    }
}
