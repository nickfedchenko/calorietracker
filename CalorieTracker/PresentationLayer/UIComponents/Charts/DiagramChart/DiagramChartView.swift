//
//  DiagramChartView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.08.2022.
//

import UIKit

protocol DiagramChartViewInterface: AnyObject {
    func getCountHorizontalLines() -> Int
}

final class DiagramChartView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        presenter = DiagramChartViewPresenter(view: self)
        setupView()
        setupData()
        
        goalValue = 2500
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        guard let chartData = presenter?.getData(chartFormat) else { return }
        self.data = chartData
        diagramChart.data = chartData.data
        diagramChart.verticalStep = chartData.step
        diagramChart.countColumns = max(
            (chartData.data.keys.max() ?? 0) + 1,
            chartFormat == .daily ? 7 : chartFormat == .weekly ? 8 : 6
        )
        
        switch chartFormat {
        case .daily:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0 ) + 1) Days"
        case .weekly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Weeks"
        case .monthly:
            leftBottomLabel.text = "Last \((chartData.data.keys.max() ?? 0) + 1) Months"
        }
        
        let maxValue = CGFloat(getCountHorizontalLines() * chartData.step)
        rightTopLabel.text = "\(Int(chartData.data.values.sum() / CGFloat(chartData.data.count) * maxValue)) Cal"
    
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
        leftTopLabel.text = "CALORIES"
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
            rightBottomDateLabel
        ])
        
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

extension DiagramChartView: DiagramChartViewInterface {
    func getCountHorizontalLines() -> Int {
        diagramChart.countHorizontalLines
    }
}
