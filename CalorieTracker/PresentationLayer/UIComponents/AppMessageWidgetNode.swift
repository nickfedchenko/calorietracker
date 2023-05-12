//
//  AppMessageWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

final class AppMessageWidgetNode: CTWidgetNode {
    
    private let triangleSize = CGSize(width: 10, height: 14)
    
    private var isFirstDraw = true
    
    private var scrollAnimator: UIViewPropertyAnimator?
    
    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        return node
    }()
    
    var text: String? {
        get { textNode.attributedText?.string }
        set {
            let string = newValue ?? ""
            textNode.attributedText = string.attributedSring([
                .init(
                    worldIndex: Array(0...string.split(separator: " ").count),
                    attributes: [
                        .color(R.color.messageWidget.text()),
                        .font(R.font.sfProRoundedMedium(size: UIDevice.isSmallDevice ? 15 : 18.fontScale()))
                    ]
                )
            ])
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            textNode.attributedText
        }
        
        set {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            textNode.layer.add(transition, forKey: nil)
            textNode.attributedText = newValue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.setupScrollAnimationsDown()
            }
        }
    }
    
    let scrollNode: ASScrollNode = {
  
        let sampleNode = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        let safeAreaInset = sampleNode.constants.suggestedTopSafeAreaOffset

        let scrollNode = ASScrollNode()
        scrollNode.view.showsVerticalScrollIndicator = false
        scrollNode.view.showsHorizontalScrollIndicator = false
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyRelayoutOnSafeAreaChanges = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.view.contentInsetAdjustmentBehavior = .never
//        scrollNode.view.contentInset = .init(
//            top: 10,
//            left: 21,
//            bottom: 10,
//            right: 12
//        )
        scrollNode.view.contentInsetAdjustmentBehavior = .never
        return scrollNode
    }()
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        scrollNode.layoutSpecBlock = { scrollNode, range in
            let insetLayout = ASInsetLayoutSpec(insets: .zero, child: self.textNode)
            return insetLayout
        }
        
        let insets = ASInsetLayoutSpec(
            insets: .init(top: 0, left: 0, bottom: 0, right: 0),
            child: scrollNode
        )
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 10,
                left: self.triangleSize.width + 11,
                bottom: 10,
                right: 12
            ),
            child: scrollNode
        )
    }
    
    override func willEnterHierarchy() {
        guard isFirstDraw else { return }
        layer.addSublayer(getShape(size: frame.size))
        isFirstDraw = false
    }
    
    private func setupScrollAnimationsDown() {
        scrollNode.view.setContentOffset(.zero, animated: false)
        scrollAnimator?.stopAnimation(false)
        scrollAnimator?.finishAnimation(at: .current)
        scrollAnimator = nil
        scrollAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 5,
            delay: 0.3,
            options: [.repeat, .autoreverse]
        ) {
            // Block-based animation API нихера не работает к слову. Анимация не повторяется и не реверсится
            UIView.setAnimationRepeatCount(.greatestFiniteMagnitude)
            UIView.setAnimationRepeatAutoreverses(true)
            self.scrollNode.view.scrollRectToVisible(self.textNode.frame, animated: false)
        }

    }
    
    private func getShape(size: CGSize) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = getPath(size: frame.size).cgPath
        shape.fillColor = R.color.messageWidget.background()?.cgColor
        shape.lineWidth = 1
        shape.strokeColor = UIColor.white.cgColor
        shape.zPosition = -1
        return shape
    }
    
    // swiftlint:disable:next function_body_length
    private func getPath(size: CGSize) -> UIBezierPath {
        let radius = min(
            layer.cornerRadius,
            size.height / 2.0 - triangleSize.height / 2.0
        )
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: triangleSize.width, y: radius))
        path.addArc(
            withCenter: CGPoint(
                x: triangleSize.width + radius,
                y: radius
            ),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: size.width - radius, y: 0))
        path.addArc(
            withCenter: CGPoint(
                x: size.width - radius,
                y: radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: size.width, y: size.height - radius))
        path.addArc(
            withCenter: CGPoint(
                x: size.width - radius,
                y: size.height - radius
            ),
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: triangleSize.width + radius, y: size.height))
        path.addArc(
            withCenter: CGPoint(
                x: triangleSize.width + radius,
                y: size.height - radius
            ),
            radius: radius,
            startAngle: CGFloat.pi / 2.0,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: triangleSize.width, y: size.height / 2.0 + triangleSize.height / 2.0))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: triangleSize.width, y: size.height / 2.0 - triangleSize.height / 2.0))
        path.close()
        
        return path
    }
}
