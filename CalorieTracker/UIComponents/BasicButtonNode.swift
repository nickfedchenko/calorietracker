//
//  BasicButtonNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class BasicButtonNode: CTWidgetButtonNode {
    enum BasicButtonType {
        case add
        case save
        case apply
        case custom(CustomType)
    }
    
    struct CustomType {
        let image: Image?
        let title: Title?
        let backgroundColorInactive: UIColor
        let gradientColors: [UIColor]
        let borderColorInactive: UIColor
        let borderColorDefault: UIColor
        
        struct Image {
            let isPressImage: UIImage
            let defaultImage: UIImage
            let inactiveImage: UIImage
        }
        
        struct Title {
            let isPressTitle: String
            let defaultTitle: String
            let isPressTitleColor: UIColor
            let defaultTitleColor: UIColor
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        switch type {
        case .custom(let model):
            layer.colors = model.gradientColors.map { $0.cgColor }
        case .add, .apply, .save:
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
            if !active { didEnterInactive() }
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
        case .apply:
            children = [textNode]
        case .custom:
            children = [iconNode, textNode]
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
        if active { backgroundColor = gradientLayer.gradientColor() }
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        borderWidth = 1
        setupButton(isPress: false)
        
        addTarget(
            self,
            action: #selector(didNotSelectedButton),
            forControlEvents: .touchUpInside
        )
        addTarget(
            self,
            action: #selector(didSelectedButton),
            forControlEvents: .touchDown
        )
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
        case .custom(let model):
            iconNode.image = model.image?.inactiveImage
            if let text = model.title {
                textNode.attributedText = getAttributedString(string: text.defaultTitle, color: .white)
            }
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
        case .custom(let model):
            borderColor = model.borderColorDefault.cgColor
            
            iconNode.image = isPress ? model.image?.isPressImage : model.image?.defaultImage
            if let text = model.title {
                textNode.attributedText = getAttributedString(
                    string: isPress ? text.isPressTitle : text.defaultTitle,
                    color: isPress ? text.isPressTitleColor : text.defaultTitleColor
                )
            }
        }
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: 20, weight: .semibold)
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
    
    @objc private func didSelectedButton() {
        guard active else { return }
        setupButton(isPress: true)
    }
    
    @objc private func didNotSelectedButton() {
        guard active else { return }
        setupButton(isPress: false)
    }
}

// MARK: - Const

extension BasicButtonNode {
    struct Text {
        static let save = "SAVE"
        static let apply = "APPLY"
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
