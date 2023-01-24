//
//  WidgetContainerViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.12.2022.
//

import UIKit

protocol WidgetContainerInterface: AnyObject {
    func update()
}

protocol WidgetContainerOutput: AnyObject {
    func needUpdateWidget(_ type: WidgetContainerViewController.WidgetType)
    func needUpdateCalendarWidget(_ date: Date?)
}

final class WidgetContainerViewController: UIViewController {
    typealias Size = CTWidgetNodeConfiguration
    
    enum WidgetType {
        case water
        case steps
        case calendar
        case notes
        case weight
        case exercises
        case `default`
    }
    
    var presenter: WidgetContainerPresenterInterface?
    var output: WidgetContainerOutput?
    
    var suggestedSideInset: CGFloat { Size(type: .widget).suggestedSideInset }
    var suggestedTopSafeAreaOffset: CGFloat { Size(type: .widget).suggestedTopSafeAreaOffset }
    var safeAreaTopInset: CGFloat { Size(type: .widget).safeAreaTopInset }
    var suggestedInterItemSpacing: CGFloat { Size(type: .widget).suggestedInterItemSpacing }
    var tabBarHeight: CGFloat { Size(type: .widget).tabBarHeight + bottomInset }
    var bottomInset: CGFloat { CTTabBarController.Constants.bottomInset }
    var screenSize: CGSize { UIScreen.main.bounds.size }
    
    var minTopInset: CGFloat {
        safeAreaTopInset
        + suggestedTopSafeAreaOffset
        + Size(type: .compact).height
        + 2 * suggestedInterItemSpacing
        + Size(type: .widget).height
    }
    
    var minBottomInset: CGFloat { tabBarHeight + suggestedInterItemSpacing }
    
    var widgetInsets: UIEdgeInsets {
        switch widgetType {
        case .weight:
            return getWeightWidgetInsets()
        case .calendar:
            return getCalendarWidgetInsets()
        case .exercises:
            return getExercisesWidgetInsets()
        case .notes:
            return getNotesWidgetInsets()
        case .steps:
            return getStepsWidgetInsets()
        case .water:
            return getWaterWidgetInsets()
        case .default:
            return .zero
        }
    }
    
    let widgetType: WidgetType
    
    private let widgetView: UIView
    
    init(_ type: WidgetType) {
        self.widgetType = type
        self.widgetView = type.getWidget()
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureOutput()
        setupConstraints()
    }
    
    private func configureOutput() {
        switch widgetType {
        case .weight:
            (widgetView as? WeightFullWidgetView)?.output = self
        case .steps:
            (widgetView as? StepsFullWidgetView)?.output = self
        case .water:
            (widgetView as? WaterFullWidgetView)?.output = self
        default:
            break
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        let widgetFull = widgetView as? CTWidgetFullProtocol
        widgetFull?.didTapCloseButton = {
            switch self.widgetType {
            case .calendar:
                self.output?.needUpdateCalendarWidget(
                    (self.widgetView as? CalendarFullWidgetView)?.date
                )
            default:
                self.output?.needUpdateWidget(self.widgetType)
            }
            self.presenter?.didTapView()
        }
    }
    
    private func setupConstraints() {
        view.addSubview(widgetView)
        
        widgetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getWeightWidgetInsets() -> UIEdgeInsets {
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x393, .h19x430:
            return .init(
                top: minTopInset,
                left: self.suggestedSideInset,
                bottom: self.bottomInset,
                right: self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (screenSize.width - 2 * suggestedSideInset) * 1.361
            let topInsets = screenSize.height - height - minBottomInset
            return .init(
                top: topInsets,
                left: self.suggestedSideInset,
                bottom: self.minBottomInset,
                right: self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    private func getCalendarWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset
            + Size(type: .compact).height
            + suggestedInterItemSpacing
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x430, .h19x393:
            return .init(
                top: minTopInset,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (screenSize.width - 2 * suggestedSideInset) * 0.947
            let topInsets = screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    private func getExercisesWidgetInsets() -> UIEdgeInsets {
        return .zero
    }
    
    private func getNotesWidgetInsets() -> UIEdgeInsets {
        return .zero
    }
    
    private func getStepsWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset
            + Size(type: .compact).height
            + suggestedInterItemSpacing
        
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x430, .h19x393:
            let topInset = minTopInset + Size(type: .large).height + suggestedInterItemSpacing
            return .init(
                top: topInset,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (screenSize.width - 2 * suggestedSideInset) * 0.638
            let topInsets = screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    private func getWaterWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset
            + Size(type: .compact).height
            + suggestedInterItemSpacing
        
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x393, .h19x430:
            return .init(
                top: minTopInset,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (screenSize.width - 2 * suggestedSideInset) * 0.963
            let topInsets = screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: self.suggestedSideInset,
                bottom: bottomInset,
                right: self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    @objc private func didTapView() {
        switch self.widgetType {
        case .calendar:
            self.output?.needUpdateCalendarWidget(
                (self.widgetView as? CalendarFullWidgetView)?.date
            )
        default:
            self.output?.needUpdateWidget(self.widgetType)
        }
        
        presenter?.didTapView()
    }
}

extension WidgetContainerViewController: WidgetContainerInterface {
    func update() {
        (widgetView as? CTWidgetFullProtocol)?.update()
    }
}

extension WidgetContainerViewController: WeightFullWidgetOutput {
    func setGoal(_ widget: WeightFullWidgetView) {
        presenter?.openChangeWeightViewController(.set)
    }
    
    func addWeight(_ widget: WeightFullWidgetView) {
        presenter?.openChangeWeightViewController(.add)
    }
}

extension WidgetContainerViewController: WaterFullWidgetOutput {
    func setQuickAdd(_ widget: WaterFullWidgetView, complition: @escaping (QuickAddModel) -> Void) {
        let vc = KeyboardEnterValueViewController(.water)
        
        vc.waterComplition = { model in
            complition(model)
        }
        
        present(vc, animated: true)
    }
    
    func setGoal(_ widget: WaterFullWidgetView) {
        presenter?.setGoalWater()
    }
}

extension WidgetContainerViewController: StepsFullWidgetOutput {
    func setGoal(_ widget: StepsFullWidgetView) {
        presenter?.openChangeStepsViewController()
    }
}

extension WidgetContainerViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        WidgetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            insets: widgetInsets
        )
    }
    
    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TopDownPresentTransition()
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TopDownDismissTransition()
    }
}

extension WidgetContainerViewController.WidgetType {
    func getWidget() -> UIView {
        switch self {
        case .water:
            return WaterFullWidgetView()
        case .steps:
            return StepsFullWidgetView()
        case .calendar:
            return CalendarFullWidgetView()
        case .notes:
            return UIView()
        case .weight:
            return WeightFullWidgetView()
        case .exercises:
            return UIView()
        case .default:
            return UIView()
        }
    }
}
