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
    private lazy var backgroundView = UIView()
    
    init(_ type: WidgetType) {
        self.widgetType = type
        self.widgetView = type.getWidget()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureOutput()
        setupConstraints()
        addTapGestureRecognizer()
    }
    
    private func configureOutput() {
        switch widgetType {
        case .weight:
            (widgetView as? WeightFullWidgetView)?.output = self
        case .steps:
            (widgetView as? StepsFullWidgetView)?.output = self
        default:
            break
        }
    }
    
    private func setupView() {
        backgroundView.backgroundColor = R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.25)
        
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
        view.addSubviews(backgroundView, widgetView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        widgetView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(widgetInsets.top)
            make.bottom.equalToSuperview().offset(-widgetInsets.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(widgetInsets.left)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-widgetInsets.right)
        }
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapView)
        )
        tapGestureRecognizer.cancelsTouchesInView = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func getWeightWidgetInsets() -> UIEdgeInsets {
        return .init(
            top: minTopInset,
            left: self.suggestedSideInset,
            bottom: self.bottomInset,
            right: self.suggestedSideInset
        )
    }
    
    private func getCalendarWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset + Size(type: .compact).height + suggestedInterItemSpacing
        return .init(
            top: minTopInset,
            left: self.suggestedSideInset,
            bottom: bottomInset,
            right: self.suggestedSideInset
        )
    }
    
    private func getExercisesWidgetInsets() -> UIEdgeInsets {
        return .zero
    }
    
    private func getNotesWidgetInsets() -> UIEdgeInsets {
        return .zero
    }
    
    private func getStepsWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset + Size(type: .compact).height + suggestedInterItemSpacing
        let topInset = minTopInset + Size(type: .large).height + suggestedInterItemSpacing
        return .init(
            top: topInset,
            left: self.suggestedSideInset,
            bottom: bottomInset,
            right: self.suggestedSideInset
        )
    }
    
    private func getWaterWidgetInsets() -> UIEdgeInsets {
        let bottomInset = minBottomInset + Size(type: .compact).height + suggestedInterItemSpacing
        return .init(
            top: minTopInset,
            left: self.suggestedSideInset,
            bottom: bottomInset,
            right: self.suggestedSideInset
        )
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

extension WidgetContainerViewController: StepsFullWidgetOutput {
    func setGoal(_ widget: StepsFullWidgetView) {
        presenter?.openChangeStepsViewController()
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
