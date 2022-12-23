//
//  DiagramChartView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.08.2022.
//

import UIKit

protocol WidgetChart: UIView {
    func setChartFormat(_ format: ChartFormat)
}

protocol DiagramChartViewInterface: AnyObject {
    func getCountHorizontalLines() -> Int
    func getChartType() -> DiagramChartView.DiagramChartType
}

final class DiagramChartView: UIView {
    enum DiagramChartType {
        case calories
        case carb
        case steps
        case water
        case activity
        case protein
        
        func getTitle() -> String {
            switch self {
            case .calories:
                return "CALORIES"
            case .carb:
                return "CARBOHYDRATES"
            case .steps:
                return "STEPS"
            case .water:
                return "WATER"
            case .activity:
                return "ACTIVITY ENERGY"
            case .protein:
                return "PROTEIN"
            }
        }
        
        func getPostfix() -> String {
            switch self {
            case .calories:
                return "Cal"
            case .carb:
                return "g"
            case .steps:
                return ""
            case .water:
                return BAMeasurement.measurmentSuffix(.liquid)
            case .activity:
                return BAMeasurement.measurmentSuffix(.energy)
            case .protein:
                return BAMeasurement.measurmentSuffix(.energy)
            }
        }
        
        func getColor() -> UIColor? {
            switch self {
            case .calories:
                return R.color.progressScreen.calories()
            case .carb:
                return R.color.progressScreen.carb()
            case .steps:
                return R.color.progressScreen.steps()
            case .water:
                return R.color.progressScreen.water()
            case .activity:
                return R.color.progressScreen.active()
            case .protein:
                return R.color.progressScreen.protein()
            }
        }
    }
    
    private var presenter: DiagramChartViewPresenterInterface?
    
    private let diagramChart = DiagramChart()
    
    private lazy var leftTopLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProDisplaySemibold(size: 22)
        label.textColor = R.color.diagramChart.topTitle()
        return label
    }()
    
    private lazy var leftBottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProDisplaySemibold(size: 13)
        label.textColor = R.color.diagramChart.bottomTitle()
        return label
    }()
    
    private lazy var rightTopLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.sfProDisplaySemibold(size: 22)
        label.textColor = R.color.diagramChart.topTitle()
        return label
    }()
    
    private lazy var rightBottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.sfProDisplaySemibold(size: 13)
        label.textColor = R.color.diagramChart.bottomTitle()
        return label
    }()
    
    private lazy var rightBottomDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.sfProDisplaySemibold(size: 13)
        label.textColor = R.color.diagramChart.bottomTitle()
        return label
    }()
    
    private lazy var middleBottomDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.sfProDisplaySemibold(size: 13)
        label.textColor = R.color.diagramChart.bottomTitle()
        return label
    }()
    
    private lazy var leftBottomDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.sfProDisplaySemibold(size: 13)
        label.textColor = R.color.diagramChart.bottomTitle()
        return label
    }()
    
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 22)
        label.textColor = R.color.diagramChart.message()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var backgroundLinesColor: UIColor? {
        get { diagramChart.backgroundLinesColor }
        set { diagramChart.backgroundLinesColor = newValue }
    }
    var goalLineColor: UIColor? {
        get { diagramChart.goalLineColor }
        set { diagramChart.goalLineColor = newValue }
    }
    var columnColor: UIColor? {
        get { diagramChart.columnColor }
        set { diagramChart.columnColor = newValue }
    }
    var goalValue: Int? {
        get {
            guard let step = data?.step,
                   let goalValue = diagramChart.goalValue else { return nil }
            return Int(goalValue * CGFloat(getCountHorizontalLines() * step))
        }
        set {
            guard let step = data?.step,
                   let newGoalValue = newValue else { return diagramChart.goalValue = nil }
            diagramChart.goalValue = CGFloat(newGoalValue) / CGFloat(getCountHorizontalLines() * step)
        }
    }
    
    var chartFormat: ChartFormat = .weekly {
        didSet {
            setupData()
        }
    }
    
    var data: ChartData?
    let chartType: DiagramChartType
    
    init(_ type: DiagramChartType) {
        self.chartType = type
        super.init(frame: .zero)
        presenter = DiagramChartViewPresenter(view: self)
        setupView()
        setupConstraints()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        guard let chartData = presenter?.getData(chartFormat), !chartData.data.isEmpty else {
            diagramChart.isHidden = true
            leftBottomLabel.layer.opacity = 0
            rightTopLabel.isHidden = true
            leftBottomDateLabel.isHidden = true
            rightBottomDateLabel.isHidden = true
            middleBottomDateLabel.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "There are no measurements. Your first \(chartFormat.rawValue) has not yet passed"
            return
        }
        leftBottomLabel.layer.opacity = 1
        rightBottomLabel.isHidden = false
        leftBottomDateLabel.isHidden = false
        rightBottomDateLabel.isHidden = false
        middleBottomDateLabel.isHidden = false
        messageLabel.isHidden = true
        diagramChart.isHidden = false
        
        self.data = chartData
        diagramChart.defaultColumnColor = chartType == .calories
        ? R.color.diagramChart.backgroundLines()
        : chartType.getColor()?.withAlphaComponent(0.5)
        diagramChart.verticalStep = chartData.step
        diagramChart.moreGoal = chartType == .calories
        goalValue = chartData.goal
        diagramChart.countColumns = max(
            (chartData.data.keys.max() ?? 0) + 1,
            chartFormat == .daily ? 7 : chartFormat == .weekly ? 8 : 6
        )
        diagramChart.data = chartData.data
        
        configureLabels(chartData: chartData)
    }
    
    private func configureLabels(chartData: ChartData) {
        switch chartFormat {
        case .daily:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0 ) + 1) Days"
        case .weekly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Weeks"
        case .monthly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Months"
        }
        
        let maxValue = CGFloat(getCountHorizontalLines() * chartData.step)
        let text = "\(Int(chartData.data.values.sum() / CGFloat(chartData.data.count) * maxValue)) "
        rightTopLabel.text = text + chartType.getPostfix()
    
        if let startDate = presenter?.getStartDate(chartFormat) {
            let calendar = Calendar.current
            let newDate = calendar.date(
                byAdding: chartFormat == .daily ? .day : chartFormat == .weekly ? .weekOfMonth : .month,
                value: -(diagramChart.countColumns - (chartData.data.keys.max() ?? 0) - 1),
                to: startDate
            )
            leftBottomDateLabel.text = stringForDate(newDate)
            middleBottomDateLabel.text = stringForDate(
                Date() - (Date().timeIntervalSince1970 - (newDate ?? Date()).timeIntervalSince1970) / 2.0
            )
        }
        rightBottomDateLabel.text = stringForDate(Date())
    }
    
    private func setupView() {
        diagramChart.columnColor = chartType.getColor()
        rightTopLabel.textColor = chartType.getColor()
        leftTopLabel.text = chartType.getTitle()
        leftTopLabel.textColor = chartType.getColor()
        rightBottomLabel.text = "Daily Average"
        
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        leftStack.addArrangedSubview(leftTopLabel)
        leftStack.addArrangedSubview(leftBottomLabel)
        rightStack.addArrangedSubview(rightTopLabel)
        rightStack.addArrangedSubview(rightBottomLabel)

        addSubviews([
            leftStack,
            rightStack,
            diagramChart,
            leftBottomDateLabel,
            middleBottomDateLabel,
            rightBottomDateLabel,
            messageLabel
        ])
    }
    
    private func setupConstraints() {
        leftStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(16)
        }
        
        rightStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        diagramChart.snp.makeConstraints { make in
            make.top.equalTo(leftStack.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-54)
            make.bottom.equalToSuperview().offset(-31)
        }
        
        leftBottomDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(diagramChart.snp.leading)
            make.top.equalTo(diagramChart.snp.bottom).offset(7)
        }
        
        middleBottomDateLabel.snp.makeConstraints { make in
            make.top.equalTo(diagramChart.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        rightBottomDateLabel.snp.makeConstraints { make in
            make.top.equalTo(diagramChart.snp.bottom).offset(7)
            make.trailing.equalTo(diagramChart.snp.trailing)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func stringForDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let dateNow = Date()
        let year = calendar.dateComponents([.year], from: dateNow).year
        let yearNow = calendar.dateComponents([.year], from: date).year
        
        var format: String
        
        switch chartFormat {
        case .daily:
            if year == yearNow {
                format = "MMM d"
            } else {
                format = "MMM d yyyy"
            }
        case .weekly:
            if year == yearNow {
                format = "MMM"
            } else {
                format = "MMM yyyy"
            }
        case .monthly:
            if year == yearNow {
                format = "MMM"
            } else {
                format = "MMM yyyy"
            }
        }
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}

extension DiagramChartView: WidgetChart {
    func setChartFormat(_ format: ChartFormat) {
        chartFormat = format
    }
}

extension DiagramChartView: DiagramChartViewInterface {
    func getChartType() -> DiagramChartType {
        self.chartType
    }
    
    func getCountHorizontalLines() -> Int {
        diagramChart.countHorizontalLines
    }
}
