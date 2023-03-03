//
//  BasicButtonNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class BasicButtonNode: CTWidgetButtonNode {    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        switch type {
        case .custom(let model):
            layer.colors = model.gradientColors?.map { ($0 ?? .white).cgColor }
        case .add, .apply, .save, .next, .addToNewMeal:
            layer.colors = Color.gradientColors.compactMap { $0?.cgColor }
        }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    private let iconNode = ASImageNode()
    private let textNode = ASTextNode()
    
    private(set) var type: BasicButtonType
    
    var active: Bool = true {
        didSet {
            if !active {
                didEnterInactive()
            } else {
                setupButton(isPress: false)
            }
        }
    }
    
    var isPressTitle: String? {
        didSet {
            setupButton(isPress: false)
        }
    }
    var defaultTitle: String? {
        didSet {
            setupButton(isPress: false)
        }
    }
    
    init(type: BasicButtonType, with configuration: CTWidgetNodeConfiguration) {
        self.type = type
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var children: [ASLayoutElement]
        switch type {
        case .add:
            children = [iconNode]
        case .save:
            children = [iconNode, textNode]
        case .next:
            children = [textNode]
        case .apply:
            children = [textNode]
        case .custom:
            children = [iconNode, textNode]
        case .addToNewMeal:
            children = [textNode]
        }
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.horizontalAlignment = .middle
        stack.verticalAlignment = .center
        stack.children = children
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 9,
                left: 9,
                bottom: 9,
                right: 9
            ),
            child: stack
        )
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        gradientLayer.frame = frame
        if active {
            switch type {
            case .add, .save, .apply, .next, .addToNewMeal:
                backgroundColor = gradientLayer.gradientColor()
            case .custom(let model):
                if model.gradientColors != nil {
                    backgroundColor = gradientLayer.gradientColor()
                }
            }
        }
    }
    
    func updateType(type: BasicButtonType) {
        self.type = type
        setupView()
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        borderWidth = 2
        setupButton(isPress: false)
    }
    
    private func didEnterInactive() {
        borderColor = UIColor.white.cgColor
        backgroundColor = Color.inactive
        
        switch type {
        case .add:
            iconNode.image = R.image.basicButton.addInactive()
        case .save:
            iconNode.image = R.image.basicButton.saveInactive()
            textNode.attributedText = getAttributedString(string: Text.save, color: .white)
        case .apply:
            textNode.attributedText = getAttributedString(string: Text.apply, color: .white)
        case .next:
            textNode.attributedText = getAttributedString(string: Text.next, color: .white)
        case .custom(let model):
            iconNode.image = model.image?.inactiveImage
            textNode.attributedText = getAttributedString(string: defaultTitle ?? "", color: .white)
        case .addToNewMeal:
            textNode.attributedText = getAttributedString(string: Text.addToNewMeal, color: .white)
        }
    }
    
    private func setupButton(isPress: Bool) {
        borderColor = Color.borderColor?.cgColor
        
        switch type {
        case .add:
            iconNode.image = isPress ? R.image.basicButton.addPressed() : R.image.basicButton.addDefault()
        case .save:
            iconNode.image = isPress ? R.image.basicButton.savePressed() : R.image.basicButton.saveDefault()
            textNode.attributedText = getAttributedString(
                string: Text.save,
                color: isPress ? Color.borderColor : UIColor.white
            )
        case .apply:
            textNode.attributedText = getAttributedString(
                string: Text.apply,
                color: isPress ? Color.borderColor : UIColor.white
            )
        case .next:
            textNode.attributedText = getAttributedString(
                string: Text.next,
                color: isPress ? Color.borderColor : UIColor.white
            )
        case .custom(let model):
            borderColor = isPress
            ? model.borderColorPress?.cgColor
            : model.borderColorDefault?.cgColor
            
            backgroundColor = isPress
            ? model.backgroundColorPress
            : model.backgroundColorDefault
            
            iconNode.image = isPress ? model.image?.isPressImage : model.image?.defaultImage
            if let text = model.title {
                textNode.attributedText = getAttributedString(
                    string: (isPress ? isPressTitle : defaultTitle) ?? "",
                    color: isPress ? text.isPressTitleColor : text.defaultTitleColor
                )
            }
        case .addToNewMeal:
            textNode.attributedText = getAttributedString(
                string: Text.addToNewMeal,
                color: isPress ? Color.borderColor : UIColor.white
            )
        }
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProRoundedBold(size: 22),
                .kern: 0.38
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}

// MARK: - Touch

extension BasicButtonNode {
    override func beginTracking(with touch: UITouch, with touchEvent: UIEvent?) -> Bool {
        guard active else { return false }
        setupButton(isPress: true)
        return true
    }
    
    override func endTracking(with touch: UITouch?, with touchEvent: UIEvent?) {
        setupButton(isPress: false)
    }
}

// MARK: - Const

extension BasicButtonNode {
    struct Text {
        static let save = "SAVE"
        static let apply = "APPLY"
        static let next = "Next".localized
        static let addToNewMeal = "ADD TO NEW MEAL"
    }
    
    struct Color {
        static let gradientColors = [
            R.color.basicButton.gradientFirstColor(),
            R.color.basicButton.gradientSecondColor()
        ]
        static let borderColor = R.color.basicButton.borderColor()
        static let inactive = R.color.basicButton.inactiveColor()
    }
}
