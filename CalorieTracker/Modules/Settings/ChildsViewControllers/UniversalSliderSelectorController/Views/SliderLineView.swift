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
        view.layer.cornerRadius = 2
        view.layer.cornerCurve = .continuous
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
            make.trailing.equalTo(thumb.snp.centerX)
        }
        
        thumb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(snp.leading)
        }
        
    }
    
    func setProgress(_ progress: Double) {
        let width = bounds.width //- 32
        let targetOffset = width * progress
        thumb.snp.updateConstraints { make in
            make.centerX.equalTo(snp.leading).offset(targetOffset)
        }
        layoutIfNeeded()
        adjustThumbPosition()
    }
    
    @objc private func sliderPositionChanged(sender: UIPanGestureRecognizer) {
        guard let thumb = sender.view else { return }
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self).x
            print(translation)
            guard thumb.center.x + translation > 0 && thumb.center.x + translation < bounds.width else { return }
            thumb.center.x += translation
            thumb.snp.remakeConstraints { make in
                make.width.height.equalTo(32)
                make.centerY.equalToSuperview()
                make.centerX.equalTo(thumb.center.x)
            }
            sender.setTranslation(.zero, in: self)
        case .ended:
            sender.setTranslation(.zero, in: self)
            adjustThumbPosition()
        default:
            return
        }
    }
    
    private func adjustThumbPosition() {
        let x = thumb.center.x
        switch target {
        case .activityLevel(numberOfAnchors: let anchorsCount, lowerBoundValue: _, upperBoundValue: _):
            let step = (bounds.width) / (anchorsCount - 1)
            let realPositionRatio = x
            let ranges = {
                var ranges: [ClosedRange<Double>] = []
                for i in 0..<Int(anchorsCount) {
                    let lowerBound = step * Double(i) - (step / 2)
                    let upperBound = step * Double(i) + (step / 2)
                    ranges.append(lowerBound...upperBound)
                }
                return ranges
            }()
            if let index = ranges.firstIndex(where: { $0.contains(realPositionRatio) }) {
                let targetX = Double(index) * step
                thumb.snp.remakeConstraints { make in
                    make.width.height.equalTo(32)
                    make.centerY.equalToSuperview()
                    make.centerX.equalTo(targetX)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
                let ratio = targetX / bounds.width
                progressEmmiter?(ratio)
            }
        case .weeklyGoal(numberOfAnchors: let anchorsCount, lowerBoundValue: _, upperBoundValue: _):
            let step = (bounds.width) / (anchorsCount - 1)
            let realPositionRatio = x
            let ranges = {
                var ranges: [ClosedRange<Double>] = []
                for i in 0..<Int(anchorsCount) {
                    let lowerBound = step * Double(i) - (step / 2)
                    let upperBound = step * Double(i) + (step / 2)
                    ranges.append(lowerBound...upperBound)
                }
                return ranges
            }()
            if let index = ranges.firstIndex(where: { $0.contains(realPositionRatio) }) {
                let range = ranges[index]
                var targetX = Double(index) * step
                
                thumb.snp.remakeConstraints { make in
                    make.width.height.equalTo(32)
                    make.centerY.equalToSuperview()
                    make.centerX.equalTo(targetX)
                }
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
                let ratio = targetX / bounds.width
                progressEmmiter?(ratio)
            }
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
