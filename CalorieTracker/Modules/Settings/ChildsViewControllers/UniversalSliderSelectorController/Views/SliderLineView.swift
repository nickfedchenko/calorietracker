//
//  SliderLineView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 03.03.2023.
//

import UIKit

final class SliderLineThumbnailView: ViewWithShadow {
    override init(_ shadows: [Shadow]) {
        super.init(shadows)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = UIColor(hex: "FF764B")
        snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        layer.cornerRadius = 16
        layer.cornerCurve = .circular
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}

final class SliderLineView: UIView {
    private var target: UniversalSliderSelectionTargets
    
    var currentFillRatio: Double = 0 {
        didSet {
            updateFill()
        }
    }
    
    let backgroundLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "AFBEB8")
        view.layer.cornerRadius = 1
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let activePartView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "E46840")
        return view
    }()
    
    private lazy var thumb: SliderLineThumbnailView = {
        let thumb = SliderLineThumbnailView(Constants.thumbShadows)
        thumb.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(sliderPositionChanged(sender:)))
        )
        return thumb
    }()
    
    var progressEmmiter: ((CGFloat) -> Void)?
    
    init(target: UniversalSliderSelectionTargets) {
        self.target = target
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -16, dy: -16).contains(point)
    }
    
    func setCurrentProgress(_ progress: Double) {
        currentFillRatio = progress
    }
    
    private func updateFill() {
        activePartView.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(currentFillRatio)
        }
    }
    
    private func setupSubviews() {
        addSubviews(backgroundLine, activePartView, thumb)
        
        backgroundLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(2)
        }
        
        activePartView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalToSuperview().multipliedBy(currentFillRatio)
        }
        
        thumb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(-16)
        }
        
    }
    
    func setProgress(_ progress: Double) {
        let width = bounds.width - 32
        let targetOffset = width * progress
        thumb.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(targetOffset)
        }
    }
    
    @objc private func sliderPositionChanged(sender: UIPanGestureRecognizer) {
        guard let thumb = sender.view else { return }
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self).x
            print(translation)
            guard thumb.center.x + translation > 0 && thumb.center.x + translation < bounds.width else { return }
            thumb.center.x += translation
            sender.setTranslation(.zero, in: self)
        case .ended:
            sender.setTranslation(.zero, in: self)
        default:
            return
        }
    }
    
    private func adjustThumbPosition() {
        let x = thumb.center.x
        switch target {
        case .activityLevel(numberOfAnchors: let anchorsCount, lowerBoundValue: _, upperBoundValue: _):
            let step = bounds.width / anchorsCount - 1
            let realPostionRatio = x / bounds.width
        }
    }
}

extension SliderLineView {
    enum Constants {
        static let thumbShadows: [Shadow] = [
            .init(
                color: UIColor.black,
                opacity: 0.15,
                offset: .init(width: 0, height: 1),
                radius: 7,
                spread: -1
            ),
            .init(
                color: UIColor(hex: "4F4F4F"),
                opacity: 0.24,
                offset: .init(width: 0, height: 4),
                radius: 12,
                spread: -2
            )
        ]
    }
}
