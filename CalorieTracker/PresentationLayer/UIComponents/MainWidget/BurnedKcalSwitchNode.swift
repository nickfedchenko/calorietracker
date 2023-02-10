//
//  BurnedKcalSwitchNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.07.2022.
//

import AsyncDisplayKit

final class BurnedKcalSwitchNode: ASButtonNode {
    
    var colors: [UIColor?] = [R.color.burnedKcalSwitch.firstGradientColor(),
                             R.color.burnedKcalSwitch.secondGradientColor()]
    
    var excludingBurned: String? {
        didSet {
            valueLabelNode.attributedText = getAttributedString(
                string: excludingBurned,
                color: .white
            )
        }
    }
    var includingBurned: String?
    var offGradientStartPoint = CGPoint(x: -0.5, y: 0)
    var offGradientEndPoint = CGPoint(x: 0.7, y: 0.5)
    var onGradientStartPoint = CGPoint(x: -0.5, y: 2)
    var onGradientEndPoint = CGPoint(x: 0.5, y: 0)
    private var textNodeLeftInset: CGFloat = 8
    private var textNodeRightInset: CGFloat = 14
    
    private(set) var onSelected = false {
        didSet {
            didChangeSelected()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = colors.compactMap { $0?.cgColor }
        layer.startPoint = CGPoint(x: -0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.7, y: 0.5)
        layer.locations = [0, 1]
        return layer
    }()
    
    private lazy var roundNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.layer.masksToBounds = true
        node.layer.cornerCurve = .circular
        node.layer.addSublayer(gradientLayer)
        node.isUserInteractionEnabled = false
        node.style.preferredSize = CGSize(width: 30, height: 30)
        return node
    }()
    
    private lazy var roundImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.burnedKcalSwitch.runPersonFirstState()
        node.contentMode = UIView.ContentMode.center
        return node
    }()
    
    private lazy var valueLabelNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    override init() {
        super.init()
        setupView()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        roundNode.addSubnode(roundImageNode)
        roundNode.layoutSpecBlock = { _, _ in
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets.zero,
                child: ASWrapperLayoutSpec(layoutElement: self.roundImageNode)
            )
        }

        let insetLayoutLabel = ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 0,
                left: textNodeLeftInset,
                bottom: 0,
                right: textNodeRightInset
            ),
            child: valueLabelNode
        )
        let mainStack = ASStackLayoutSpec.horizontal()
        mainStack.verticalAlignment = .center
        mainStack.children = onSelected ? [
            insetLayoutLabel,
            roundNode
        ] : [
            roundNode,
            insetLayoutLabel
        ]
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 1,
                left: 1,
                bottom: 1,
                right: 1
            ),
            child: mainStack
        )
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        layer.cornerRadius = frame.height / 2.0
        roundNode.layer.cornerRadius = roundNode.frame.height / 2.0
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: roundNode.frame.size)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.roundNode.frame = context.finalFrame(for: self.roundNode)
            self.valueLabelNode.frame = context.finalFrame(for: self.valueLabelNode)
        } completion: { flag in
            context.completeTransition(flag)
        }

    }
    
    private func setupView() {
        backgroundColor = R.color.burnedKcalSwitch.backgroundColorFirstState()
        layer.cornerCurve = .circular
        
        addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
    }
    
    private func didChangeSelected() {
        textNodeLeftInset = onSelected ? 16 : 8
        textNodeRightInset = onSelected ? 8 : 14
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        switch onSelected {
        case true:
            backgroundColor = R.color.burnedKcalSwitch.backgroundColorSecondState()
            roundImageNode.image = R.image.burnedKcalSwitch.runPersonSecondState()
            valueLabelNode.attributedText = getAttributedString(
                string: includingBurned,
                color: R.color.burnedKcalSwitch.labelSecondState()
            )
            gradientLayer.startPoint = onGradientStartPoint
            gradientLayer.endPoint = onGradientEndPoint
        case false:
            backgroundColor = R.color.burnedKcalSwitch.backgroundColorFirstState()
            roundImageNode.image = R.image.burnedKcalSwitch.runPersonFirstState()
            valueLabelNode.attributedText = getAttributedString(
                string: excludingBurned,
                color: .white
            )
            gradientLayer.startPoint = offGradientStartPoint
            gradientLayer.endPoint = offGradientEndPoint
        }
    }
    
    private func getAttributedString(string: String?,
                                     color: UIColor?) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string ?? "")
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProRoundedBold(size: 16) ?? .systemFont(ofSize: 16)
            ],
            range: NSRange(location: 0, length: string?.count ?? 0)
        )
        
        return attributedString
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        Vibration.rigid.vibrate()
        onSelected = !onSelected
    }
}
