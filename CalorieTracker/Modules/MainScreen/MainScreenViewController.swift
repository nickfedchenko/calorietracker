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
    private let menuButton: AppWidgetNode = {
        let node = AppWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        return node
    }()
    
    private let messageNode: AppMessageWidgetNode = {
        let node = AppMessageWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.style.preferredSize = CGSize(width: 308, height: node.constants.height)
        node.style.flexShrink = 0.75
        node.backgroundColor = .clear
        node.text = "Have a nice day! Don't forget to track your breakfast "
        return node
    }()
    
    private let mainActivityWidget: MainWidgetViewNode = {
        let node = MainWidgetViewNode(with: CTWidgetNodeConfiguration(type: .widget))
        node.backgroundColor = R.color.mainDarkGreen()
        node.style.preferredSize = CGSize(
            width: 388,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        node.model = MainWidgetViewNode.Model(
            text: MainWidgetViewNode.Model.Text(
                firstLine: "1680 / 1950 kcal",
                secondLine: "133 / 145 carbs",
                thirdLine: "133 / 145 protein",
                fourthLine: "23 / 30 fat",
                excludingBurned: "778",
                includingBurned: "1200"
            ),
            circleData: MainWidgetViewNode.Model.CircleData(
                rings: [
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: 0.5,
                        color: .red,
                        title: "C",
                        titleColor: nil,
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: 0.7,
                        color: .red,
                        title: "B",
                        titleColor: .blue,
                        image: nil
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: 0.6,
                        color: .red,
                        title: nil,
                        titleColor: nil,
                        image: R.image.mainWidgetViewNode.burned()
                    ),
                    MainWidgetViewNode.Model.CircleData.RingData(
                        progress: 0.8,
                        color: .green,
                        title: "H",
                        titleColor: nil,
                        image: nil
                    )
                ]
            )
        )
        return node
    }()
    
    private let calendarWidget: CalendarWidgetNode = {
        let node = CalendarWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.model = .init(dateString: "May 29", daysStreak: 12)
        return node
    }()
    
    private let waterBalanceWidget: WaterWidgetNode = {
        let node = WaterWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.model = .init(progress: 0.7, waterMl: NSAttributedString(string: "1600 / 2400 ml"), waterPercent: "60")
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let exercisesWidget: ExercisesWidgetNode = {
        let node = ExercisesWidgetNode(
            ExercisesWidgetNode.Model(
                exercises: [
                    ExercisesWidgetNode.Model.Exercise(
                        burnedKcal: 240,
                        exerciseType: ExerciseType.basketball
                    ),
                    ExercisesWidgetNode.Model.Exercise(
                        burnedKcal: 320,
                        exerciseType: ExerciseType.swim
                    ),
                    ExercisesWidgetNode.Model.Exercise(
                        burnedKcal: 135,
                        exerciseType: ExerciseType.core
                    ),
                    ExercisesWidgetNode.Model.Exercise(
                        burnedKcal: 100,
                        exerciseType: ExerciseType.boxing
                    )
                ],
                progress: 0.7,
                burnedKcal: 772,
                goalBurnedKcal: 900
            ),
            with: CTWidgetNodeConfiguration(type: .large))
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let stepsWidget: StepsWidgetNode = {
        let node = StepsWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.progress = 0
        node.steps = 5000
        return node
    }()
    
    private let weightMeasureWidget: WeightWidgetNode = {
        let node = WeightWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        return node
    }()
    
    private let notesWidget: NoteWidgetNode = {
        let node = NoteWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let addWidgetButton: BasicButtonNode = {
        let node = BasicButtonNode(type: .add, with: CTWidgetNodeConfiguration(type: .compact))
        node.style.preferredSize = CGSize(
            width: 308,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        node.addTarget(nil,
                       action: #selector(didTapButton),
                       forControlEvents: .touchUpInside)
        return node
    }()
    
    @objc private func didTapButton() {
        stepsWidget.progress += 0.05
    }
    
    private let barCodeScannerButton: ScanButtonNode = {
        let node = ScanButtonNode(with: CTWidgetNodeConfiguration(type: .compact))
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
