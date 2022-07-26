//
//  MainScreennodeController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import AsyncDisplayKit
import AuthenticationServices

protocol MainScreenViewControllerInterface: AnyObject {
    
}
//
class MainScreenViewController: ASDKViewController<ASDisplayNode> {
    
    // MARK: - Public properties
    var presenter: MainScreenPresenterInterface?
    
    // MARK: - Private properties
    private let menuButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.yellow()
        return node
    }()
    
    private let messageNode: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.lightTeal()
        node.style.preferredSize = CGSize(width: 308, height: node.constants.height)
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let mainActivityWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .widget))
        node.backgroundColor = R.color.mainDarkGreen()
        node.style.preferredSize = CGSize(
            width: 388,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let calendarWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.carrot()
        return node
    }()
    
    private let waterBalanceWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.teal()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let exercisesWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.purple()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let stepsWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.violet()
        return node
    }()
    
    private let weightMeasureWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.olive()
        return node
    }()
    
    private let notesWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.terracotta()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let addWidgetButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.mainDarkGreen()
        node.style.preferredSize = CGSize(
            width: 308,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let barCodeScannerButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.grey()
        return node
    }()
    
    private let scrollNode: ASScrollNode? = {
        guard UIDevice.screenType == .h16x375 || UIDevice.screenType == .h16x414 else {
            return nil
        }
        let scrollNode = ASScrollNode()
        scrollNode.view.showsVerticalScrollIndicator = false
        scrollNode.view.showsHorizontalScrollIndicator = false
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyRelayoutOnSafeAreaChanges = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.view.contentInset = .init(top: 0, left: 0, bottom: 64, right: 0)
        scrollNode.view.contentInsetAdjustmentBehavior = .never
        return scrollNode
    }()
    
    private let containerNode: ASDisplayNode? = {
        guard UIDevice.screenType == .h16x375 || UIDevice.screenType == .h16x414 else {
            return nil
        }
        let node = ASDisplayNode()
        node.backgroundColor = R.color.mainBackground()
        node.automaticallyManagesSubnodes = true
        node.automaticallyRelayoutOnSafeAreaChanges = true
        return node
    }()
    
    // MARK: - Init
    override init() {
        super.init(node: ASDisplayNode())
        node.automaticallyRelayoutOnSafeAreaChanges = true
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = R.color.mainBackground()
        
        node.layoutSpecBlock = { node, size in
            if let scrollNode = self.scrollNode {
                let insetSpecs = ASInsetLayoutSpec(
                    insets: .zero,
                    child: scrollNode)
                
                return insetSpecs
            } else {
                return self.setupStacks(node: node, size: size)
            }
        }
        
        if let scrollNode = scrollNode,
           let containerNode = containerNode {
            scrollNode.layoutSpecBlock = { _, _ in
                let insetSpecs = ASInsetLayoutSpec(
                    insets: UIEdgeInsets(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0
                    ),
                    child: containerNode
                )
                return insetSpecs
            }
            containerNode.layoutSpecBlock = setupStacks(node:size:)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    // swiftlint:disable:next function_body_length
    private func setupStacks(node: ASDisplayNode, size: ASSizeRange) -> ASLayoutSpec {
        let firstHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.menuButton.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .start,
            children: [self.menuButton, self.messageNode]
        )
        
        let secondHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.menuButton.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.mainActivityWidget]
        )
        
        let thirdHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.calendarWidget, self.waterBalanceWidget]
        )
        
        let fourthHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.exercisesWidget, self.stepsWidget]
        )
        
        let fifthHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.weightMeasureWidget, self.notesWidget]
        )
        
        let sixthHStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.addWidgetButton, self.barCodeScannerButton]
        )
        
        let VStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: self.menuButton.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .start,
            children: [firstHStack, secondHStack, thirdHStack, fourthHStack, fifthHStack, sixthHStack]
        )
        
        let stackInset = ASInsetLayoutSpec(
            insets: .init(
                top: self.menuButton.constants.suggestedTopSafeAreaOffset + self.node.safeAreaInsets.top,
                left: self.menuButton.constants.suggestedSideInset,
                bottom: 0,
                right: self.menuButton.constants.suggestedSideInset
            ),
            child: VStack
        )
        
        return stackInset
    }
}

extension MainScreenViewController: MainScreenViewControllerInterface {
    
}
