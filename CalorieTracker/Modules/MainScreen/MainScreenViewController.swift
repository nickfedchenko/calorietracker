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
    var presenter: MainScreenPresenterInterface?

    let menuButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.yellow()
        return node
    }()

    let messageNode: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.lightTeal()
        node.style.preferredSize = CGSize(width: 308, height: node.constants.height)
        node.style.flexShrink = 0.75
        return node
    }()

    let mainActivityWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .widget))
        node.backgroundColor = R.color.mainDarkGreen()
        node.style.preferredSize = CGSize(
            width: 388,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()

    let calendarWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.carrot()
        return node
    }()

    let waterBalanceWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.teal()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()

    let exercisesWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.purple()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()

    let stepsWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.violet()
        return node
    }()

    let weightMeasureWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.olive()
        return node
    }()

    let notesWidget: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.backgroundColor = R.color.terracotta()
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()

    let addWidgetButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.mainDarkGreen()
        node.style.preferredSize = CGSize(
            width: 308,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()

    let barCodeScannerButton: CTWidgetNode = {
        let node = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.backgroundColor = R.color.grey()
        return node
    }()

    let scrollNode: ASScrollNode? = {
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

    let containerNode: ASDisplayNode? = {
        guard UIDevice.screenType == .h16x375 || UIDevice.screenType == .h16x414 else {
            return nil
        }
        let node = ASDisplayNode()
        node.backgroundColor = R.color.mainBackground()
        node.automaticallyManagesSubnodes = true
        node.automaticallyRelayoutOnSafeAreaChanges = true
        return node
    }()
    
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

//
extension MainScreenViewController: MainScreenViewControllerInterface {
    private func setupSubNodes() {
//        if let scrollnode = scrollnode,
//           let containernode = containernode {
//            node.addSubnode(scrollnode)
//            scrollnode.snp.makeConstraints { make in
//                make.edges.equalTo(node.safeAreaLayoutGuide)
//            }
//            scrollnode.addSubnode(containernode)
//            containernode.snp.makeConstraints { make in
//                make.edges.equalToSupernode()
//                make.width.equalTo(node)
//            }
//        }
//
//        [
//            menuButton, messagenode, mainActivityWidget, calendarWidget, waterBalanceWidget,
//            exrcisesWidget, stepsWidget, weightMeasureWidget,
//            notesWidget, addWidgetButton, barCodeScannerButton
//        ].forEach {
//            if let scrollnode = scrollnode,
//               let containernode = containernode {
//                containernode.addSubnode($0)
//            } else {
//                node.addSubnode($0)
//            }
//        }
//
//        menuButton.snp.makeConstraints { make in
//            make.leading.equalToSupernode().offset(menuButton.constants.suggestedSideInset)
//            if scrollnode != nil {
//                make.top.equalToSupernode()
//                    .offset(menuButton.constants.suggestedTopSafeAreaOffset)
//            } else {
//                make.top.equalTo(node.safeAreaLayoutGuide.snp.top)
//                    .offset(menuButton.constants.suggestedTopSafeAreaOffset)
//            }
//            make.width.equalTo(menuButton.snp.height)
//        }
//
//        messagenode.snp.makeConstraints { make in
//            make.leading.equalTo(menuButton.snp.trailing).offset(messagenode.constants.suggestedInterItemSpacing)
//            make.trailing.equalToSupernode().inset(messagenode.constants.suggestedSideInset)
//            make.centerY.equalTo(menuButton)
//        }
//
//        mainActivityWidget.snp.makeConstraints { make in
//            make.leading.trailing.equalToSupernode().inset(mainActivityWidget.constants.suggestedSideInset)
//            make.top.equalTo(menuButton.snp.bottom).offset(mainActivityWidget.constants.suggestedInterItemSpacing)
//        }
//
//        calendarWidget.snp.makeConstraints { make in
//            make.top.equalTo(mainActivityWidget.snp.bottom).offset(calendarWidget.constants.suggestedInterItemSpacing)
//            make.leading.equalTo(mainActivityWidget)
//            make.width.equalTo(calendarWidget.snp.height)
//        }
//
//        waterBalanceWidget.snp.makeConstraints { make in
//            make
//                .leading
//                .equalTo(calendarWidget.snp.trailing)
//                .offset(calendarWidget.constants.suggestedInterItemSpacing)
//
//            make.trailing.equalTo(mainActivityWidget)
//            make.top.equalTo(calendarWidget)
//        }
//
//        stepsWidget.snp.makeConstraints { make in
//            make.trailing.equalTo(waterBalanceWidget)
//            make.width.equalTo(stepsWidget.snp.height)
//            make
//                .top
//                .equalTo(waterBalanceWidget.snp.bottom)
//                .offset(waterBalanceWidget.constants.suggestedInterItemSpacing)
//        }
//
//        exrcisesWidget.snp.makeConstraints { make in
//            make.leading.equalTo(calendarWidget)
//            make
//                .trailing.equalTo(rightFourthRowVioletWidget.snp.leading)
//                .inset(-leftFourthRowPurpleWidget.constants.suggestedInterItemSpacing)
//            make.top.equalTo(stepsWidget)
//        }
//
//        weightMeasureWidget.snp.makeConstraints { make in
//            make.leading.equalTo(exrcisesWidget)
//            make
//                .top.equalTo(exrcisesWidget.snp.bottom)
//                .offset(weightMeasureWidget.constants.suggestedInterItemSpacing)
//            make.width.equalTo(weightMeasureWidget.snp.height)
//        }
//
//        notesWidget.snp.makeConstraints { make in
//            make
//                .leading.equalTo(weightMeasureWidget.snp.trailing)
//                .offset(notesWidget.constants.suggestedInterItemSpacing)
//            make.top.equalTo(weightMeasureWidget)
//            make.trailing.equalTo(stepsWidget)
//        }
//
//        barCodeScannerButton.snp.makeConstraints { make in
//            make.trailing.equalTo(notesWidget)
//            make
//                .top.equalTo(notesWidget.snp.bottom)
//                .offset(waterBalanceWidget.constants.suggestedInterItemSpacing)
//            make.width.equalTo(barCodeScannerButton.snp.height)
//        }
//
//        addWidgetButton.snp.makeConstraints { make in
//            make
//                .trailing.equalTo(rightSixthRowGreyWidget.snp.leading)
//                .inset(-mainWidget.constants.suggestedInterItemSpacing)
//            make.leading.equalTo(weightMeasureWidget)
//            make.top.equalTo(barCodeScannerButton)
//            if let containernode = containernode {
//                make.bottom.equalToSupernode()
//            }
//        }
    }
}
