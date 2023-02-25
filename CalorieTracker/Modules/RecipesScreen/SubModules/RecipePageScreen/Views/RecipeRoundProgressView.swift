//
//  RecipeSpecificProgressView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.01.2023.
//

import UIKit

final class RecipeRoundProgressView: UIView {
    enum ProgressMode: Equatable {
        
        case carbs(total: Double, possible: Double, eaten: Double)
        case protein(total: Double, possible: Double, eaten: Double)
        case fat(total: Double, possible: Double, eaten: Double)
        case kcal(total: Double, possible: Double, eaten: Double)
        case undefined
        
        var mainBackgroundCircleColor: CGColor {
            UIColor(hex: "B3EFDE", alpha: 0.6).cgColor
        }
        
        var eatenProgressColor: CGColor {
            switch self {
            case .carbs:
                return UIColor(hex: "FFE769").cgColor
            case .protein:
                return UIColor(hex: "4BFF52").cgColor
            case .fat:
                return UIColor(hex: "4BE9FF").cgColor
            case .kcal:
                return UIColor(hex: "FF764B", alpha: 0.7).cgColor
            case .undefined:
               return UIColor.black.cgColor
            }
        }
        
        var title: String {
            switch self {
                
            case .carbs:
                return "Carbs".localized
            case .protein:
                return "Protein".localized
            case .fat:
                return "Fat".localized
            case .kcal:
                return "Kcal".localized
            case .undefined:
                return "Undefined"
            }
        }
        
        var possibleValue: Double {
            switch self {
            case .carbs(total: _, possible: let possible, eaten: _):
                return possible
            case .protein(total: _, possible: let possible, eaten: _):
                return possible
            case .fat(total: _, possible: let possible, eaten: _):
                return possible
            case .kcal(total: _, possible: let possible, eaten: _):
                return possible
            case .undefined:
                return 0
            }
        }
        
        var possibleRatio: Double {
            switch self {
            case .carbs(total: let total, possible: let possible, eaten: _):
                return possible / total
            case .protein(total: let total, possible: let possible, eaten: _):
                return possible / total
            case .fat(total: let total, possible: let possible, eaten: _):
                return possible / total
            case .kcal(total: let total, possible: let possible, eaten: _):
                return possible / total
            case .undefined:
                return 0
            }
        }
        
        var possibleEatingProgressColor: CGColor {
            switch self {
            case .carbs:
                return UIColor(hex: "DCC341").cgColor
            case .protein:
                return UIColor(hex: "30C236").cgColor
            case .fat:
                return UIColor(hex: "2FD0E5").cgColor
            case .kcal:
                return UIColor(hex: "FF764B").cgColor
            case .undefined:
               return UIColor.black.cgColor
            }
        }
    }
    
    private var currentMode: ProgressMode
    private var whiteBackgroundLayer = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()
    private var eatenLayer = CAShapeLayer()
    private var possibleEatenLayer = CAShapeLayer()
    private var whiteStroke = CAShapeLayer()
    
    private let circleFrame: CGFloat = 72
    
    private lazy var radius = circleFrame / 2
    private lazy var circleCenter = CGPoint(x: radius, y: radius)
    private let startAngle = -CGFloat.pi * 1 / 2
    private let endAngle = CGFloat.pi * 1.5
    
    private var possibleStartRatio: CGFloat = 0
    private var possibleEndRatio: CGFloat = 0
    private var eatenRatio: CGFloat = 0
    
    var shouldAware: Bool = false {
        didSet {
            if shouldAware {
//                possibleEatenLayer.strokeColor = UIColor.red.cgColor
//                whiteStroke.strokeColor = UIColor.red.cgColor
            }
        }
    }
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        label.text = currentMode.title
        label.alpha = 0
        return label
    }()
    
    private lazy var possibleValue: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextBold(size: 15)
        label.textColor = UIColor(cgColor: currentMode.possibleEatingProgressColor)
        label.text = String(format: "%.1f", currentMode.possibleValue) + " " + "g".localized
        label.textAlignment = .center
        label.alpha = 0
        switch currentMode {
        case .kcal:
            label.text?.removeLast(2)
        default:
            return label
        }
        return label
    }()
    
    private lazy var circlePath = UIBezierPath(
        arcCenter: circleCenter,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: true
    )
    
    init(currentMode: ProgressMode) {
        self.currentMode = currentMode
        super.init(frame: .zero)
        layer.addSublayer(whiteBackgroundLayer)
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(eatenLayer)
        layer.addSublayer(whiteStroke)
        layer.addSublayer(possibleEatenLayer)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        makeLayers()
    }
    
    func update(with data: ProgressMode) {
        self.currentMode = data
        makeLayers()
        animateProgress()
        possibleValue.text = String(format: "%.1f", currentMode.possibleValue) + " " + "g".localized
        switch currentMode {
        case .kcal:
            possibleValue.text?.removeLast(2)
        default:
            return
        }
    }
    
    private func setupSubviews() {
        addSubview(title)
        addSubview(possibleValue)
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(3)
        }
        
        possibleValue.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func animateProgress() {
        let backgroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let eatenAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let possibleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let whiteStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        backgroundAnimation.fromValue = 0
        backgroundAnimation.toValue = 1
        backgroundAnimation.duration = 0.4
        backgroundAnimation.fillMode = .forwards
        backgroundAnimation.isRemovedOnCompletion = false
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        eatenAnimation.fromValue = 0
        eatenAnimation.toValue = eatenRatio
        eatenAnimation.duration = 0.4
        eatenAnimation.fillMode = .forwards
        eatenAnimation.isRemovedOnCompletion = false
        eatenAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        possibleAnimation.fromValue = possibleStartRatio
        possibleAnimation.toValue = possibleEndRatio
        possibleAnimation.duration = 0.4
        possibleAnimation.fillMode = .forwards
        possibleAnimation.isRemovedOnCompletion = false
        possibleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        whiteStrokeAnimation.fromValue = possibleStartRatio
        whiteStrokeAnimation.toValue = possibleEndRatio
        whiteStrokeAnimation.duration = 0.4
        whiteStrokeAnimation.fillMode = .forwards
        whiteStrokeAnimation.isRemovedOnCompletion = false
        whiteStrokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        backgroundLayer.add(backgroundAnimation, forKey: "strokeEnd")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            self.eatenLayer.add(eatenAnimation, forKey: "strokeEnd")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            self.possibleEatenLayer.add(possibleAnimation, forKey: "strokeEnd")
            self.whiteStroke.add(whiteStrokeAnimation, forKey: "strokeEnd")
        }
    
        UIView.animate(withDuration: 1.5) {
            self.title.alpha = 1
            self.possibleValue.alpha = 1
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func makeLayers() {
        let possibleCirclePath: UIBezierPath = circlePath
        backgroundLayer.frame = bounds
        eatenLayer.frame = bounds
        possibleEatenLayer.frame = bounds
        whiteStroke.frame = bounds
        whiteBackgroundLayer.path = circlePath.cgPath
        whiteBackgroundLayer.fillColor = UIColor.white.cgColor
        initiallyDrawLayer(
            circleLayer: backgroundLayer,
            color: currentMode.mainBackgroundCircleColor,
            startPoint: 0,
            endPoint: 1,
            path: circlePath
        )
        
        var eatenRatio: Double
        var possibleStartRatio: Double
        var possibleRatio: Double
        var possibleEndRatio: Double
        switch currentMode {
        case let .carbs(total: total, possible: possible, eaten: eaten):
            eatenRatio = eaten / total
            possibleStartRatio = eatenRatio
            possibleRatio = possible / total
            possibleEndRatio = possibleStartRatio + possibleRatio
        case let .protein(total: total, possible: possible, eaten: eaten):
            eatenRatio = eaten / total
            possibleStartRatio = eatenRatio
            possibleRatio = possible / total
            possibleEndRatio = possibleStartRatio + possibleRatio
        case let .fat(total: total, possible: possible, eaten: eaten):
            eatenRatio = eaten / total
            possibleStartRatio = eatenRatio
            possibleRatio = possible / total
            possibleEndRatio = possibleStartRatio + possibleRatio
        case let .kcal(total: total, possible: possible, eaten: eaten):
            eatenRatio = eaten / total
            possibleStartRatio = eatenRatio
            possibleRatio = possible / total
            possibleEndRatio = possibleStartRatio + possibleRatio
        case .undefined:
            eatenRatio = 0
            possibleStartRatio = 0
            possibleRatio = 0
            possibleEndRatio = 0
        }
        
        var rotationAngle: CGFloat?
        
        switch (eatenRatio >= 1, possibleRatio >= 1, eatenRatio + possibleRatio >= 1) {
            // Случай когда параметр уже превышен и параметр блюда так же превышает дневную норму
        case (true, true, _):
            possibleStartRatio = 0
            possibleEndRatio = 1
            eatenRatio = 1
            // Случай когда количество сожранного не превышает дневную норму, но порция блюда сама по себе превышает суточную норму
        case (false, true, true):
            possibleStartRatio = 0
            possibleEndRatio = 1
            rotationAngle = CGFloat(Double(360) * eatenRatio) * .pi / 180
        case (false, false, true):
            let exceedingPart = (eatenRatio + possibleRatio) - 1
            possibleStartRatio -= exceedingPart
            possibleEndRatio -= exceedingPart
            rotationAngle = CGFloat(Double(360) * exceedingPart) * .pi / 180
        case (true, false, false):
            eatenRatio = 1
            possibleStartRatio = 0
            possibleEndRatio = possibleRatio
        case (false, true, false):
            rotationAngle = CGFloat(Double(360) * eatenRatio) * .pi / 180
            possibleStartRatio = 0
            possibleEndRatio = 1
        case (true, false, true):
            possibleStartRatio = 0
            possibleEndRatio = 1
//        case (true, true, false):
//            return
        case (false, false, false):
            print("")
        }
        
//        eatenRatio = eatenRatio >= 1 ? 1 : eatenRatio
//
//        if possibleStartRatio + possibleRatio >= 1 {
//            if possibleRatio >= 1 {
//                possibleStartRatio = 0
//            } else {
//              possibleStartRatio = 1 - (possibleRatio / 2)
//            }
//        }
//
//        if possibleEndRatio >= 1 {
//            if possibleRatio >= 1 {
//                print("possible ratio is higher that 1 - \(possibleRatio)")
//            } else {
//                possibleEndRatio = 0.22
//            }
//        }
        
        self.possibleEndRatio = possibleEndRatio
        self.possibleStartRatio = possibleStartRatio
        self.eatenRatio = eatenRatio

        
        initiallyDrawLayer(
            circleLayer: eatenLayer,
            color: currentMode.eatenProgressColor,
            startPoint: 0,
            endPoint: eatenRatio,
            path: circlePath
        )
        
        initiallyDrawLayer(
            circleLayer: possibleEatenLayer,
            color: currentMode.possibleEatingProgressColor,
            startPoint: possibleStartRatio,
            endPoint: possibleEndRatio,
            path: possibleCirclePath,
            shouldRotateBy: rotationAngle
        )
        
        initiallyDrawLayer(
            circleLayer: whiteStroke,
            color: UIColor.white.cgColor,
            startPoint: possibleStartRatio,
            endPoint: possibleEndRatio,
            path: possibleCirclePath,
            lineWidth: 10,
            shouldRotateBy: rotationAngle
        )
        
        backgroundLayer.strokeEnd = 0
        eatenLayer.strokeEnd = 0
        possibleEatenLayer.strokeEnd = possibleStartRatio
        whiteStroke.strokeEnd = possibleStartRatio - 0.002
        if possibleEndRatio >= 1 {
            shouldAware = true
        }
    }
    
    private func initiallyDrawLayer(
        circleLayer: CAShapeLayer,
        color: CGColor,
        startPoint: CGFloat,
        endPoint: CGFloat,
        path: UIBezierPath,
        lineWidth: CGFloat = 6,
        shouldRotateBy: CGFloat? = nil
    ) {
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = color
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeStart = startPoint
        circleLayer.strokeEnd = endPoint + 0.005
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        if let shouldRotateBy = shouldRotateBy {
            circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            circleLayer.setAffineTransform(.init(rotationAngle: shouldRotateBy))
        }
    }
}
