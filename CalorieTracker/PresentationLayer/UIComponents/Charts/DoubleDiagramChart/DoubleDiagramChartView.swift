//
//  DoubleDiagramChartView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

protocol DoubleDiagramChartViewInterface: AnyObject {
    func getCountHorizontalLines() -> Int
    func getChartType() -> DoubleDiagramChartView.DoubleDiagramChartType
}

final class DoubleDiagramChartView: UIView {
    enum DoubleDiagramChartType {
        case exercises
        
        func getTitle() -> String {
            switch self {
            case .exercises:
                return "EXERSISE ENERGY"
            }
        }
        
        func getPostfix() -> String {
            switch self {
            case .exercises:
                return "Kcal"
            }
        }
        
        func getColor() -> UIColor? {
            switch self {
            case .exercises:
                return R.color.progressScreen.exercises()
            }
        }
    }
    
    private var presenter: DoubleDiagramChartViewPresenterInterface?
    
    private let diagramChart = DoubleDiagramChart()
    
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
    
    var data: DoubleDiagramChartData?
    let chartType: DoubleDiagramChartType
    
    init(_ type: DoubleDiagramChartType) {
        self.chartType = type
        super.init(frame: .zero)
        presenter = DoubleDiagramChartViewPresenter(view: self)
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
            rightBottomLabel.isHidden = true
            leftBottomDateLabel.isHidden = true
            rightBottomDateLabel.isHidden = true
            middleBottomDateLabel.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "There are no measurements. Your first \(chartFormat.rawValue) has not yet passed"
            return
        }
        diagramChart.isHidden = false
        leftBottomLabel.layer.opacity = 1
        rightBottomLabel.isHidden = false
        leftBottomDateLabel.isHidden = false
        rightBottomDateLabel.isHidden = false
        middleBottomDateLabel.isHidden = false
        messageLabel.isHidden = true
        
        self.data = chartData
        diagramChart.defaultColumnColor = chartType.getColor()?.withAlphaComponent(0.5)
        diagramChart.verticalStep = chartData.step
        diagramChart.moreGoal = true
        goalValue = chartData.goal
        diagramChart.countColumns = max(
            (chartData.data.keys.max() ?? 0) + 1,
            chartFormat == .daily ? 7 : chartFormat == .weekly ? 8 : 6
        )
        diagramChart.data = chartData.data
        
        configureLabels(chartData: chartData)
    }
    
    private func configureLabels(chartData: DoubleDiagramChartData) {
        switch chartFormat {
        case .daily:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0 ) + 1) Days"
        case .weekly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Weeks"
        case .monthly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Months"
        }
        
        let maxValue = CGFloat(getCountHorizontalLines() * chartData.step)
        let text = "\(Int(chartData.data.values.map { $0.0 }.sum() / CGFloat(chartData.data.count) * maxValue)) "
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

extension DoubleDiagramChartView: WidgetChart {
    func setChartFormat(_ format: ChartFormat) {
        chartFormat = format
    }
}

extension DoubleDiagramChartView: DoubleDiagramChartViewInterface {
    func getChartType() -> DoubleDiagramChartType {
        self.chartType
    }
    
    func getCountHorizontalLines() -> Int {
        diagramChart.countHorizontalLines
    }
}