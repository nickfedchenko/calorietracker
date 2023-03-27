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
    func setWaterWidgetModel(_ model: WaterWidgetNode.Model)
    func setStepsWidget(now: Int, goal: Int?)
    func setWeightWidget(weight: CGFloat?)
    func setMessageWidget(_ text: String)
    func setActivityWidget(_ model: MainWidgetViewNode.Model)
    func setCalendarWidget(_ model: CalendarWidgetNode.Model)
    func setExersiceWidget(_ model: ExercisesWidgetNode.Model, _ isConnectedAH: Bool)
    func setNoteWidget(_ model: LastNoteView.Model?)
}
//
class MainScreenViewController: ASDKViewController<ASDisplayNode> {
    
    // MARK: - Public properties
    var presenter: MainScreenPresenterInterface?
    
    // MARK: - Private properties
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let messageNode: AppMessageWidgetNode = {
        let node = AppMessageWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.style.preferredSize = CGSize(width: 308, height: node.constants.height)
        node.style.flexShrink = 0.75
        node.backgroundColor = .clear
        node.shadowLayer.isHidden = true
        return node
    }()
    
    private let mainActivityWidget: MainWidgetViewNode = {
        let node = MainWidgetViewNode(with: CTWidgetNodeConfiguration(type: .widget))
//        node.backgroundColor = R.color.mainDarkGreen()
        node.allowsEdgeAntialiasing = true
        node.style.preferredSize = CGSize(
            width: 388,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let calendarWidget: CalendarWidgetNode = {
        let node = CalendarWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        return node
    }()
    
    private let waterBalanceWidget: WaterWidgetNode = {
        let node = WaterWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let exercisesWidget: ExercisesWidgetNode = {
        let node = ExercisesWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
        node.style.preferredSize = CGSize(
            width: 260,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        return node
    }()
    
    private let stepsWidget: StepsWidgetNode = {
        let node = StepsWidgetNode(with: CTWidgetNodeConfiguration(type: .large))
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
    
    private lazy var barCodeScannerButton: ScanButtonNode = {
        let node = ScanButtonNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.addTarget(self, action: #selector(barcodeScanButtonTapped), forControlEvents: .touchUpInside)
        return node
    }()
    
    private lazy var undercoverNode: GradientNode = {
        let node = GradientNode()
        node.style.preferredSize = CGSize(
            width: view.bounds.width, height: 140
            )
        node.style.flexGrow = 1
        return node
    }()
    
    private let scrollNode: ASScrollNode? = {
        guard UIDevice.screenType == .h16x375 || UIDevice.screenType == .h16x414 else {
            return nil
        }
  
        let sampleNode = CTWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        let safeAreaInset = sampleNode.constants.suggestedTopSafeAreaOffset

        let scrollNode = ASScrollNode()
        scrollNode.view.showsVerticalScrollIndicator = false
        scrollNode.view.showsHorizontalScrollIndicator = false
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyRelayoutOnSafeAreaChanges = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.view.contentInsetAdjustmentBehavior = .never
        scrollNode.view.contentInset = .init(
            top: 0,
            left: 0,
            bottom: 140 - safeAreaInset - CTWidgetNodeConfiguration(type: .widget).safeAreaTopInset,
            right: 0
        )
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
    
    private lazy var addWidgetButton: BasicButtonNode = {
        let node = BasicButtonNode(type: .add, with: CTWidgetNodeConfiguration(type: .compact))
        node.style.preferredSize = CGSize(
            width: 308,
            height: node.constants.height
        )
        node.style.flexShrink = 0.75
        node.addTarget(
            self,
            action: #selector(didTapButton),
            forControlEvents: .touchDown
        )
        return node
    }()
    
    private lazy var menuButton: AppWidgetNode = {
        let node = AppWidgetNode(with: CTWidgetNodeConfiguration(type: .compact))
        node.addTarget(
            self,
            action: #selector(didTapMenuButton),
            forControlEvents: .touchUpInside
        )
        return node
    }()
    
    // MARK: - Init
    // swiftlint:disable:next function_body_length
    override init() {
        super.init(node: ASDisplayNode())
        node.automaticallyRelayoutOnSafeAreaChanges = true
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = R.color.mainBackground()
        
        node.layoutSpecBlock = { node, size in
            if let scrollNode = self.scrollNode {
                let insetSpecs = ASInsetLayoutSpec(
                    insets: .zero,
                    child: scrollNode
                )
                self.undercoverNode.layoutSpecBlock = { _, size in
                    let stack = ASStackLayoutSpec(
                        direction: .horizontal,
                        spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
                        justifyContent: .center,
                        alignItems: .stretch,
                        children: [self.addWidgetButton, self.barCodeScannerButton]
                        )
                    let inset = ASInsetLayoutSpec(
                        insets: .init(
                            top: 8,
                            left: self.addWidgetButton.constants.suggestedSideInset,
                            bottom: 0,
                            right: self.addWidgetButton.constants.suggestedSideInset
                        ),
                        child: stack
                    )
                    return inset
                }

                let overlayStack = ASStackLayoutSpec(
                    direction: .vertical,
                    spacing: .zero,
                    justifyContent: .start,
                    alignItems: .start, children: [self.undercoverNode]
                )
                let overlayInset = ASInsetLayoutSpec(
                    insets: .init(
                        top: self.view.bounds.height - 140,
                        left: 0,
                        bottom: 0,
                        right: 0
                    ),
                    child: overlayStack
                )
                let overlay = ASOverlayLayoutSpec(child: insetSpecs, overlay: overlayInset)
                
                return overlay
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizer()
        presenter?.checkOnboarding()
        generator.prepare()
        setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.navigationBar.isHidden = true
        presenter?.updateWaterWidgetModel()
        presenter?.updateStepsWidget()
        presenter?.updateWeightWidget()
        presenter?.updateExersiceWidget()
        presenter?.updateMessageWidget()
        presenter?.updateActivityWidget()
        presenter?.updateCalendarWidget(UDM.currentlyWorkingDay.date)
        presenter?.updateNoteWidget()
        let weights = WeightWidgetService.shared.getAllWeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let now = Date().timeIntervalSince1970
//        navigationController?.setToolbarHidden(true, animated: true)
//        navigationController?.navigationBar.isHidden = true
//        presenter?.updateWaterWidgetModel()
//        presenter?.updateStepsWidget()
//        presenter?.updateWeightWidget()
//        presenter?.updateExersiceWidget()
//        presenter?.updateMessageWidget()
//        presenter?.updateActivityWidget()
//        presenter?.updateCalendarWidget(UDM.currentlyWorkingDay.date)
//        presenter?.updateNoteWidget()
//        let new = Date().timeIntervalSince1970
//        print("main screen time passed \(new - now)")
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
        
//        let sixthHStack = ASStackLayoutSpec(
//            direction: .horizontal,
//            spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
//            justifyContent: .start,
//            alignItems: .stretch,
//            children: [self.addWidgetButton, self.barCodeScannerButton]
//        )
        
        var mainVStackChilds = [firstHStack, secondHStack, thirdHStack, fourthHStack, fifthHStack]
        if UIDevice.screenType != .h16x414 && UIDevice.screenType != .h16x375 {
            let sixthHStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: self.calendarWidget.constants.suggestedInterItemSpacing,
                justifyContent: .start,
                alignItems: .stretch,
                children: [self.addWidgetButton, self.barCodeScannerButton]
            )
            mainVStackChilds.append(sixthHStack)
        }
        
        let VStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: self.menuButton.constants.suggestedInterItemSpacing,
            justifyContent: .start,
            alignItems: .start,
            children: mainVStackChilds
        )
        
        let stackInset = ASInsetLayoutSpec(
            insets: .init(
                top: self.menuButton.constants.suggestedTopSafeAreaOffset
                + CTWidgetNodeConfiguration(type: .widget).safeAreaTopInset,
                left: self.menuButton.constants.suggestedSideInset,
                bottom: 0,
                right: self.menuButton.constants.suggestedSideInset
            ),
            child: VStack
        )
        
        return stackInset
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHKStepsWidgetByObserver),
            name: Notification.Name("UpdateStepsWidget"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHKExercisesWidgetByObserver),
            name: Notification.Name("UpdateExercisesWidget"),
            object: nil
        )
    }
    
    private func addTapGestureRecognizer() {
        [
            calendarWidget,
            waterBalanceWidget,
            weightMeasureWidget,
            notesWidget, stepsWidget,
            exercisesWidget,
            mainActivityWidget
        ]
            .forEach {
                $0.addTarget(
                    self,
                    action: #selector(didTapWidget),
                    forControlEvents: .touchUpInside
                )
            }
    }
    
    @objc private func updateHKStepsWidgetByObserver() {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.updateStepsWidget()
        }
    }
    
    @objc private func updateHKExercisesWidgetByObserver() {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.updateExersiceWidget()
        }
    }
    
    @objc private func didTapWidget(_ sender: ASControlNode) {
        Vibration.medium.vibrate()
        
        guard let widget = sender as? CTWidgetProtocol else {
            return
        }
        
        switch widget.widgetType {
        case .calendar:
            LoggingService.postEvent(event: .calwopen)
            presenter?.didTapWidget(widget.widgetType, anchorView: calendarWidget.view)
        case .weight:
            presenter?.didTapWidget(widget.widgetType, anchorView: weightMeasureWidget.view)
            LoggingService.postEvent(event: .weightwopen)
        case .steps:
            presenter?.didTapWidget(widget.widgetType, anchorView: stepsWidget.view)
            LoggingService.postEvent(event: .stepswopen)
        case .water:
            presenter?.didTapWidget(
                .water(specificDate: presenter?.getPointDate() ?? Date()), anchorView: waterBalanceWidget.view
            )
            LoggingService.postEvent(event: .waterwopen)
        case .exercises:
            presenter?.didTapExerciseWidget()
        case .notes:
            presenter?.didTapNotesWidget()
            LoggingService.postEvent(event: .notewopen)
        case .main:
            presenter?.didTapMainWidget()
        default:
            return
        }
    }
    
    @objc private func didTapMenuButton() {
        Vibration.medium.vibrate()
        presenter?.didTapMenuButton()
    }
    
    @objc private func didTapButton() {
        Vibration.medium.vibrate()
        if scrollNode != nil {
            UDM.mainScreenAddButtonOriginY = undercoverNode.convert(addWidgetButton.frame, to: node).origin.y
        } else {
            UDM.mainScreenAddButtonOriginY = addWidgetButton.frame.origin.y
        }
        presenter?.didTapAddButton()
    }
    
    @objc private func barcodeScanButtonTapped() {
        presenter?.didTapBarcodeScannerButton()
    }
}

extension MainScreenViewController: MainScreenViewControllerInterface {
    func setMessageWidget(_ text: String) {
        messageNode.text = text
    }
    
    func setActivityWidget(_ model: MainWidgetViewNode.Model) {
        mainActivityWidget.model = model
    }
    
    func setCalendarWidget(_ model: CalendarWidgetNode.Model) {
        calendarWidget.model = model
    }
    
    func setExersiceWidget(_ model: ExercisesWidgetNode.Model, _ isConnectedAH: Bool) {
        exercisesWidget.model = model
        exercisesWidget.isConnectAH = isConnectedAH
    }
    
    func setWaterWidgetModel(_ model: WaterWidgetNode.Model) {
        self.waterBalanceWidget.model = model
    }
    
    func setStepsWidget(now: Int, goal: Int?) {
        self.stepsWidget.steps = now
        self.stepsWidget.progress = Double(now) / Double(goal ?? 1)
    }
    
    func setWeightWidget(weight: CGFloat?) {
        self.weightMeasureWidget.weight = weight
    }
    
    func setNoteWidget(_ model: LastNoteView.Model?) {
        notesWidget.model = model
    }
}

// MARK: - transition helpers
extension MainScreenViewController {
    // MARK: - Public methods
    func setToBeginningTransition() {
        addWidgetButton.alpha = 0
        barCodeScannerButton.alpha = 0
    }
    
    func setToEndedTransition() {
        addWidgetButton.alpha = 1
        barCodeScannerButton.alpha = 1
    }
    
    func getAddButtonSnapshot() -> UIView {
        let snapshot = addWidgetButton.view.snapshotNewView(isOpaque: false)
        UDM.tempAddButtonImage = snapshot?.pngData()
        let view = UIImageView(image: snapshot)
        return view
    }
    
    func makeAddButtonCopy() -> UIView {
        return addWidgetButton.view
    }
    
    func getScannerButtonSnapshot() -> UIView {
        barCodeScannerButton.layoutIfNeeded()
        let snapshot = barCodeScannerButton.view.snapshotNewView(isOpaque: false)
        UDM.tempScannerImage = snapshot?.pngData()
        let view = UIImageView(image: snapshot)
        return view
    }
    
    func getCurrentAddButtonFrame() -> CGRect {
        if scrollNode != nil {
            return undercoverNode.convert(addWidgetButton.frame, to: node)
        } else {
            return addWidgetButton.frame
        }
    }
    
    func getCurrentScannerFrame() -> CGRect {
        if scrollNode != nil {
            return undercoverNode.convert(barCodeScannerButton.frame, to: node)
        } else {
            return barCodeScannerButton.frame
        }
    }
    
    func getTabBarSnapshot() -> UIView {
        guard let tabBarController = tabBarController as? CTTabBarController else { return UIView() }
        return tabBarController.getTabBarSnapshot()
    }
    
    func getTabBarTargetFrame() -> CGRect {
        guard let tabBarController = tabBarController as? CTTabBarController else {
            return .zero
        }
        return tabBarController.getTabBarFrame()
    }
}
