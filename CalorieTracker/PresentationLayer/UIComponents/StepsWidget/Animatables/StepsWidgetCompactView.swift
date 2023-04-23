//
//  StepsWidgetCompactView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 04.04.2023.
//

import Charts
import UIKit

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length

final class StepsWidgetAnimatableContainer: UIView {
    private var appearingCompletion: (() -> Void)?
    private var disappearingCompletion: (() -> Void)?
    enum StepsAnimatableViewInitialState {
        case compactToFull(compactFrame: CGRect, steps: Int, progress: CGFloat)
        case fullToCompact(
            fullFrame: CGRect,
            steps: Int,
            progress: CGFloat,
            fullWidget: StepsFullWidgetAnimatableProtocol
        )
    }
    
    private var apearingAnimationFinishGroup: CAAnimationGroup?
    private let compactContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = false
        return view
    }()
    
    private let fullWidgetContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = false
        return view
    }()
    
    private let progressLineContainerView: UIView = {
       let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainButton: BasicButtonView = {
       let button = BasicButtonView(
            type: .custom(
                CustomType(
                    image: CustomType.Image(
                        isPressImage: R.image.stepsWidget.goalPress(),
                        defaultImage: R.image.stepsWidget.goalDefault(),
                        inactiveImage: nil
                    ),
                    title: CustomType.Title(
                        isPressTitleColor: .white,
                        defaultTitleColor: .white
                    ),
                    backgroundColorInactive: nil,
                    backgroundColorDefault: R.color.stepsWidget.secondGradientColor(),
                    backgroundColorPress: R.color.stepsWidget.backgroundLine(),
                    gradientColors: nil,
                    borderColorInactive: nil,
                    borderColorDefault: R.color.stepsWidget.ringColor(),
                    borderColorPress: .white
                )
            )
        )
//        button.alpha = 0
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.stepsWidget.closeArrow(), for: .normal)
//        button.alpha = 0
        return button
    }()
    
    // MARK: - Private properties
    private let  initialState: StepsAnimatableViewInitialState
    private lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        let string = Text.steps
        let font = R.font.sfProRoundedBold(size: 5 / Double(string.count) * 18)
        let color = R.color.stepsWidget.secondGradientColor()
        let image = R.image.stepsWidget.foot()
        
        label.attributedText = string.attributedSring(
            [.init(
                worldIndex: [0],
                attributes: [.color(color), .font(font)]
            )],
            image: .init(
                image: image,
                font: font,
                position: .left
            )
        )
        label.textAlignment = .right
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.stepsWidget.flaG()
        return imageView
    }()
    
    private var layers: [(shape: CAShapeLayer, gradient: CAGradientLayer)] = []
    
    var steps: Int = 0
    var progress: CGFloat = 0.5
    private var isFirstDraw = true
    private var backgroundLayer = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
   // MARK: - Init
    init(initialState: StepsAnimatableViewInitialState) {
        self.initialState = initialState
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isFirstDraw else { return }
//        drawInitialProgress()
        isFirstDraw.toggle()
    }
    
    private func setupInitialState() {
        switch initialState {
        case .compactToFull(compactFrame: let frame, steps: let steps, progress: let progress):
            self.steps = steps
            self.progress = progress
            setupInitialStateCompact(targetFrame: frame)
            drawInitialProgress()
        case .fullToCompact(fullFrame: let frame, steps: let steps, progress: let progress, fullWidget: let widget):
            self.steps = steps
            self.progress = progress
            setupInitialStateFull(targetFrame: frame, initialWidget: widget)
            drawInitialProgressForFullState()
//            drawInitialProgress()
        }
    }
    
    private func setupInitialStateFull(targetFrame: CGRect, initialWidget: StepsFullWidgetAnimatableProtocol) {
        addSubviews(
            fullWidgetContainer,
            topTitleLabel,
            bottomLabel,
            progressLineContainerView,
            imageView,
            mainButton,
            closeButton
        )
        let string = Text.steps
        let font = R.font.sfProRoundedBold(size: 22)
        let color = R.color.stepsWidget.secondGradientColor()
        let image = R.image.stepsWidget.foot()
        
        topTitleLabel.attributedText = string.attributedSring(
            [.init(
                worldIndex: [0],
                attributes: [.color(color), .font(font)]
            )],
            image: .init(
                image: image,
                font: font,
                position: .left
            )
        )
        topTitleLabel.textAlignment = .right
        var adjustmentFrame = initialWidget.getFrameForTopTitle()
        updateTopLabelFull()
        topTitleLabel.sizeToFit()
        bottomLabel.sizeToFit()
        
     
        adjustmentFrame.size.width = topTitleLabel.frame.width + 4 + bottomLabel.frame.width
        adjustmentFrame.origin.x = targetFrame.midX - adjustmentFrame.width / 2
        fullWidgetContainer.frame = targetFrame
        topTitleLabel.frame.origin = adjustmentFrame.origin
        bottomLabel.frame.origin.y = adjustmentFrame.origin.y
        bottomLabel.frame.origin.x = topTitleLabel.frame.maxX + 5
        progressLineContainerView.frame = initialWidget.getProgressContainerFrame()
        mainButton.frame = initialWidget.getMainButtonFrame()
        closeButton.frame = initialWidget.closeButtonFrame()
        imageView.frame = initialWidget.getFlagFrame()
    }
    
    private func setupInitialStateCompact(targetFrame: CGRect) {
        addSubviews(compactContainer, topTitleLabel, bottomLabel, progressLineContainerView, imageView)
        compactContainer.frame = targetFrame
        topTitleLabel.sizeToFit()
        topTitleLabel.frame = CGRect(
            x: compactContainer.frame.origin.x + 9,
            y: compactContainer.frame.origin.y + 24,
            width: topTitleLabel.intrinsicContentSize.width,
            height: 24
        )
//        topTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(compactContainer.snp.top).offset(24)
//            make.leading.trailing.equalTo(compactContainer).inset(9)
//        }
        
        progressLineContainerView.frame = targetFrame
//        progressLineContainerView.snp.makeConstraints { make in
//            make.edges.equalTo(compactContainer)
//        }
        didChangeSteps()
        bottomLabel.sizeToFit()
        bottomLabel.frame = CGRect(
            x: compactContainer.frame.origin.x + 9,
            y: compactContainer.frame.maxY - bottomLabel.intrinsicContentSize.height - 23,
            width: bottomLabel.intrinsicContentSize.width,
            height: bottomLabel.intrinsicContentSize.height
        )
        bottomLabel.center.x = compactContainer.center.x
//        bottomLabel.snp.makeConstraints { make in
//
//            make.centerX.equalTo(compactContainer)
//            make.bottom.equalTo(compactContainer).inset(23)
//        }
        
        imageView.frame = CGRect(
            x: compactContainer.frame.maxX - imageView.intrinsicContentSize.width - 12,
            y: compactContainer.frame.maxY - imageView.intrinsicContentSize.height - 12,
            width: imageView.intrinsicContentSize.width,
            height: imageView.intrinsicContentSize.height
        )
//        imageView.snp.makeConstraints { make in
//            make.bottom.equalTo(compactContainer).inset(12)
//            make.trailing.equalTo(compactContainer).inset(12)
//        }
//        layoutIfNeeded()
    }
    
    private func drawInitialProgress() {
        let shape = getProgressLayers(rect: progressLineContainerView.bounds, progress: 1).shape
        shape.strokeColor = R.color.stepsWidget.backgroundLine()?.cgColor
        shape.zPosition = -1
        backgroundLayer = shape
        progressLineContainerView.layer.addSublayer(shape)
        let circleLayer = getCircle(point: CGPoint(x: 14, y: 14))
        self.circleLayer = circleLayer
        progressLineContainerView.layer.addSublayer(circleLayer)
        drawProgressCurve(rect: progressLineContainerView.bounds, progress: progress)
    }
    
    private func drawInitialProgressForFullState() {
        let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
        let linePath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(
                to: CGPoint(
                    x: progressLineContainerView.frame.height / 2.0,
                    y: progressLineContainerView.frame.height / 2.0
                )
            )
            path.addLine(
                to: CGPoint(
                    x: progressLineContainerView.frame.width - progressLineContainerView.frame.height / 2.0,
                    y: progressLineContainerView.frame.height / 2.0
                )
            )
            return path
        }()
        
        let lineShape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = linePath.cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.lineWidth = progressLineContainerView.frame.height
            shape.lineCap = .round
            return shape
        }()
        
        lineShape.fillColor = UIColor.clear.cgColor
        
       let gradientLayer = CAGradientLayer()
        let colors = [
            R.color.stepsWidget.firstGradientColor(),
            R.color.stepsWidget.secondGradientColor()
        ]
        gradientLayer.colors = colors.compactMap { $0?.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: progressLineContainerView.frame.width * newProgress + progressLineContainerView.frame.height,
                height: progressLineContainerView.frame.height
            )
        )
        
        let lineShapeForGradient: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = linePath.cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.lineWidth = progressLineContainerView.frame.height
            shape.lineCap = .round
            return shape
        }()
        progressLineContainerView.layer.addSublayer(lineShape)
        lineShapeForGradient.strokeEnd = newProgress
        progressLineContainerView.layer.addSublayer(lineShapeForGradient)
        progressLineContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.mask = lineShapeForGradient
        backgroundLayer = lineShape
        layers.append((shape: lineShapeForGradient, gradient: gradientLayer))
        backgroundLayer.strokeColor = R.color.stepsWidget.backgroundLine()?.cgColor
      
//        self.gradientLayer.frame = CGRect(
//            origin: .zero,
//            size: CGSize(
//                width: self.bounds.width * newProgress + self.bounds.height,
//                height: self.bounds.height
//            )
//        )
    }
    
    private func didChangeSteps() {
        bottomLabel.attributedText = String(steps).attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(R.color.stepsWidget.secondGradientColor()),
                    .font(R.font.sfProRoundedBold(size: 18))
                ]
            )
        ])
    }
    
    private func didChangeProgress() {
        if progress <= 1 {
            imageView.image = progress < 1
            ? R.image.stepsWidget.flaG()
            : R.image.stepsWidget.performedFlag()
            
            guard let progressLayer = layers.first else {
                return
            }
            progressLayer.gradient.endPoint = CGPoint(
                x: progress <= 0.4 ? progress + 0.2 : 0.2,
                y: progress <= 0.4 ? 0 : progress
            )
            progressLayer.shape.strokeEnd = progress
        } else {
            if layers.count == 2 {
                guard let progressLayer = layers.last else {
                    return
                }
                let progress = progress.truncatingRemainder(dividingBy: 1)
                progressLayer.gradient.endPoint = CGPoint(
                    x: progress <= 0.4 ? progress + 0.2 : 0.2,
                    y: progress <= 0.4 ? 0 : progress
                )
                progressLayer.shape.strokeEnd = progress
            } else {
                imageView.image = R.image.stepsWidget.overfulfilledFlag()
                
                guard let progressLayerFirst = layers.first else {
                    return
                }
                let progressLayerLast = getProgressLayers(
                    rect: bounds,
                    progress: progress.truncatingRemainder(dividingBy: 1)
                )
                layers.append(progressLayerLast)
                layer.addSublayer(progressLayerLast.gradient)

                progressLayerFirst.gradient.endPoint = CGPoint(
                    x: 0.2,
                    y: 1
                )
                progressLayerFirst.shape.strokeEnd = 1
            }
        }
    }
    
    private func drawProgressCurve(rect: CGRect, progress: CGFloat) {
        if progress <= 1 {
            layers.append(getProgressLayers(rect: rect, progress: progress))
        } else {
            layers.append(getProgressLayers(rect: rect, progress: 1))
            layers.append(getProgressLayers(rect: rect, progress: progress.truncatingRemainder(dividingBy: 1)))
        }

        layers.forEach { progressLineContainerView.layer.addSublayer($0.gradient) }
    }
    
    private func drawBackgroundCurve(rect: CGRect) {
        let shape = getProgressLayers(rect: rect, progress: 1).shape
        shape.strokeColor = R.color.stepsWidget.backgroundLine()?.cgColor
        shape.zPosition = -1
        layer.addSublayer(shape)
    }
    
    private func getProgressLayers(rect: CGRect,
                                   progress: CGFloat) -> (shape: CAShapeLayer, gradient: CAGradientLayer) {
        
        let spacing: CGFloat = 14
        let rectShape = CGRect(
            x: spacing,
            y: spacing,
            width: rect.width - 2 * spacing,
            height: rect.height - 2 * spacing
        )
        
        let progressLayers = (shape: getShape(rect: rectShape), gradient: getGradientLayer(progress: progress))
        
        progressLayers.shape.strokeEnd = progress
        progressLayers.gradient.frame = rect
        progressLayers.gradient.mask = progressLayers.shape
        progressLayers.gradient.zPosition = -1
        
        return progressLayers
    }
    
    private func getGradientLayer(progress: CGFloat) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = UIColor.gradient.compactMap { $0?.cgColor }
        layer.startPoint = CGPoint(x: 0.1, y: 0)
        layer.endPoint = CGPoint(
            x: progress <= 0.4 ? progress + 0.2 : 0.2,
            y: progress <= 0.4 ? 0 : progress
        )
        return layer
    }
    
    private func getCircle(point: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: point,
            radius: 6,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        let circlePath = CAShapeLayer()
        circlePath.path = path.cgPath
        circlePath.zPosition = -1
        circlePath.fillColor = R.color.stepsWidget.ringColor()?.cgColor
        return circlePath
    }
    
    private func getShape(rect: CGRect) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = getPath(rect: rect).cgPath
        shape.lineWidth = 12
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        return shape
    }
    
    private func getPath(rect: CGRect) -> UIBezierPath {
        let radius: CGFloat = rect.height / 4.0
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(
            x: rect.origin.x + rect.width - radius,
            y: rect.origin.y
        ))
        path.addArc(
            withCenter: CGPoint(
                x: rect.origin.x + rect.width - radius,
                y: rect.origin.y + radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(
            x: rect.origin.x + radius,
            y: rect.origin.y + 2 * radius
        ))
        path.addArc(
            withCenter: CGPoint(
                x: rect.origin.x + radius,
                y: rect.origin.y + 3 * radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: false
        )
        path.addLine(to: CGPoint(
            x: rect.maxX,
            y: rect.maxY
        ))
        return path
    }

    func startTransitionAnimationAppearing(
        targetView: StepsFullWidgetAnimatableProtocol,
        targetFrame: CGRect,
        completion: @escaping () -> Void
    ) {
        appearingCompletion = completion
        fullWidgetContainer.frame = targetFrame
        fullWidgetContainer.frame.origin.x = compactContainer.frame.origin.x
        fullWidgetContainer.alpha = 0
        
        topTitleLabel.font = R.font.sfProRoundedBold(size: 22)
        updateTopLabelFull()
        mainButton.sizeToFit()
        closeButton.sizeToFit()
        addSubview(fullWidgetContainer)
        mainButton.layer.zPosition = 2
        closeButton.layer.zPosition = 2
        fullWidgetContainer.addSubviews(mainButton, closeButton)
        closeButton.frame = targetView.closeButtonFrame()
        closeButton.frame.origin.x = targetFrame.maxX
        mainButton.frame = targetView.getMainButtonFrame()
        mainButton.frame.origin.x = targetFrame.maxX
        CATransaction.begin()
        CATransaction.setDisableActions(true)
      
        topTitleLabel.animate(
            font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
            duration: 0.3
        )
        
        bottomLabel.animate(
            font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
            duration: 0.3
        )
        
        // Individual animators

        let topTitleLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        topTitleLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        topTitleLayerZPositionAnimation.keyTimes = [0, 0.5]
        topTitleLayerZPositionAnimation.duration = 0.6
        topTitleLayerZPositionAnimation.isAdditive = true
        
        let bottomTitleLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        bottomTitleLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        bottomTitleLayerZPositionAnimation.keyTimes = [0, 0.5]
        bottomTitleLayerZPositionAnimation.duration = 0.6
        bottomTitleLayerZPositionAnimation.isAdditive = true
        
        let progressContainerLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        progressContainerLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        progressContainerLayerZPositionAnimation.keyTimes = [0, 0.5]
        progressContainerLayerZPositionAnimation.duration = 0.6
        progressContainerLayerZPositionAnimation.isAdditive = true
        var adjustmentFrame = targetView.getFrameForTopTitle()
        adjustmentFrame.size.width = topTitleLabel.frame.width + 4 + bottomLabel.frame.width
        adjustmentFrame.origin.x = targetFrame.midX - adjustmentFrame.width / 2
        let string = Text.steps
        let font = R.font.sfProRoundedBold(size: 22)
        let color = R.color.stepsWidget.secondGradientColor()
        let image = R.image.stepsWidget.foot()
        
        topTitleLabel.attributedText = string.attributedSring(
            [.init(
                worldIndex: [0],
                attributes: [.color(color), .font(font)]
            )],
            image: .init(
                image: image,
                font: font,
                position: .left
            )
        )
        let imageViewLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        imageViewLayerZPositionAnimation.values = [imageView.layer.zPosition, 5]
        imageViewLayerZPositionAnimation.keyTimes = [0, 0.5]
        imageViewLayerZPositionAnimation.duration = 0.6
        imageViewLayerZPositionAnimation.isAdditive = true
        
        let flagImageFrame = targetView.getFlagFrame()
        let imageViewLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        imageViewLayerPositionAnimation.fromValue = imageView.layer.position
        imageViewLayerPositionAnimation.toValue = CGPoint(
            x: flagImageFrame.midX,
            y: flagImageFrame.midY
        )
//        didChangeProgress()
        circleLayer.opacity = 0
        imageViewLayerPositionAnimation.mass = 0.5
        imageViewLayerPositionAnimation.initialVelocity = 0.8
        imageViewLayerPositionAnimation.damping = 12
        imageViewLayerPositionAnimation.duration = imageViewLayerPositionAnimation.settlingDuration
        
        let topTitleLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        topTitleLayerPositionAnimation.fromValue = topTitleLabel.layer.position
        topTitleLayerPositionAnimation.toValue = CGPoint(
            x: adjustmentFrame.origin.x + topTitleLabel.frame.width / 2,
            y: adjustmentFrame.origin.y + topTitleLabel.frame.height / 2
        )
        
        topTitleLayerPositionAnimation.mass = 0.5
        topTitleLayerPositionAnimation.initialVelocity = 0.8
        topTitleLayerPositionAnimation.damping = 11
        topTitleLayerPositionAnimation.duration = topTitleLayerPositionAnimation.settlingDuration
        
        let bottomTitleLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        bottomTitleLayerPositionAnimation.fromValue = bottomLabel.layer.position
        bottomTitleLayerPositionAnimation.toValue = CGPoint(
            x: adjustmentFrame.origin.x + topTitleLabel.frame.width + 4 + bottomLabel.frame.width / 2,
            y: adjustmentFrame.origin.y + bottomLabel.frame.height / 2
        )
        
        bottomTitleLayerPositionAnimation.mass = 0.5
        bottomTitleLayerPositionAnimation.initialVelocity = 0.8
        bottomTitleLayerPositionAnimation.damping = 11
        bottomTitleLayerPositionAnimation.duration = topTitleLayerPositionAnimation.settlingDuration
        let bottomLabelGroup = CAAnimationGroup()
        bottomLabelGroup.animations = [bottomTitleLayerZPositionAnimation, bottomTitleLayerPositionAnimation]
        bottomLabelGroup.duration = 0.6
        bottomLabelGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        bottomLabelGroup.fillMode = .forwards
        bottomLabelGroup.isRemovedOnCompletion = false
        
        let mainButtonFrame = targetView.getMainButtonFrame()
        let mainButtonLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        mainButtonLayerPositionAnimation.fromValue = mainButton.layer.position
        mainButtonLayerPositionAnimation.toValue = CGPoint(
            x: mainButtonFrame.midX,
            y: mainButtonFrame.midY
        )
        
        mainButtonLayerPositionAnimation.mass = 0.5
        mainButtonLayerPositionAnimation.initialVelocity = 0.3
        mainButtonLayerPositionAnimation.damping = 11
        mainButtonLayerPositionAnimation.duration = mainButtonLayerPositionAnimation.settlingDuration
        mainButtonLayerPositionAnimation.isRemovedOnCompletion = false
        mainButtonLayerPositionAnimation.isCumulative = true
        mainButtonLayerPositionAnimation.fillMode = .forwards
        mainButton.layer.add(mainButtonLayerPositionAnimation, forKey: nil)
        let closeButtonFrame = targetView.closeButtonFrame()
        let closeButtonLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        closeButtonLayerPositionAnimation.fromValue = mainButton.layer.position
        closeButtonLayerPositionAnimation.toValue = CGPoint(
            x: targetFrame.midX,
            y: closeButton.layer.position.y
        )
        
        closeButtonLayerPositionAnimation.mass = 0.5
        closeButtonLayerPositionAnimation.initialVelocity = 0.3
        closeButtonLayerPositionAnimation.damping = 11
        closeButtonLayerPositionAnimation.duration = mainButtonLayerPositionAnimation.settlingDuration
        closeButtonLayerPositionAnimation.isRemovedOnCompletion = false
        closeButtonLayerPositionAnimation.isCumulative = true
        closeButtonLayerPositionAnimation.fillMode = .forwards
        closeButton.layer.add(closeButtonLayerPositionAnimation, forKey: nil)
    
        let topTitleGroup = CAAnimationGroup()
        topTitleGroup.animations = [topTitleLayerZPositionAnimation, topTitleLayerPositionAnimation]
        topTitleGroup.duration = 0.6
        topTitleGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        topTitleGroup.fillMode = .forwards
        topTitleGroup.isRemovedOnCompletion = false
  
        let targetProgressLineContainerFrame = targetView.getProgressContainerFrame()
        let progressLineBoundsAnimator = CASpringAnimation(keyPath: "bounds")
        progressLineBoundsAnimator.fromValue = progressLineContainerView.bounds
        progressLineBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetProgressLineContainerFrame.width,
            height: targetProgressLineContainerFrame.height
        )
        progressLineBoundsAnimator.mass = 0.5
        progressLineBoundsAnimator.initialVelocity = 0.8
        progressLineBoundsAnimator.damping = 11
        progressLineBoundsAnimator.duration = progressLineBoundsAnimator.settlingDuration
        
        let progressLinePositionAnimator = CASpringAnimation(keyPath: "position")
        progressLinePositionAnimator.fromValue = progressLineContainerView.layer.position
        progressLinePositionAnimator.toValue = CGPoint(
            x: targetProgressLineContainerFrame.midX,
            y: targetProgressLineContainerFrame.midY
        )
        progressLinePositionAnimator.mass = 0.5
        progressLinePositionAnimator.initialVelocity = 0.8
        progressLinePositionAnimator.damping = 11
        progressLinePositionAnimator.duration = progressLinePositionAnimator.settlingDuration
        
        let progressContainerGroup = CAAnimationGroup()
        progressContainerGroup.animations = [
            progressContainerLayerZPositionAnimation,
            progressLinePositionAnimator,
            progressLineBoundsAnimator
        ]
        progressContainerGroup.duration = 0.6
        progressContainerGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        progressContainerGroup.fillMode = .forwards
        progressContainerGroup.isRemovedOnCompletion = false
        
        let imageViewGroup = CAAnimationGroup()
        imageViewGroup.animations = [
            imageViewLayerPositionAnimation,
            imageViewLayerZPositionAnimation
        ]
        imageViewGroup.duration = 0.6
        imageViewGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        imageViewGroup.fillMode = .forwards
        imageViewGroup.isRemovedOnCompletion = false
        
        let linePath = targetView.getStraightLinePath()
    
        let backgroundPathAnimator = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        backgroundPathAnimator.fromValue = backgroundLayer.path
        backgroundPathAnimator.toValue = linePath
        backgroundPathAnimator.duration = 0.3
        backgroundPathAnimator.isCumulative = true
        backgroundPathAnimator.fillMode = .forwards
        backgroundPathAnimator.isAdditive = true
        backgroundPathAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        backgroundPathAnimator.isRemovedOnCompletion = false
       
        let progressLinePathAnimator = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        progressLinePathAnimator.fromValue = layers.first?.shape.path
        progressLinePathAnimator.toValue = linePath
        progressLinePathAnimator.duration = 0.3
        progressLinePathAnimator.isCumulative = true
        progressLinePathAnimator.isAdditive = true
        progressLinePathAnimator.fillMode = .forwards
        progressLinePathAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        progressLinePathAnimator.isRemovedOnCompletion = false
//        let backgroundPathGroup = CAAnimationGroup()
//        backgroundPathGroup.animations = [backgroundPathAnimator]
//        backgroundPathGroup.duration = 0.6
//        backgroundPathGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        backgroundPathGroup.fillMode = .forwards
//        backgroundPathGroup.isRemovedOnCompletion = false
        topTitleLabel.layer.add(topTitleGroup, forKey: nil)
        bottomLabel.layer.add(bottomLabelGroup, forKey: nil)
        progressLineContainerView.clipsToBounds = false
        progressLineContainerView.layer.add(progressContainerGroup, forKey: nil)
       
        backgroundLayer.add(backgroundPathAnimator, forKey: "path")

        imageView.layer.add(imageViewGroup, forKey: nil)

        layers.first?.shape.add(progressLinePathAnimator, forKey: "path")
//        progressLineContainerView.frame = CGRect(
//            x: targetFrame.origin.x + 10,
//            y: adjustmentFrame.maxY,
//            width: targetFrame.width - 32,
//            height: 33.fitH
//        )
        layers.first?.gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: progressLineContainerView.frame.width - 6,
            height: 37.fitH
        )

        let mainWidgetFrameAnimation = CASpringAnimation(keyPath: "bounds")
        mainWidgetFrameAnimation.fromValue = fullWidgetContainer.frame
        mainWidgetFrameAnimation.toValue = targetFrame
        mainWidgetFrameAnimation.mass = 0.5
        mainWidgetFrameAnimation.initialVelocity = 0.8
        mainWidgetFrameAnimation.damping = 11
        mainWidgetFrameAnimation.duration = mainWidgetFrameAnimation.settlingDuration
        
        let mainWidgetPositionAnimation = CABasicAnimation(keyPath: "position")
        mainWidgetPositionAnimation.fromValue = fullWidgetContainer.layer.position
        mainWidgetPositionAnimation.toValue = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
        mainWidgetPositionAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        mainWidgetPositionAnimation.mass = 0.5
//        mainWidgetPositionAnimation.initialVelocity = 0.8
//        mainWidgetPositionAnimation.damping = 10
        mainWidgetPositionAnimation.duration = 0.3 // mainWidgetPositionAnimation.settlingDuration
//        fullWidgetContainer.layer.add(mainWidgetFrameAnimation, forKey: "frame")
        let fullWidgetAlphaAnimator = CABasicAnimation(keyPath: "opacity")
        fullWidgetAlphaAnimator.fromValue = fullWidgetContainer.layer.opacity
        fullWidgetAlphaAnimator.toValue = 1
        fullWidgetAlphaAnimator.duration = 0.3
//        fullWidgetContainer.layer.add(fullWidgetAlphaAnimator, forKey: "opacity")
        let fullWidgetGroup = CAAnimationGroup()
        fullWidgetGroup.animations = [fullWidgetAlphaAnimator, mainWidgetFrameAnimation, mainWidgetPositionAnimation]
        fullWidgetGroup.duration = 0.6
        fullWidgetGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        fullWidgetGroup.fillMode = .forwards
        fullWidgetGroup.isRemovedOnCompletion = false
     
//        self.apearingAnimationFinishGroup = fullWidgetGroup
        fullWidgetGroup.delegate = self
        fullWidgetContainer.layer.add(fullWidgetGroup, forKey: nil)
        fullWidgetContainer.frame = targetFrame
        fullWidgetContainer.alpha = 1
        topTitleLabel.layer.zPosition = 2
        bottomLabel.layer.zPosition = 2
        progressLineContainerView.layer.zPosition = 2
        imageView.layer.zPosition = 2
        let controlPoints = targetView.getGradientControlPoints()
        let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
        let gradientLayerBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        gradientLayerBoundsAnimator.duration = 0.3
        gradientLayerBoundsAnimator.fromValue = layers.first?.gradient.bounds
        gradientLayerBoundsAnimator.toValue = CGRect(
            x: .zero,
            y: .zero,
            width: targetProgressLineContainerFrame.width * newProgress + targetProgressLineContainerFrame.height,
            height: targetProgressLineContainerFrame.height
        )
        gradientLayerBoundsAnimator.fillMode = .forwards
        gradientLayerBoundsAnimator.isRemovedOnCompletion = false
        gradientLayerBoundsAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        gradientLayerBoundsAnimator.isCumulative = true
        let targetGradientFrame = CGRect(
            x: 0,
            y: 0,
            width: targetProgressLineContainerFrame.width * newProgress + targetProgressLineContainerFrame.height,
            height: targetProgressLineContainerFrame.height
        )
        let gradientLayerPositionAnimator = CABasicAnimation(keyPath: "position")
        gradientLayerPositionAnimator.duration = 0.3
        gradientLayerPositionAnimator.fromValue = layers.first?.gradient.position
        gradientLayerPositionAnimator.toValue = CGPoint(
            x: targetGradientFrame.midX,
            y: targetGradientFrame.midY
        )
        gradientLayerPositionAnimator.fillMode = .forwards
        gradientLayerPositionAnimator.isRemovedOnCompletion = false
        gradientLayerPositionAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        gradientLayerPositionAnimator.isCumulative = true
      
        let shapeLayerStrokeEndAnimator = CABasicAnimation(keyPath: "strokeEnd")
        shapeLayerStrokeEndAnimator.fromValue = layers.first?.shape.strokeEnd
        shapeLayerStrokeEndAnimator.toValue = newProgress
        shapeLayerStrokeEndAnimator.duration = 0.3
        shapeLayerStrokeEndAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        shapeLayerStrokeEndAnimator.fillMode = .forwards
        shapeLayerStrokeEndAnimator.isRemovedOnCompletion = false
        
        let gradientGroup = CAAnimationGroup()
        gradientGroup.animations = [
            gradientLayerBoundsAnimator,
            gradientLayerPositionAnimator
        ]
        gradientGroup.duration = 0.3
        gradientGroup.fillMode = .forwards
        gradientGroup.isRemovedOnCompletion = false
        layers.first?.gradient.add(gradientGroup, forKey: nil)
        layers.first?.shape.add(shapeLayerStrokeEndAnimator, forKey: "strokeEnd")
        layers.first?.gradient.startPoint = controlPoints.startPoint
        layers.first?.gradient.endPoint = controlPoints.endPoint
        CATransaction.commit()
     
//        layers.first?.shape.strokeEnd = newProgress
      
    }
    
    func showMainAndCloseButton() {
        
    }
    
    func startTransitionAnimationDisappearing(
        targetView: StepsWidgetFullToCompactAnimatableProtocol,
        targetFrame: CGRect,
        completion: @escaping () -> Void
    ) {
        disappearingCompletion = completion
        let date = UDM.currentlyWorkingDay.date ?? Date()
        let now = StepsWidgetService.shared.getStepsForDate(date)
        bottomLabel.attributedText = String(Int(now)).attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(R.color.stepsWidget.secondGradientColor()),
                    .font(R.font.sfProRoundedBold(size: 18))
                ]
            )
        ])
       
        
        // Individual animators
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if
            
            let topTitleString = topTitleLabel.text,
            let bottomTitleString = bottomLabel.text {
            topTitleLabel.animate(
                font: R.font.sfProRoundedBold(size: 18.fitW) ?? .systemFont(ofSize: 22),
                duration: 0.3
            )
            
            bottomLabel.animate(
                font: R.font.sfProRoundedBold(
                    size: 18
                ) ?? .systemFont(ofSize: 18.fitW),
                duration: 0.3
            )
        }
        let topTitleLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        topTitleLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        topTitleLayerZPositionAnimation.keyTimes = [0, 0.5]
        topTitleLayerZPositionAnimation.duration = 0.6
        topTitleLayerZPositionAnimation.isAdditive = true
        
        let bottomTitleLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        bottomTitleLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        bottomTitleLayerZPositionAnimation.keyTimes = [0, 0.5]
        bottomTitleLayerZPositionAnimation.duration = 0.6
        bottomTitleLayerZPositionAnimation.isAdditive = true
        
        let progressContainerLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        progressContainerLayerZPositionAnimation.values = [topTitleLabel.layer.zPosition, 2]
        progressContainerLayerZPositionAnimation.keyTimes = [0, 0.5]
        progressContainerLayerZPositionAnimation.duration = 0.6
        progressContainerLayerZPositionAnimation.isAdditive = true
        topTitleLabel.layer.add(topTitleLayerZPositionAnimation, forKey: "zPosition")
        bottomLabel.layer.add(bottomTitleLayerZPositionAnimation, forKey: "zPosition")
        // MARK: - Container
        let containerBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        containerBoundsAnimator.duration = 0.4
        containerBoundsAnimator.fromValue = targetFrame
        containerBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetFrame.width,
            height: targetFrame.height
        )
        containerBoundsAnimator.duration = 0.4
        containerBoundsAnimator.isCumulative = true
        containerBoundsAnimator.isRemovedOnCompletion = false
        
        let containerPositionAnimation = CASpringAnimation(keyPath: "position")
        containerPositionAnimation.fromValue = fullWidgetContainer.layer.position
        containerPositionAnimation.toValue = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
        containerPositionAnimation.duration = 0.4
        containerPositionAnimation.initialVelocity = 0.8
        containerPositionAnimation.damping = 12
        containerPositionAnimation.mass = 0.5
        containerPositionAnimation.isCumulative = true
        containerPositionAnimation.isRemovedOnCompletion = false
        containerPositionAnimation.fillMode = .forwards
        
        let fullWidgetContainerGroup = CAAnimationGroup()
        fullWidgetContainerGroup.animations = [containerBoundsAnimator, containerPositionAnimation]
        fullWidgetContainerGroup.fillMode = .forwards
        fullWidgetContainerGroup.isRemovedOnCompletion = false
        fullWidgetContainerGroup.duration = 0.4
        fullWidgetContainerGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        fullWidgetContainerGroup.delegate = self
        fullWidgetContainer.layer.add(fullWidgetContainerGroup, forKey: "nil")
//        fullWidgetContainer.frame = targetFrame
        // MARK: - Top title
        let targetTopTitleLabelFrame = targetView.getTopTilteFrame()
        
        let topTitleBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        topTitleBoundsAnimator.duration = 0.3
        topTitleBoundsAnimator.fromValue = topTitleLabel.bounds
        topTitleBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetTopTitleLabelFrame.width,
            height: targetTopTitleLabelFrame.height
        )
        topTitleBoundsAnimator.duration = 0.3
        topTitleBoundsAnimator.isCumulative = true
        topTitleBoundsAnimator.fillMode = .forwards
        topTitleBoundsAnimator.isRemovedOnCompletion = false
        
        let topTitlePositionAnimator = CABasicAnimation(keyPath: "position")
        topTitlePositionAnimator.fromValue = topTitleLabel.layer.position
        topTitlePositionAnimator.toValue = CGPoint(x: targetTopTitleLabelFrame.midX, y: targetTopTitleLabelFrame.midY)
        topTitlePositionAnimator.duration = 0.3
        topTitlePositionAnimator.isRemovedOnCompletion = false
        topTitlePositionAnimator.isCumulative = true
        topTitlePositionAnimator.fillMode = .forwards
        
        let targetTopTitleGroup = CAAnimationGroup()
        targetTopTitleGroup.animations = [topTitlePositionAnimator, topTitleBoundsAnimator]
        targetTopTitleGroup.fillMode = .forwards
        targetTopTitleGroup.isRemovedOnCompletion = false
        targetTopTitleGroup.duration = 0.3
        targetTopTitleGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        topTitleLabel.layer.add(targetTopTitleGroup, forKey: nil)
        
        // MARK: - Bottom title
        let targetBottomTitleLabelFrame = targetView.getBottomTitleFrame()
        
        let bottomTitleBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        bottomTitleBoundsAnimator.duration = 0.3
        bottomTitleBoundsAnimator.fromValue = bottomLabel.bounds
        bottomTitleBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetBottomTitleLabelFrame.width,
            height: targetBottomTitleLabelFrame.height
        )
        bottomTitleBoundsAnimator.duration = 0.3
        bottomTitleBoundsAnimator.isCumulative = true
        bottomTitleBoundsAnimator.fillMode = .forwards
        bottomTitleBoundsAnimator.isRemovedOnCompletion = false
        
        let bottomTitlePositionAnimator = CABasicAnimation(keyPath: "position")
        bottomTitlePositionAnimator.fromValue = bottomLabel.layer.position
        bottomTitlePositionAnimator.toValue = CGPoint(
            x: targetBottomTitleLabelFrame.midX,
            y: targetBottomTitleLabelFrame.midY
        )
        bottomTitlePositionAnimator.duration = 0.3
        bottomTitlePositionAnimator.isCumulative = true
        bottomTitlePositionAnimator.isRemovedOnCompletion = false
        bottomTitlePositionAnimator.fillMode = .forwards
        
        let targetBottomTitleGroup = CAAnimationGroup()
        targetBottomTitleGroup.animations = [bottomTitlePositionAnimator, bottomTitleBoundsAnimator]
        targetBottomTitleGroup.fillMode = .forwards
        targetBottomTitleGroup.isRemovedOnCompletion = false
        targetBottomTitleGroup.duration = 0.3
        targetBottomTitleGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        bottomLabel.layer.add(targetBottomTitleGroup, forKey: nil)
        
        // MARK: - Flag image
        let targetFlagFrame = targetView.getFlagFrame()
        
        let flagBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        flagBoundsAnimator.duration = 0.4
        flagBoundsAnimator.fromValue = imageView.bounds
        flagBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetFlagFrame.width,
            height: targetFlagFrame.height
        )
 
        let flagPositionAnimator = CABasicAnimation(keyPath: "position")
        flagPositionAnimator.fromValue = imageView.layer.position
        flagPositionAnimator.toValue = CGPoint(
            x: targetFlagFrame.midX,
            y: targetFlagFrame.midY
        )
        flagPositionAnimator.duration = 0.4
        
        let flagGroupGroup = CAAnimationGroup()
        flagGroupGroup.animations = [flagPositionAnimator, flagBoundsAnimator]
        flagGroupGroup.fillMode = .forwards
        flagGroupGroup.isRemovedOnCompletion = false
        flagGroupGroup.duration = 0.4
        flagGroupGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        imageView.layer.add(flagGroupGroup, forKey: nil)
        
        // MARK: - Progress container
        let targetProgerssFrame = targetView.getProgressLineFrame()
        
        let progressContainerBoundsAnimator = CABasicAnimation(keyPath: "bounds")
        progressContainerBoundsAnimator.duration = 0.4
        progressContainerBoundsAnimator.fromValue = progressLineContainerView.bounds
        progressContainerBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetProgerssFrame.width,
            height: targetProgerssFrame.height
        )
        progressContainerBoundsAnimator.duration = 0.4
        progressContainerBoundsAnimator.isRemovedOnCompletion = false
        progressContainerBoundsAnimator.fillMode = .forwards
        progressContainerBoundsAnimator.isCumulative = true
        
        let progressContainerPositionAnimator = CABasicAnimation(keyPath: "position")
        progressContainerPositionAnimator.fromValue = imageView.layer.position
        progressContainerPositionAnimator.toValue = CGPoint(
            x: targetProgerssFrame.midX,
            y: targetProgerssFrame.midY
        )
        progressContainerPositionAnimator.duration = 0.4
        progressContainerPositionAnimator.isCumulative = true
        progressContainerPositionAnimator.isRemovedOnCompletion = false
        progressContainerPositionAnimator.fillMode = .forwards
        
        
        let progressContainerGroup = CAAnimationGroup()
        progressContainerGroup.animations = [progressContainerPositionAnimator, progressContainerBoundsAnimator]
        progressContainerGroup.fillMode = .forwards
        progressContainerGroup.isRemovedOnCompletion = false
        progressContainerGroup.duration = 0.4
        progressContainerGroup.beginTime = 1
        progressContainerGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        progressLineContainerView.layer.add(progressContainerGroup, forKey: nil)
        progressLineContainerView.frame = targetProgerssFrame
        // MARK: - Progress shapes
        let targetBackgroundPath = targetView.getBackgroundLinePath()
        var targetBackgroundBounds = targetProgerssFrame
        targetBackgroundBounds.origin = .zero
        let shape = getProgressLayers(rect: targetBackgroundBounds, progress: 1).shape

        let progressBackgroundPathAnimator = CABasicAnimation(keyPath: "path")
        progressBackgroundPathAnimator.fromValue = backgroundLayer.path
        progressBackgroundPathAnimator.toValue = shape.path
        progressBackgroundPathAnimator.duration = 0.01
        progressBackgroundPathAnimator.isCumulative = true
        progressBackgroundPathAnimator.fillMode = .forwards
        progressBackgroundPathAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        progressBackgroundPathAnimator.isRemovedOnCompletion = false
        backgroundLayer.add(progressBackgroundPathAnimator, forKey: nil)
        layers.first?.shape.frame = targetBackgroundBounds
        layers.first?.gradient.frame = targetBackgroundBounds
        layers.first?.shape.path = shape.path
        layers.first?.gradient.mask = shape
        shape.strokeEnd = progress
        let mainButtonPositionAnimator = CABasicAnimation(keyPath: "position")
        mainButtonPositionAnimator.duration = 0.01
        mainButtonPositionAnimator.fromValue = mainButton.layer.position
        mainButtonPositionAnimator.toValue = CGPoint(
            x: frame.maxX + mainButton.frame.width,
            y: mainButton.layer.position.y
        )
        mainButtonPositionAnimator.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        mainButtonPositionAnimator.isRemovedOnCompletion = false
        mainButtonPositionAnimator.fillMode = .forwards
        let mainButtonOpacityAnimator = CABasicAnimation(keyPath: "opacity")
        mainButtonOpacityAnimator.duration = 0.01
        mainButtonOpacityAnimator.fromValue = 1
        mainButtonOpacityAnimator.toValue = 0
        mainButtonOpacityAnimator.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        mainButtonOpacityAnimator.isRemovedOnCompletion = false
        mainButtonOpacityAnimator.fillMode = .forwards
        let closeButtonPositionAnimator = CABasicAnimation(keyPath: "position")
        closeButtonPositionAnimator.duration = 0.01
        mainButtonPositionAnimator.toValue = CGPoint(
            x: frame.maxX + closeButton.frame.width,
            y: closeButton.layer.position.y
        )
        closeButtonPositionAnimator.fromValue = closeButton.layer.position
        closeButtonPositionAnimator.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        closeButtonPositionAnimator.isRemovedOnCompletion = false
        closeButtonPositionAnimator.fillMode = .forwards
        let closeButtonOpacityAnimator = CABasicAnimation(keyPath: "opacity")
        closeButtonOpacityAnimator.duration = 0.01
        closeButtonOpacityAnimator.toValue = 0
        closeButtonOpacityAnimator.fromValue = 1
        closeButtonOpacityAnimator.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        closeButtonOpacityAnimator.isRemovedOnCompletion = false
        closeButtonOpacityAnimator.fillMode = .forwards
        let closeButtonGroup = CAAnimationGroup()
        closeButtonGroup.animations = [closeButtonOpacityAnimator, closeButtonPositionAnimator]
        closeButtonGroup.duration = 0.4
        closeButtonGroup.isRemovedOnCompletion = false
        closeButtonGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        closeButtonGroup.fillMode = .forwards
        let mainButtonGroup = CAAnimationGroup()
        mainButtonGroup.animations = [mainButtonOpacityAnimator, mainButtonPositionAnimator]
        mainButtonGroup.duration = 0.01
        mainButtonGroup.isRemovedOnCompletion = false
        mainButtonGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        mainButtonGroup.fillMode = .forwards
        closeButton.layer.add(closeButtonGroup, forKey: nil)
        mainButton.layer.add(mainButtonGroup, forKey: nil)
        CATransaction.commit()
        adjustGradientFrame()
        //        layers.first?.shape.strokeEnd = newProgress
      
    }
    
    private func adjustGradientFrame() {
        if progress <= 1 {
            imageView.image = progress < 1
            ? R.image.stepsWidget.flaG()
            : R.image.stepsWidget.performedFlag()
            
            guard let progressLayer = layers.first else { return }
            progressLayer.gradient.endPoint = CGPoint(
                x: progress <= 0.4 ? progress + 0.2 : 0.2,
                y: progress <= 0.4 ? 0 : progress
            )
            progressLayer.shape.strokeEnd = progress
        } else {
            if layers.count == 2 {
                guard let progressLayer = layers.last else { return }
                let progress = progress.truncatingRemainder(dividingBy: 1)
                progressLayer.gradient.endPoint = CGPoint(
                    x: progress <= 0.4 ? progress + 0.2 : 0.2,
                    y: progress <= 0.4 ? 0 : progress
                )
                progressLayer.shape.strokeEnd = progress
            } else {
                imageView.image = R.image.stepsWidget.overfulfilledFlag()
                
                guard let progressLayerFirst = layers.first else { return }
                let progressLayerLast = getProgressLayers(
                    rect: bounds,
                    progress: progress.truncatingRemainder(dividingBy: 1)
                )
                layers.append(progressLayerLast)
                layer.addSublayer(progressLayerLast.gradient)

                progressLayerFirst.gradient.endPoint = CGPoint(
                    x: 0.2,
                    y: 1
                )
                progressLayerFirst.shape.strokeEnd = 1
            }
        }
    }
    
    private func updateGradient() {
        layers.first?.gradient.startPoint = CGPoint(x: 0, y: 0.7)
        layers.first?.gradient.endPoint = CGPoint(x: 0.5, y: 0.7)
    }
    
    private func updateTopLabelFull() {
        let date = UDM.currentlyWorkingDay.date ?? Date()
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = Int(StepsWidgetService.shared.getStepsForDate(date))
        let progress = Double(now) / Double(goal ?? 1)
        let leftColor = R.color.stepsWidget.secondGradientColor()
        let rightColor = R.color.stepsWidget.ringColor()
        let font = R.font.sfProRoundedBold(size: 22)
        let image = R.image.stepsWidget.foot()
        let leftAtributes: [StringSettings] = [.font(font), .color(leftColor)]
        let rightAtributes: [StringSettings] = [.font(font), .color(rightColor)]
        
        let string = goal != nil
            ? "\(now) / \(goal ?? 0)"
            : "\(now)"
        
        if goal == nil {
            bottomLabel.attributedText = string.attributedSring(
                [.init(worldIndex: [0, 1], attributes: leftAtributes)]
            )
        } else {
            bottomLabel.attributedText = string.attributedSring(
                [
                    .init(worldIndex: [0], attributes: leftAtributes),
                    .init(worldIndex: [1, 2], attributes: rightAtributes)
                ]
            )
        }
        
        mainButton.defaultTitle = goal == nil
        ? " \(R.string.localizable.stepsWidgetSetDailyGoal())"
        : " \(R.string.localizable.stepsWidgetChangeDailyGoal())"
        mainButton.isPressTitle = goal == nil
        ? " \(R.string.localizable.stepsWidgetSetDailyGoal())"
        : " \(R.string.localizable.stepsWidgetChangeDailyGoal())"
    }
    
    func calculateAdjustmentRectForFullWidget(for targetFrame: CGRect) -> CGRect {
        topTitleLabel.sizeToFit()
        bottomLabel.sizeToFit()
        var frame = CGRect(
            x: 0,
            y: 0,
            width: topTitleLabel.intrinsicContentSize.width + 5 + bottomLabel.intrinsicContentSize.width,
            height: 24
        )
        
        frame.origin.x = targetFrame.midX - frame.width / 2
        frame.origin.y = targetFrame.origin.y + 32
        return frame
    }
}

extension StepsWidgetAnimatableContainer {
    struct Text {
        static let steps = " \(R.string.localizable.diagramChartTypeStepsTitle())"
    }
}

private extension UIColor {
    static let gradient = [
        R.color.stepsWidget.firstGradientColor(),
        R.color.stepsWidget.secondGradientColor()
    ]
}

extension StepsWidgetAnimatableContainer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            appearingCompletion?()
            disappearingCompletion?()
            //            }
        } else {
            appearingCompletion?()
            disappearingCompletion?()
        }
    }
}
