//
//  SegmentedControl.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.08.2022.
//

import AsyncDisplayKit

final class SegmentedControl<ID>: ASDisplayNode {
    typealias Button = SegmentedButton<ID>
    
    private let buttons: [Button]
    
    private var selectedButton: Button? {
        didSet {
            transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }
    
    private lazy var selectorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .white
        node.layer.cornerRadius = 8
        node.layer.cornerCurve = .circular
        node.layer.shadowRadius = 18
        node.layer.shadowColor = UIColor.black.cgColor
        node.layer.shadowOpacity = 0.1
        node.layer.shadowOffset = .init(width: 0, height: 4)
        
        return node
    }()
    
    var onSegmentChanged: ((Button.Model) -> Void)?
    var textNormalColor: UIColor? = .black
    var textSelectedColor: UIColor? = .green
    var font: UIFont? = R.font.sfProDisplaySemibold(size: 16) {
        didSet {
            buttons.forEach { button in
                button.font = font
            }
        }
    }
    
    init(_ buttons: [Button.Model]) {
        self.buttons = buttons.map(Button.init)
        super.init()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var children: [ASLayoutElement] = []
        buttons.forEach { button in
            let specButton = ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 10.5,
                    left: 20,
                    bottom: 10.5,
                    right: 20
                ),
                child: button
            )
            if button == selectedButton {
                children.append(ASBackgroundLayoutSpec(
                    child: specButton,
                    background: selectorNode
                ))
            } else {
                children.append(specButton)
            }
        }
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = children
        
        return stack
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.selectorNode.frame = context.finalFrame(for: self.selectorNode)
        } completion: { flag in
            context.completeTransition(flag)
        }
    }
    
    private func setupViews() {
        automaticallyManagesSubnodes = true
        layer.cornerRadius = 8
        layer.cornerCurve = .circular
        
        selectedButton = buttons.first
        buttons.first?.isSelected = true
        buttons.forEach { button in
            button.addTarget(
                self,
                action: #selector(didTapSegmentedButton),
                forControlEvents: .touchUpInside)
        }
    }
    
    @objc private func didTapSegmentedButton(_ sender: ASButtonNode) {
        guard let button = sender as? Button else { return }
        buttons.forEach { $0.isSelected = false }
        button.isSelected = true
        
        selectedButton = button
        onSegmentChanged?(button.model)
    }
}

enum HistoryHeaderButtonType {
    case weak
    case months
    case twoMonths
    case threeMonths
    case sixMonths
    case year
    case allTheTime
    
    func getTitle() -> String {
        switch self {
        case .weak:
            return NSLocalizedString("Неделя", comment: "")
        case .months:
            return NSLocalizedString("Месяц", comment: "")
        case .twoMonths:
            return NSLocalizedString("2 месяца", comment: "")
        case .threeMonths:
            return NSLocalizedString("3 месяца", comment: "")
        case .sixMonths:
            return NSLocalizedString("Полгода", comment: "")
        case .year:
            return NSLocalizedString("Год", comment: "")
        case .allTheTime:
            return NSLocalizedString("Все время", comment: "")
        }
    }
}
