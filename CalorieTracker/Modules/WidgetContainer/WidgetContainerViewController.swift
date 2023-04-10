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
    private let anchorView: UIView?
    enum WidgetType {
        case water(specificDate: Date)
        case steps
        case calendar
        case notes
        case weight
        case exercises
        case main
        case `default`
    }
    
    var presenter: WidgetContainerPresenterInterface?
    var output: WidgetContainerOutput?
    
    static var suggestedSideInset: CGFloat { Size(type: .widget).suggestedSideInset }
    static var suggestedTopSafeAreaOffset: CGFloat { Size(type: .widget).suggestedTopSafeAreaOffset }
    static var safeAreaTopInset: CGFloat { Size(type: .widget).safeAreaTopInset }
    static var suggestedInterItemSpacing: CGFloat { Size(type: .widget).suggestedInterItemSpacing }
    static var tabBarHeight: CGFloat { Size(type: .widget).tabBarHeight + bottomInset }
    static var bottomInset: CGFloat { CTTabBarController.Constants.bottomInset }
    static var screenSize: CGSize { UIScreen.main.bounds.size }
    
    var minTopInset: CGFloat {
        Self.safeAreaTopInset
        + Self.suggestedTopSafeAreaOffset
        + Size(type: .compact).height
        + 2 * Self.suggestedInterItemSpacing
        + Size(type: .widget).height
    }
    
    var minBottomInset: CGFloat { Self.tabBarHeight + Self.suggestedInterItemSpacing }
    
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
        case .main:
            return .zero
        case .default:
            return .zero
        }
    }
    
    let widgetType: WidgetType
    
    private let widgetView: UIView
    
    init(_ type: WidgetType, anchorView: UIView? = nil) {
        self.widgetType = type
        self.anchorView = anchorView
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
    
    func getWidgetView () -> UIView {
        widgetType.getWidget()
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
                top: Size(type: .widget).height
                + Self.suggestedInterItemSpacing * 2
                + Size(type: .compact).height
                + Self.safeAreaTopInset,
                left: Self.suggestedSideInset,
                bottom: minBottomInset,
                right: Self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (Self.screenSize.width - 2 * Self.suggestedSideInset) * 1.361
            let topInsets = Self.screenSize.height - height - minBottomInset
            return .init(
                top: topInsets,
                left: Self.suggestedSideInset,
                bottom: minBottomInset,
                right: Self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    private func getCalendarWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset
            + Size(type: .compact).height
        + Self.suggestedInterItemSpacing
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x430, .h19x393:
            return .init(
                top: minTopInset,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (Self.screenSize.width - 2 * Self.suggestedSideInset) * 0.947
            let topInsets = Self.screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
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
        + Self.suggestedInterItemSpacing
        
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x430, .h19x393:
            let topInset = minTopInset + Size(type: .large).height + Self.suggestedInterItemSpacing
            return .init(
                top: topInset,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (Self.screenSize.width - 2 * Self.suggestedSideInset) * 0.638
            let topInsets = Self.screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
            )
        case .unknown:
            return .zero
        }
    }
    
    private func getWaterWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset
            + Size(type: .compact).height
        + Self.suggestedInterItemSpacing
        
        switch UIDevice.screenType {
        case .h19x414, .h19x428, .h19x375, .h19x390, .h19x393, .h19x430:
            return .init(
                top: minTopInset,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
            )
        case .h16x414, .h16x375:
            let height = (Self.screenSize.width - 2 * Self.suggestedSideInset) * 0.963
            let topInsets = Self.screenSize.height - height - bottomInset
            return .init(
                top: topInsets,
                left: Self.suggestedSideInset,
                bottom: bottomInset,
                right: Self.suggestedSideInset
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
        let presentationController = WidgetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            insets: widgetInsets
        )
        
        presentationController.willCloseController = {
            self.didTapView()
        }
        
        return presentationController
    }
    
    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch widgetType {
        case .water(specificDate: let date):
            return  WidgetPresentTransitionController(
                anchorView: anchorView ?? UIView(),
                widgetType: .water(specificDate: date)
            )
//            return TopDownPresentTransition()
        case .calendar:
//            return TopDownPresentTransition()
            return  WidgetPresentTransitionController(anchorView: anchorView ?? UIView(), widgetType: .calendar)
        case .weight:
            return WidgetPresentTransitionController(anchorView: anchorView ?? UIView(), widgetType: .weight)
        case .steps:
//            return TopDownPresentTransition()
            return WidgetPresentTransitionController(anchorView: anchorView ?? UIView(), widgetType: .steps)
        default:
            return  TopDownPresentTransition()
        }
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch widgetType {
        case .water(specificDate: let date):
            return  WidgetDismissTransitionController(
                anchorView: anchorView ?? UIView(),
                widgetType: .water(specificDate: date)
            )
//            return TopDownPresentTransition()
        case .calendar:
            return  WidgetDismissTransitionController(anchorView: anchorView ?? UIView(), widgetType: .calendar)
        case .weight:
//                        return TopDownDismissTransition()
            return WidgetDismissTransitionController(anchorView: anchorView ?? UIView(), widgetType: .weight)
        default:
            return  TopDownDismissTransition()
        }
    }
}

extension WidgetContainerViewController.WidgetType {
    func getWidget() -> UIView {
        switch self {
        case .water(let date):
            return WaterFullWidgetView(with: date)
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
        case .main:
            return UIView()
        case .default:
            return UIView()
        }
    }
}
