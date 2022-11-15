//
//  LineChartView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.09.2022.
//

import UIKit

protocol LineChartViewInterface: AnyObject {
    func getCountHorizontalLines() -> Int
    func getChartType() -> LineChartView.LineChartType
}

final class LineChartView: UIView {
    enum LineChartType {
        case weight
        case bmi
        
        func getTitle() -> String {
            switch self {
            case .weight:
                return "WEIGHT"
            case .bmi:
                return "BODY MASS INDEX"
            }
        }
        
        func getColor() -> UIColor? {
            switch self {
            case .weight:
                return R.color.progressScreen.weight()
            case .bmi:
                return R.color.progressScreen.bmi()
            }
        }
        
        func getPostfix() -> String {
            switch self {
            case .weight:
                return " kg ("
            case .bmi:
                return " ("
            }
        }
    }
    
    private var presenter: LineChartViewPresenter?
    
    private let lineChart = LineChart()
    
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
    
    private var data: LineChartData?
    
    var backgroundLinesColor: UIColor? {
        get { lineChart.backgroundLinesColor }
        set { lineChart.backgroundLinesColor = newValue }
    }
    var goalLineColor: UIColor? {
        get { lineChart.goalLineColor }
        set { lineChart.goalLineColor = newValue }
    }
    var columnColor: UIColor? {
        get { lineChart.columnColor }
        set { lineChart.columnColor = newValue }
    }
    var titleChart: String? {
        get { leftTopLabel.text }
        set { leftTopLabel.text = newValue }
    }
    
    var chartFormat: ChartFormat = .weekly {
        didSet {
            setupData()
        }
    }
    
    let chartType: LineChartType
    
    init(_ type: LineChartType) {
        chartType = type
        super.init(frame: .zero)
        presenter = LineChartViewPresenter(view: self)
        setupView()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        guard let chartData = presenter?.getData(chartFormat) else {
            lineChart.isHidden = true
            rightBottomLabel.isHidden = true
            leftBottomLabel.layer.opacity = 0
            messageLabel.isHidden = false
            messageLabel.text = "There are no measurements. Your first \(chartFormat.rawValue) has not yet passed"
            return
        }
        lineChart.isHidden = false
        rightBottomLabel.isHidden = false
        leftBottomLabel.layer.opacity = 1
        messageLabel.isHidden = true
        self.data = chartData
        lineChart.goalTitle = chartData.goalTitle
        lineChart.goalValue = chartData.goal
        lineChart.titles = chartData.titles
        lineChart.countVerticalLines = chartData.data.map { $0.key }.max() ?? 4
        lineChart.countColumns = max((chartData.data.keys.max() ?? 0), 4)
        lineChart.countVerticalLines = chartFormat == .daily
        ? 5
        : chartFormat == .weekly
        ? max(4, chartData.data.keys.max() ?? 0)
        : max(4, chartData.data.keys.max() ?? 0)
        lineChart.data = chartData.data
        
        switch chartFormat {
        case .daily:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0 ) + 1) Days"
        case .weekly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Weeks"
        case .monthly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Months"
        }
        
        rightTopLabel.text = String(
            format: "%.1f",
            chartData.valueNow
        )
        setupRightBottomLabel(chartData.valueStart, chartData.valueNow)
    
    }
    
    private func setupView() {
        leftTopLabel.text = chartType.getTitle()
        leftTopLabel.textColor = chartType.getColor()
        rightTopLabel.textColor = chartType.getColor()
        
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
            lineChart,
            messageLabel
        ])
        
        leftStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(16)
        }
        
        rightStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        lineChart.snp.makeConstraints { make in
            make.top.equalTo(leftStack.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-54)
            make.bottom.equalToSuperview().offset(-31)
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
    
    private func setupRightBottomLabel(_ valueStart: CGFloat, _ valueNow: CGFloat) {
        let string = chartType == .weight ? "Starting Weight: " : "Starting: "
        let attributedString = NSMutableAttributedString(
            attributedString: getAttributedString(
                string: string + String(format: "%.1f", valueStart) + (chartType.getPostfix()),
                size: 13,
                color: R.color.diagramChart.bottomTitle()
            )
        )
        attributedString.append(getAttributedString(
            string: String(format: "%.1f", valueNow - valueStart),
            size: 13,
            color: chartType.getColor()
        ))
        attributedString.append(getAttributedString(
            string: ")",
            size: 13,
            color: R.color.diagramChart.bottomTitle()
        ))
        rightBottomLabel.attributedText = attributedString
    }
    
    private func getAttributedString(string: String, size: CGFloat, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProDisplaySemibold(size: size)!
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}

extension LineChartView: WidgetChart {
    func setChartFormat(_ format: ChartFormat) {
        chartFormat = format
    }
}

extension LineChartView: LineChartViewInterface {
    func getCountHorizontalLines() -> Int {
        lineChart.countHorizontalLines
    }
    
    func getChartType() -> LineChartType {
        return chartType
    }
}
