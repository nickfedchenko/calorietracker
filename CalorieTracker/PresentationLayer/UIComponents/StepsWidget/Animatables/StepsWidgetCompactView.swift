//
//  StepsWidgetCompactView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 04.04.2023.
//

import Charts
import UIKit

final class StepsWidgetAnimatableContainer: UIView {
    private var appearingCompletion: (() -> Void)?
    enum StepsAnimatableViewInitialState {
        case compactToFull(compactFrame: CGRect, steps: Int, progress: CGFloat)
        case fullToCompact(fullFrame: CGRect)
    }
    
    private var apearingAnimationFinishGroup: CAAnimationGroup?
    private let compactContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let fullWidgetContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
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
        case .fullToCompact(fullFrame: let frame):
            return
        }
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
//        didChangeProgress()
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
    // swiftlint:disable:next function_body_length
    func startTransitionAnimation(targetFrame: CGRect, completion: @escaping () -> Void) {
        appearingCompletion = completion
        fullWidgetContainer.frame = targetFrame
        fullWidgetContainer.frame.origin.x = compactContainer.frame.origin.x
        fullWidgetContainer.alpha = 0
        
        updateTopLabelFull()
        mainButton.sizeToFit()
        closeButton.sizeToFit()
        addSubview(fullWidgetContainer)
        mainButton.layer.zPosition = 2
        closeButton.layer.zPosition = 2
        fullWidgetContainer.addSubviews(mainButton, closeButton)
       
        closeButton.frame.origin.x = fullWidgetContainer.frame.midX - closeButton.frame.width / 2
        closeButton.frame.origin.y = fullWidgetContainer.frame.maxY - closeButton.frame.height - 16
        
        mainButton.frame.origin.x = fullWidgetContainer.frame.midX - mainButton.frame.width / 2
        mainButton.frame.size.height = 62.fitW
        mainButton.frame.origin.y = closeButton.frame.origin.y - 22.fitH - mainButton.frame.size.height
        mainButton.frame.size.width = targetFrame.width - 32
       
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
        let adjustmentFrame = calculateAdjustmentRectForFullWidget(for: targetFrame)
        let imageViewLayerZPositionAnimation = CAKeyframeAnimation(keyPath: "zPosition")
        imageViewLayerZPositionAnimation.values = [imageView.layer.zPosition, 5]
        imageViewLayerZPositionAnimation.keyTimes = [0, 0.5]
        imageViewLayerZPositionAnimation.duration = 0.6
        imageViewLayerZPositionAnimation.isAdditive = true
        
        let imageViewLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        imageViewLayerPositionAnimation.fromValue = topTitleLabel.layer.position
        imageViewLayerPositionAnimation.toValue = CGPoint(
            x: targetFrame.maxX - 27.5,
            y: adjustmentFrame.maxY + 32.5 * 1.fitH - imageView.intrinsicContentSize.height / 2
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
        
        let mainButtonLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        mainButtonLayerPositionAnimation.fromValue = mainButton.layer.position
        mainButtonLayerPositionAnimation.toValue = CGPoint(
            x: targetFrame.midX,
            y: mainButton.layer.position.y
        )
        
        mainButtonLayerPositionAnimation.mass = 0.5
        mainButtonLayerPositionAnimation.initialVelocity = 0.8
        mainButtonLayerPositionAnimation.damping = 11
        mainButtonLayerPositionAnimation.duration = mainButtonLayerPositionAnimation.settlingDuration
        mainButtonLayerPositionAnimation.isRemovedOnCompletion = false
        mainButtonLayerPositionAnimation.isCumulative = true
        mainButtonLayerPositionAnimation.fillMode = .forwards
        mainButton.layer.add(mainButtonLayerPositionAnimation, forKey: nil)
      
        let closeButtonLayerPositionAnimation = CASpringAnimation(keyPath: "position")
        closeButtonLayerPositionAnimation.fromValue = mainButton.layer.position
        closeButtonLayerPositionAnimation.toValue = CGPoint(
            x: targetFrame.midX,
            y: closeButton.layer.position.y
        )
        
        closeButtonLayerPositionAnimation.mass = 0.5
        closeButtonLayerPositionAnimation.initialVelocity = 0.8
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
  
        let progressLineBoundsAnimator = CASpringAnimation(keyPath: "bounds")
        progressLineBoundsAnimator.fromValue = progressLineContainerView.bounds
        progressLineBoundsAnimator.toValue = CGRect(
            x: 0,
            y: 0,
            width: targetFrame.width - 32,
            height: 33
        )
        progressLineBoundsAnimator.mass = 0.5
        progressLineBoundsAnimator.initialVelocity = 0.8
        progressLineBoundsAnimator.damping = 11
        progressLineBoundsAnimator.duration = progressLineBoundsAnimator.settlingDuration
        
        let progressLinePositionAnimator = CASpringAnimation(keyPath: "position")
        progressLinePositionAnimator.fromValue = progressLineContainerView.layer.position
        progressLinePositionAnimator.toValue = CGPoint(
            x: targetFrame.midX,
            y: adjustmentFrame.maxY + 16.5
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
        
        let linePath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 6, y: 30.5 * 1.fitH))
            path.addLine(to: CGPoint(x: targetFrame.width - 38.2, y: 30.5 * 1.fitH))
            //           path.close()
            return path
        }()
        
        let linePath2: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 6, y: 30.5 * 1.fitH))
            path.addLine(to: CGPoint(x: targetFrame.width - 38.2, y: 30.5 * 1.fitH))
            //           path.close()
            return path
        }()
    
        let backgroundPathAnimator = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        backgroundPathAnimator.fromValue = backgroundLayer.path
        backgroundPathAnimator.toValue = linePath2.cgPath
        backgroundPathAnimator.duration = 0.3
        backgroundPathAnimator.isCumulative = true
        backgroundPathAnimator.fillMode = .forwards
        backgroundPathAnimator.isAdditive = true
        backgroundPathAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        backgroundPathAnimator.isRemovedOnCompletion = false
       
        let progressLinePathAnimator = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        progressLinePathAnimator.fromValue = layers.first?.shape.path
        progressLinePathAnimator.toValue = linePath.cgPath
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
        progressLineContainerView.frame = CGRect(
            x: targetFrame.origin.x + 10,
            y: adjustmentFrame.maxY,
            width: targetFrame.width - 32,
            height: 33.fitH
        )
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
        mainWidgetPositionAnimation.duration = 0.3//mainWidgetPositionAnimation.settlingDuration
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
        updateGradient()
        CATransaction.commit()
    }
    
    func showMainAndCloseButton() {
        
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
            width: topTitleLabel.intrinsicContentSize.width + 4 + bottomLabel.intrinsicContentSize.width,
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
//            }
        } else {
            appearingCompletion?()
        }
    }
}
