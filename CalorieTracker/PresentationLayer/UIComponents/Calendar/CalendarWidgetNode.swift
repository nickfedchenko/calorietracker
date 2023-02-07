//
//  CalendarWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.07.2022.
//

import AsyncDisplayKit

final class CalendarWidgetNode: CTWidgetNode {
    
    struct Model {
        let dateString: String
        let daysStreak: Int
    }
    
    private lazy var topTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = Text.today.attributedString([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(.white),
                    .font(R.font.sfProDisplaySemibold(size: 16.fontScale()))
                ]
            )
        ])
        return node
    }()
    
    private lazy var dateTextNode: ASTextNode = {
        let node = ASTextNode()
        node.style.alignSelf = .center
        return node
    }()
    
    private lazy var bottomTextNode: ASTextNode = {
        let node = ASTextNode()
        node.style.alignSelf = .center
        node.attributedText = getDaysStreakString(days: 0)
        return node
    }()
    
    var model: Model? {
        didSet {
            didChangeModel()
        }
    }
    
    override var widgetType: WidgetContainerViewController.WidgetType { .calendar }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let backgroundTopText: ASDisplayNode = {
            let node = ASDisplayNode()
            node.backgroundColor = R.color.calendarWidget.header()
            node.layer.cornerRadius = layer.cornerRadius
            return node
        }()
        
        backgroundTopText.style.layoutPosition = CGPoint.zero
        backgroundTopText.style.preferredSize = CGSize(
            width: constrainedSize.min.width,
            height: constrainedSize.min.height / 3.11
        )
        
        let backgroundTopTextSpec = ASAbsoluteLayoutSpec(children: [backgroundTopText])
        
        let topTextInset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 8,
                left: 0,
                bottom: 8,
                right: 0
            ),
            child: topTextNode
        )
        
        let stack = ASStackLayoutSpec.vertical()
        stack.justifyContent = .spaceBetween
        stack.horizontalAlignment = .middle
        stack.children = [
            topTextInset,
            dateTextNode,
            ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 0,
                    left: 10,
                    bottom: 6,
                    right: 10
                ),
                child: bottomTextNode
            )
        ]
        
        return ASWrapperLayoutSpec(
            layoutElements: [
                backgroundTopTextSpec,
                stack
            ]
        )
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        dateTextNode.attributedText = model.dateString.attributedString([
            .init(
                worldIndex: [0, 1],
                attributes: [
                    .color(R.color.calendarWidget.dateText()),
                    .font(R.font.sfProDisplayBold(size: 16.fontScale()))
                ]
            )
        ])
        
        bottomTextNode.attributedText = getDaysStreakString(days: model.daysStreak)
    }
    
    private func getDaysStreakString(days: Int) -> NSAttributedString {
        let font = R.font.sfProDisplaySemibold(size: 12.fontScale())
        let image = R.image.calendarWidget.star()
        let leftColor = R.color.calendarWidget.header()
        let rightColor = R.color.calendarWidget.streak()
        let leftAttributes: [StringSettings] = [.color(leftColor), .font(font)]
        let rightAttributes: [StringSettings] = [.color(rightColor), .font(font)]
        let string = "\(days) \(Text.streak)"

        return string.attributedString(
            [
                .init(worldIndex: [0], attributes: leftAttributes),
                .init(worldIndex: Array(1...4), attributes: rightAttributes)
            ],
            image: .init(image: image, font: font, position: .left)
        )
    }
}

// MARK: - Const

extension CalendarWidgetNode {
    struct Text {
        static let today = "TODAY"
        static let streak = " days\nlog streak"
    }
}
