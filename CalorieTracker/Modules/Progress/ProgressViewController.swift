//
//  ProgressViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 07.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProgressViewControllerInterface: AnyObject {

}

final class ProgressViewController: UIViewController {
    enum Period {
        case daily
        case weekly
        case monthly
        
        func getTitle() -> String {
            switch self {
            case .daily:
                return "DAILY"
            case .weekly:
                return "WEEKLY"
            case .monthly:
                return "MONTHLY"
            }
        }
    }
    
    var presenter: ProgressPresenterInterface?
    
    private lazy var progressTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 24)
        label.textColor = R.color.progressScreen.title()
        label.text = "PROGRESS"
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.progressScreen.settings(), for: .normal)
        button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var segmentedControl: SegmentedControl<Period> = {
        typealias ButtonType = SegmentedButton<Period>.Model
        let view = SegmentedControl<Period>([
            ButtonType(
                title: Period.daily.getTitle(),
                normalColor: R.color.progressScreen.segmentedTitle(),
                selectedColor: R.color.progressScreen.title(),
                id: .daily
            ),
            ButtonType(
                title: Period.weekly.getTitle(),
                normalColor: R.color.progressScreen.segmentedTitle(),
                selectedColor: R.color.progressScreen.title(),
                id: .weekly
            ),
            ButtonType(
                title: Period.monthly.getTitle(),
                normalColor: R.color.progressScreen.segmentedTitle(),
                selectedColor: R.color.progressScreen.title(),
                id: .monthly
            )
        ])
        view.backgroundColor = R.color.progressScreen.segmented()
        view.distribution = .fillEqually
        view.insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        view.selectorRadius = 14
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        view.bouncesZoom = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var widgetContainersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.progressScreen.background()
        return view
    }()
    
    private lazy var viewChartFirst: LineChartView = {
        let view = LineChartView(.weight)
        view.titleChart = "WEIGHT"
        return view
    }()
    
    private lazy var viewChartSec: UIImageView = {
        let view = UIImageView()
        view.image = R.image.progressScreen.weight()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var viewChartThird: UIImageView = {
        let view = UIImageView()
        view.image = R.image.progressScreen.carb()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var viewChartFour: UIImageView = {
        let view = UIImageView()
        view.image = R.image.progressScreen.dietary()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var viewChartFive: UIImageView = {
        let view = UIImageView()
        view.image = R.image.progressScreen.calories()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupView()
        
        segmentedControl.onSegmentChanged = { model in
            let conteiners = self.getWidgetContainers()
            switch model.id {
            case .daily:
                conteiners.forEach { ($0.view.setChartFormat(.daily)) }
            case .weekly:
                conteiners.forEach { ($0.view.setChartFormat(.weekly)) }
            case .monthly:
                conteiners.forEach { ($0.view.setChartFormat(.monthly)) }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard flag else { return }
        configureStack(presenter?.getWidgetTypes() ?? [])
        getWidgetContainers().forEach { $0.view.setChartFormat(.daily) }
        flag = false
    }
    
    private func setupView() {
        view.backgroundColor = R.color.progressScreen.background()
        
        view.addSubviews(
            scrollView,
            bottomBackgroundView
        )
        
        scrollView.addSubviews(
            progressTitleLabel,
            settingsButton,
            widgetContainersStack
        )
        
        bottomBackgroundView.addSubview(segmentedControl)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBackgroundView.snp.top)
        }
        
        bottomBackgroundView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(CTTabBar.Constants.tabBarHeight + 70)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(48)
        }
        
        progressTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalToSuperview().offset(view.safeAreaInsets.top + 16)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(progressTitleLabel)
            make.trailing.equalTo(view).offset(-20)
        }
        
        widgetContainersStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(28)
        }
    }
    
    private func configureStack(_ data: [WidgetType]) {
        let views = data.map { WidgetContainerView(createWidget($0)) }
        
        widgetContainersStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        widgetContainersStack.addArrangedSubviews(views)
        widgetContainersStack.spacing = -view.frame.height * 0.12
        
        views.reversed().enumerated().forEach {
            $0.element.index = $0.offset
            $0.element.blackout = $0.offset != 0
            $0.element.snp.makeConstraints { make in
                make.height.equalTo(self.view).multipliedBy(0.24)
            }
            switch segmentedControl.selectedButton?.model.id {
            case .daily:
                $0.element.view.setChartFormat(.daily)
            case .weekly:
                $0.element.view.setChartFormat(.weekly)
            case .monthly:
                $0.element.view.setChartFormat(.monthly)
            default:
                break
            }
        }
    }
    
    private func getWidgetContainers() -> [WidgetContainerView] {
        widgetContainersStack.arrangedSubviews.compactMap { $0 as? WidgetContainerView }
    }
    
    private func createWidget(_ type: WidgetType) -> WidgetChart {
        switch type {
        case .weight:
            return LineChartView(.weight)
        case .calories:
            return DiagramChartView(.calories)
        case .bmi:
            return LineChartView(.bmi)
        case .carb:
            return DiagramChartView(.carb)
        case .dietary:
            return TripleDiagramChartView(.dietary)
        case .protein:
            return DiagramChartView(.carb)
        case .steps:
            return DiagramChartView(.steps)
        case .water:
            return DiagramChartView(.water)
        case .exercises:
            return DoubleDiagramChartView(.exercises)
        case .active:
            return DiagramChartView(.activity)
        }
    }
    
    @objc private func didTapSettingsButton(_ sender: UIButton) {
        let vc = ProgressSettingsRouter.setupModule()
        vc.modalPresentationStyle = .fullScreen
        vc.didSaveData = { data in
            self.configureStack(data)
        }
        present(vc, animated: true)
    }
}

extension ProgressViewController: ProgressViewControllerInterface {

}

extension ProgressViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let containers = getWidgetContainers()
        if scrollView.contentOffset.y < -50 {
            containers.reversed().enumerated().forEach {
                $0.element.blackout = $0.offset != 0
            }
      
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.widgetContainersStack.spacing = (containers.first?.frame.height ?? 0) / -2.0
            }
        } else if scrollView.contentOffset.y > 80 {
            containers.forEach { $0.blackout = false }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.widgetContainersStack.spacing = 12
            }
        }
    }
}
