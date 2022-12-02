//
//  WeightFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 24.08.2022.
//

import UIKit

protocol WeightFullWidgetInterface: AnyObject {
    
}

final class WeightFullWidgetView: UIView, CTWidgetFullProtocol {
    var didTapCloseButton: (() -> Void)?
    
    private lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.sfProDisplaySemibold(size: 22)
        label.textColor = R.color.weightWidget.weightTextColor()
        label.text = "WEIGHT"
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(
            R.image.weightWidget.settings(),
            for: .normal
        )
        return button
    }()
    
    private lazy var segmentedControl: SegmentedControl<HistoryHeaderButtonType> = {
        typealias ButtonType = SegmentedButton<HistoryHeaderButtonType>.Model
        let view = SegmentedControl<HistoryHeaderButtonType>([
            ButtonType(
                title: HistoryHeaderButtonType.weak.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .weak
            ),
            ButtonType(
                title: HistoryHeaderButtonType.months.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .months
            ),
            ButtonType(
                title: HistoryHeaderButtonType.twoMonths.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .twoMonths
            ),
            ButtonType(
                title: HistoryHeaderButtonType.threeMonths.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .threeMonths
            ),
            ButtonType(
                title: HistoryHeaderButtonType.sixMonths.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .sixMonths
            ),
            ButtonType(
                title: HistoryHeaderButtonType.year.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .year
            ),
            ButtonType(
                title: HistoryHeaderButtonType.allTheTime.getTitle(),
                normalColor: R.color.weightWidget.segmentedButton(),
                selectedColor: R.color.weightWidget.weightTextColor(),
                id: .allTheTime
            )
        ])
        view.backgroundColor = R.color.weightWidget.segmentedControl()
        
        return view
    }()
    
    private lazy var addButton: BasicButtonView = {
        let button = BasicButtonView(
            type: .custom(
                CustomType(
                    image: CustomType.Image(
                        isPressImage: R.image.weightWidget.plus(),
                        defaultImage: R.image.weightWidget.plus(),
                        inactiveImage: nil
                    ),
                    title: CustomType.Title(
                        isPressTitleColor: R.color.weightWidget.backgroundLabelColor(),
                        defaultTitleColor: .white
                    ),
                    backgroundColorInactive: nil,
                    backgroundColorDefault: R.color.weightWidget.weightTextColor(),
                    backgroundColorPress: R.color.weightWidget.weightTextColor(),
                    gradientColors: nil,
                    borderColorInactive: nil,
                    borderColorDefault: R.color.weightWidget.backgroundLabelColor(),
                    borderColorPress: R.color.weightWidget.backgroundLabelColor()
                )
            )
        )
        
        button.isPressTitle = " ADD WEIGHING"
        button.defaultTitle = " ADD WEIGHING"
        
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(
            R.image.weightWidget.closeArrow(),
            for: .normal
        )
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        return view
    }()
    
    private let chart = WeightLineChart()
    private let headerView = WeightHeaderView()
    private var presenter: WeightFullWidgetPresenterInterface?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        presenter = WeightFullWidgetPresenter(view: self)
        setupView()
        setupConstraints()
        configureView(period: .weak)
        
        segmentedControl.onSegmentChanged = { [weak self] type in
            self?.configureView(period: type.id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.cornerCurve = .circular
        
        scrollView.addSubview(segmentedControl)
        addSubviews([
            topTitleLabel,
            settingsButton,
            headerView,
            scrollView,
            chart,
            addButton,
            closeButton
        ])
        
        addButton.addTarget(self,
                            action: #selector(didTapAddButton),
                            for: .touchUpInside)
        closeButton.addTarget(self,
                              action: #selector(didTapBottomCloseButton),
                              for: .touchUpInside)
        settingsButton.addTarget(self,
                                 action: #selector(didTapSettingsButton),
                                 for: .touchUpInside)
    }
    
    private func configureView(period: HistoryHeaderButtonType) {
        guard let startDate = presenter?.getStartDate(period: period),
              let chartData = presenter?.getChartData(period: period) else { return }
        
        chart.model = WeightLineChart.Model(
            data: chartData,
            dateStart: startDate,
            goal: presenter?.getGoalWeight()
        )
        
        headerView.model = WeightHeaderView.Model(
            start: String(
                format: "%.1f",
                presenter?.getStartWeight(period: period) ?? 0
            ).replacingOccurrences(of: ".", with: ","),
            now: String(
                format: "%.1f kg",
                presenter?.getNowWeight() ?? 0
            ).replacingOccurrences(of: ".", with: ","),
            goal: String(
                format: "%.1f",
                presenter?.getGoalWeight() ?? 0
            ).replacingOccurrences(of: ".", with: ",")
        )
        
        switch period {
        case .weak, .months:
            chart.drawPoints = true
        case .twoMonths, .threeMonths, .sixMonths, .year, .allTheTime:
            chart.drawPoints = false
        }
    }
    
    private func setupConstraints() {
        topTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(topTitleLabel)
            make.trailing.equalToSuperview().inset(18)
        }
        
        headerView.aspectRatio(0.12)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(topTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(scrollView)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.aspectRatio(0.104)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        chart.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(31)
            make.leading.equalToSuperview().inset(50)
        }
        
        addButton.aspectRatio(0.182)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(chart.snp.bottom).offset(45)
            make.trailing.leading.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(self.snp.width).multipliedBy(0.167)
        }
    }
    
    @objc private func didTapAddButton() {
        
    }
    
    @objc private func didTapBottomCloseButton() {
        didTapCloseButton?()
    }
    
    @objc private func didTapSettingsButton() {
        
    }
}

extension WeightFullWidgetView: WeightFullWidgetInterface {
    
}
