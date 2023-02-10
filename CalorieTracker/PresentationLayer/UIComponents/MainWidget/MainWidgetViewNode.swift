//
//  MainWidgetViewNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.07.2022.
//

import AsyncDisplayKit

// swiftlint:disable nesting
final class MainWidgetViewNode: CTWidgetNode {
    
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
    private let burnedKcalSwitchNode = BurnedKcalSwitchNode()
    
    private lazy var circleActivityNode: CircleActivityNode = {
        let node = CircleActivityNode()
        node.style.preferredSize = CGSize(width: 134, height: 134)
        return node
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    var model: Model? {
        didSet {
            didChangeModel()
        }
    }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
//        backgroundColor = gradientLayer.gradientColor()
        drawGradient()
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
        mainLabelStack.justifyContent = .spaceBetween
        mainLabelStack.children = [
            topLabelStack,
            bottomLabelStack
        ]
        
        let insetLayoutLabel = ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 17,
                left: 0,
                bottom: 4,
                right: 0
            ),
            child: mainLabelStack
        )
        
        let shadowNode = ShadowNode()
        shadowNode.shadows = Color.shadows
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.justifyContent = .spaceBetween
        rightStack.horizontalAlignment = .middle
        rightStack.spacing = 16
        rightStack.children = [
            ASBackgroundLayoutSpec(child: circleActivityNode, background: shadowNode),
            burnedKcalSwitchNode
        ]

        let mainStack = ASStackLayoutSpec.horizontal()
        mainStack.justifyContent = .spaceBetween
        
        mainStack.children = [
            insetLayoutLabel,
            rightStack
        ]

        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 16, left: 24, bottom: 22, right: 24),
            child: mainStack
        )
    }
    
    private func drawGradient() {
        gradientLayer.colors = Color.gradientColors.compactMap { $0?.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.6)
        gradientLayer.locations = [0, 1]
//        clipsToBounds = true
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        gradientLayer.zPosition = -1
        gradientLayer.mask = maskLayer
        layer.cornerCurve = .continuous
    }
    
    private func setupView() {
        circleActivityNode.colorBackCircles = R.color.mainWidgetViewNode.circleBackgroundColor()
        circleActivityNode.dataSource = self
        
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
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        circleActivityNode.reloadData()
        
        firstLabel.attributedText = getAttributedString(
            string: model.text.firstLine.uppercased(),
            color: R.color.mainWidgetViewNode.kcalColor()
        )
        secondLabel.attributedText = getAttributedString(
            string: model.text.secondLine.uppercased(),
            color: R.color.mainWidgetViewNode.carbsColor()
        )
        thirdLabel.attributedText = getAttributedString(
            string: model.text.thirdLine.uppercased(),
            color: R.color.mainWidgetViewNode.proteinColor()
        )
        fourthLabel.attributedText = getAttributedString(
            string: model.text.fourthLine.uppercased(),
            color: R.color.mainWidgetViewNode.fatColor()
        )
        
        burnedKcalSwitchNode.excludingBurned = model.text.excludingBurned
        burnedKcalSwitchNode.includingBurned = model.text.includingBurned
    }
    
    private func getAttributedString(
        string: String,
        color: UIColor?,
        maxLineHeight: CGFloat = 19
    ) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
//        paragraph.minimumLineHeight = 19
        paragraph.maximumLineHeight = maxLineHeight
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProRoundedBold(size: 16) ?? .systemFont(ofSize: 16),
                .paragraphStyle: paragraph,
                .kern: 0.38
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

extension MainWidgetViewNode: CircleActivityNodeDataSource {
    func circleActivityNode(_ node: CircleActivityNode, strokeColor index: Int) -> UIColor {
        guard let model = model else { return .red }
        return model.circleData.rings[index].color ?? .blue
    }
    
    func numberOfActivityCircles(_ node: CircleActivityNode) -> Int {
        guard let model = model else { return 0 }
        return model.circleData.rings.count
    }
    
    func circleActivityNode(_ node: CircleActivityNode, percentageOfFilling index: Int) -> CGFloat {
        guard let model = model else { return 1 }
        return model.circleData.rings[index].progress
    }
    
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleString index: Int) -> String? {
        guard let model = model else { return nil }
        return model.circleData.rings[index].title
    }
    
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleImage index: Int) -> UIImage? {
        guard let model = model else { return nil }
        return model.circleData.rings[index].image
    }
    
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleColor index: Int) -> UIColor? {
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
