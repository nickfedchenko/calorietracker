//
//  MainWidgetViewNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.07.2022.
//

import AsyncDisplayKit

final class MainWidgetViewNode: ASDisplayNode {
    
    struct Model {
        let text: Text
        let circleData: CircleData
        
        struct Text {
            let firstLine: String
            let secondLine: String
            let thirdLine: String
            let fourthLine: String
            let excludingBurned: String
            let includingBurned: String
        }
        
        struct CircleData {
            let rings: [RingData]
            
            struct RingData {
                let progress: CGFloat
                let color: UIColor?
                let title: String?
                let titleColor: UIColor?
                let image: UIImage?
            }
        }
    }
    
    private let firstLabel = ASTextNode()
    private let secondLabel = ASTextNode()
    private let thirdLabel = ASTextNode()
    private let fourthLabel = ASTextNode()
    private let fifthLabel = ASTextNode()
    private let sixthLabel = ASTextNode()
    private let circleActivityView = CircleActivityView()
    private let burnedKcalSwitchNode = BurnedKcalSwitchNode()
    
    private lazy var circleActivityViewNode: ASDisplayNode = {
        let node = ASDisplayNode { self.circleActivityView }
        node.style.preferredSize = CGSize(width: 134, height: 134)
        return node
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = Color.gradientColors.compactMap { $0?.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    var model: Model? {
        didSet {
            didChangeModel()
        }
    }
    
    override init() {
        super.init()
        setupView()
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        backgroundColor = gradientLayer.gradientColor()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let topLabelStack = ASStackLayoutSpec.vertical()
        topLabelStack.spacing = 8
        topLabelStack.children = [
            firstLabel,
            secondLabel,
            thirdLabel,
            fourthLabel
        ]
        
        sixthLabel.style.width = ASDimension(unit: .points, value: 162)
        let bottomLabelStack = ASStackLayoutSpec.vertical()
        bottomLabelStack.children = [
            fifthLabel,
            sixthLabel
        ]
        
        let mainLabelStack = ASStackLayoutSpec.vertical()
        mainLabelStack.spacing = 21
        mainLabelStack.children = [
            topLabelStack,
            bottomLabelStack
        ]
        
        let insetLayoutLabel = ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 32,
                left: 24,
                bottom: 6,
                right: 0
            ),
            child: mainLabelStack
        )
        
        let shadowNode = ShadowNode(node: circleActivityViewNode)
        shadowNode.shadows = Color.shadows
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.spacing = 20
        rightStack.horizontalAlignment = .middle
        rightStack.children = [
            shadowNode,
            burnedKcalSwitchNode
        ]

        let mainStack = ASStackLayoutSpec.horizontal()
        mainStack.spacing = 22
        mainStack.children = [
            insetLayoutLabel,
            rightStack
        ]

        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12),
            child: mainStack
        )
    }
    
    private func setupView() {
        circleActivityView.colorBackCircles = R.color.mainWidgetViewNode.circleBackgroundColor()
        circleActivityView.titleFont = UIFont.roundedFont(ofSize: 10, weight: .bold)
        circleActivityView.dataSource = self
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        automaticallyManagesSubnodes = true
        
        fifthLabel.attributedText = getAttributedString(
            string: Text.kcalLeft,
            color: .white
        )
        sixthLabel.attributedText = getAttributedString(
            string: Text.excluding,
            color: R.color.mainWidgetViewNode.burnedColor()
        )
        
        burnedKcalSwitchNode.addTarget(
            self,
            action: #selector(didTapSwitch),
            forControlEvents: .touchUpInside
        )
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        circleActivityView.reloadData()
        
        firstLabel.attributedText = getAttributedString(
            string: model.text.firstLine,
            color: R.color.mainWidgetViewNode.kcalColor()
        )
        secondLabel.attributedText = getAttributedString(
            string: model.text.secondLine,
            color: R.color.mainWidgetViewNode.carbsColor()
        )
        thirdLabel.attributedText = getAttributedString(
            string: model.text.thirdLine,
            color: R.color.mainWidgetViewNode.proteinColor()
        )
        fourthLabel.attributedText = getAttributedString(
            string: model.text.fourthLine,
            color: R.color.mainWidgetViewNode.fatColor()
        )
        
        burnedKcalSwitchNode.excludingBurned = model.text.excludingBurned
        burnedKcalSwitchNode.includingBurned = model.text.includingBurned
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: 16, weight: .semibold)
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
    
    @objc private func didTapSwitch(_ sender: BurnedKcalSwitchNode) {
        sixthLabel.attributedText = getAttributedString(
            string: sender.onSelected ? Text.including : Text.excluding,
            color: R.color.mainWidgetViewNode.burnedColor()
        )
    }
}

// MARK: - CircleActivityViewDataSource

extension MainWidgetViewNode: CircleActivityViewDataSource {
    func circleActivityView(_ view: CircleActivityView, strokeColor index: Int) -> UIColor {
        guard let model = model else { return .red }
        return model.circleData.rings[index].color ?? .blue
    }
    
    func numberOfActivityCircles(_ view: CircleActivityView) -> Int {
        guard let model = model else { return 0 }
        return model.circleData.rings.count
    }
    
    func circleActivityView(_ view: CircleActivityView, percentageOfFilling index: Int) -> CGFloat {
        guard let model = model else { return 1 }
        return model.circleData.rings[index].progress
    }
    
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleString index: Int) -> String? {
        guard let model = model else { return nil }
        return model.circleData.rings[index].title
    }
    
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleImage index: Int) -> UIImage? {
        guard let model = model else { return nil }
        return model.circleData.rings[index].image
    }
    
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleColor index: Int) -> UIColor? {
        guard let model = model else { return nil }
        return model.circleData.rings[index].titleColor
    }
}

// MARK: - Const

extension MainWidgetViewNode {
    struct Text {
        static let including = "INCLUDING BURNED"
        static let excluding = "EXCLUDING BURNED"
        static let kcalLeft = "KCAL LEFT"
    }
    
    struct Color {
        static let gradientColors = [
            R.color.mainWidgetViewNode.firstGradientColor(),
            R.color.mainWidgetViewNode.secondGradientColor()
        ]
        static let shadows: [ShadowNode.Shadow] = [
            .init(
                color: .white,
                opaсity: 0.04,
                offset: CGSize(width: -3, height: -3),
                radius: 4,
                shape: .circle
            ),
            .init(
                color: .black,
                opaсity: 0.15,
                offset: CGSize(width: 0, height: 3),
                radius: 3,
                shape: .circle
            )
        ]
    }
}
