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
        node.attributedText = getAttributedString(
            string: Text.today,
            size: 16,
            color: .white
        )
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
        dateTextNode.attributedText = getAttributedString(
            string: model.dateString,
            size: 16,
            color: R.color.calendarWidget.dateText()
        )
        
        bottomTextNode.attributedText = getDaysStreakString(days: model.daysStreak)
    }
    
    private func getDaysStreakString(days: Int) -> NSAttributedString {
        let daysString = " " + String(days)

        let prefix = NSMutableAttributedString(
            string: daysString,
            attributes: [.foregroundColor: R.color.calendarWidget.header() ?? .red]
        )
        let postfix = NSMutableAttributedString(
            string: Text.streak,
            attributes: [.foregroundColor: R.color.calendarWidget.streak() ?? .gray]
        )
        prefix.append(postfix)
        prefix.addAttributes(
            [.font: R.font.sfProDisplaySemibold(size: 12) ?? UIFont()],
            range: NSRange(location: 0, length: prefix.string.count)
        )
        
        return getAttributedStringWithImage(
            image: R.image.calendarWidget.star(),
            attributedString: prefix
        )
    }
    
    private func getAttributedStringWithImage(image: UIImage?,
                                              attributedString: NSAttributedString) -> NSAttributedString {
        guard let image = image else { return NSMutableAttributedString() }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(
            x: 0,
            y: (UIFont.roundedFont(ofSize: 12, weight: .semibold).capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )
        let imageString = NSAttributedString(attachment: imageAttachment)
        let fullString = NSMutableAttributedString(attributedString: imageString)
        fullString.append(attributedString)
        
        return fullString
    }
    
    private func getAttributedString(string: String, size: CGFloat, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: size, weight: .semibold)
            ],
            range: NSRange(location: 0, length: string.count)
        )

        return attributedString
    }
}

// MARK: - Const

extension CalendarWidgetNode {
    struct Text {
        static let today = "TODAY"
        static let streak = " days log streak"
    }
}
