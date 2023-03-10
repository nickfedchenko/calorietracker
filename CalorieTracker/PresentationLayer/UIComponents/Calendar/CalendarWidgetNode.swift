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
        let date: Date?
        let daysStreak: Int
    }
    
    private lazy var topTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = Text.today.attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(.white),
                    .font(R.font.sfProRoundedBold(size: 18))
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
        dateTextNode.attributedText = model.dateString.attributedSring([
            .init(
                worldIndex: [0, 1],
                attributes: [
                    .color(R.color.calendarWidget.dateText()),
                    .font(R.font.sfProRoundedBold(size: 18))
                ]
            )
        ])
        
        bottomTextNode.attributedText = getDaysStreakString(days: model.daysStreak)
        if let date = model.date {
            setTopLabel(for: date)
        }
    }
    
    private func setTopLabel(for date: Date) {
        let todayDate = Date()
        switch abs(Calendar.current.dateComponents([.day], from: todayDate, to: date).day ?? 0) {
        case 0:
            topTextNode.attributedText = Text.today.attributedSring([
                .init(
                    worldIndex: [0],
                    attributes: [
                        .color(.white),
                        .font(R.font.sfProRoundedBold(size: UIDevice.isSmallDevice ? 16 : 18))
                    ]
                )
            ])
        case 1:
            topTextNode.attributedText = Text.yesterday.attributedSring([
                .init(
                    worldIndex: [0],
                    attributes: [
                        .color(.white),
                        .font(R.font.sfProRoundedBold(size: UIDevice.isSmallDevice ? 13 : 15))
                    ]
                )
            ])
            
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let weekDayString = formatter.string(from: date)
            topTextNode.attributedText = weekDayString.uppercased().attributedSring([
                .init(
                    worldIndex: [0],
                    attributes: [
                        .color(.white),
                        .font(R.font.sfProRoundedBold(size: UIDevice.isSmallDevice ? 13 : 15))
                    ]
                )
            ])
        }
    }
    
    private func getDaysStreakString(days: Int) -> NSAttributedString {
        let font = R.font.sfProTextSemibold(size: 13)
        let image = R.image.calendarWidget.star()
        let leftColor = R.color.calendarWidget.header()
        let rightColor = R.color.calendarWidget.streak()
        let leftAttributes: [StringSettings] = [.color(leftColor), .font(font)]
        let rightAttributes: [StringSettings] = [.color(rightColor), .font(font)]
        let string = "\(days) \(Text.streak)"

        return string.attributedSring(
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
        static let today = R.string.localizable.calendarTopTitleToday()
        static let yesterday = R.string.localizable.calendarTopTitleYesterday()
        static let streak = R.string.localizable.calendarLogStreak()
    }
}
