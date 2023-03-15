//
//  TripleDiagramChartView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

protocol TripleDiagramChartViewInterface: AnyObject {
    func getCountHorizontalLines() -> Int
    func getChartType() -> TripleDiagramChartView.TripleDiagramChartType
}

final class TripleDiagramChartView: UIView {
    enum TripleDiagramChartType {
        case dietary
        
        func getTitle() -> String {
            switch self {
            case .dietary:
                return R.string.localizable.tripleDiagramChartTypeDietaryTitle()
            }
        }
        
        func getTitles() -> (String, String, String) {
            switch self {
            case .dietary:
                return (
                    "carbs.short".localized + ": ",
                    "protein.short".localized + ": ",
                    "fat.short".localized + ": "
                )
            }
        }
        
        func getPostfix() -> String {
            switch self {
            case .dietary:
                return "kcal.short".localized
            }
        }
        
        func getColor() -> UIColor? {
            switch self {
            case .dietary:
                return R.color.progressScreen.dietary()
            }
        }
        
        func getColors() -> (UIColor?, UIColor?, UIColor?) {
            switch self {
            case .dietary:
                return (
                    R.color.progressScreen.carb(),
                    R.color.progressScreen.protein(),
                    R.color.progressScreen.fatText()
                )
            }
        }
    }
    
    private var presenter: TripleDiagramChartViewPresenterInterface?
    
    private let diagramChart = TripleDiagramChart()
    
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
        label.font = R.font.sfProDisplaySemibold(size: 13)
        return label
    }()
    
    private lazy var rightMiddleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.sfProDisplaySemibold(size: 13)
        return label
    }()
    
    private lazy var rightBottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.sfProDisplaySemibold(size: 13)
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
    
    var chartFormat: ChartFormat = .weekly {
        didSet {
            setupData()
        }
    }
    
    var data: TripleDiagramChartData?
    let chartType: TripleDiagramChartType
    
    init(_ type: TripleDiagramChartType) {
        self.chartType = type
        super.init(frame: .zero)
        presenter = TripleDiagramChartViewPresenter(view: self)
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
            leftBottomDateLabel.isHidden = true
            rightBottomDateLabel.isHidden = true
            middleBottomDateLabel.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = {
                var textPart = R.string.localizable.nomeasurementsFirst()
                +  "\(chartFormat.title)"
                + R.string.localizable.nomeasurementsSecond()
                if Locale.current.languageCode == "ru" && chartFormat == .weekly {
                    textPart = "Нет измерений. Ваша первая неделя еще не прошла"
                }
                return textPart
            }()
            return
        }
        leftBottomLabel.layer.opacity = 1
        leftBottomDateLabel.isHidden = false
        rightBottomDateLabel.isHidden = false
        middleBottomDateLabel.isHidden = false
        messageLabel.isHidden = true
        diagramChart.isHidden = false
        
        self.data = chartData
        diagramChart.defaultColumnColor = chartType.getColor()?.withAlphaComponent(0.5)
        diagramChart.verticalStep = chartData.step
        diagramChart.moreGoal = true
        diagramChart.countColumns = max(
            (chartData.data.keys.max() ?? 0) + 1,
            chartFormat == .daily ? 7 : chartFormat == .weekly ? 8 : 6
        )
        diagramChart.data = chartData.data
        
        configureLabels(chartData: chartData)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLabels(chartData: TripleDiagramChartData) {
        switch chartFormat {
        case .daily:
            leftBottomLabel.text = "\("last.plural".localized) \((chartData.data.keys.max() ?? 0 ) + 1)"
            + " \("dney".localized),"
            + "\(R.string.localizable.chartRightBottomTitle())"
        case .weekly:
            leftBottomLabel.text = "\("last.plural".localized) \((chartData.data.keys.max() ?? 0 ) + 1)"
            + " \("nedelb".localized),"
            + "\(R.string.localizable.chartRightBottomTitle())"
        case .monthly:
            leftBottomLabel.text = "\("last.plural".localized) \((chartData.data.keys.max() ?? 0 ) + 1)"
            + " \("mesyacev".localized),"
            + "\(R.string.localizable.chartRightBottomTitle())"
        }
        
        let count = CGFloat(chartData.data.count)
        var values: (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
        chartData.data.values.forEach {
            values.0 += $0.0
            values.1 += $0.1
            values.2 += $0.2
        }
        let sumValues = values.0 + values.1 + values.2

        let maxValue = CGFloat(getCountHorizontalLines() * chartData.step)
        let attributingStringFirst = NSMutableAttributedString(attributedString: getAttributedString(
            string: chartType.getTitles().0,
            color: R.color.diagramChart.bottomTitle()
        ))
        let first = Int(values.0 / sumValues * 100)
        attributingStringFirst.append(getAttributedString(
            string: "\(Int(values.0 / count * maxValue)) \(chartType.getPostfix()) (\(first)%)",
            color: chartType.getColors().0
        ))
        let attributingStringSecond = NSMutableAttributedString(attributedString: getAttributedString(
            string: chartType.getTitles().1,
            color: R.color.diagramChart.bottomTitle()
        ))
        let second = Int(values.1 / sumValues * 100)
        attributingStringSecond.append(getAttributedString(
            string: "\(Int(values.1 / count * maxValue)) \(chartType.getPostfix()) (\(second)%)",
            color: chartType.getColors().1
        ))
        let attributingStringThird = NSMutableAttributedString(attributedString: getAttributedString(
            string: chartType.getTitles().2,
            color: R.color.diagramChart.bottomTitle()
        ))
        let third = Int(values.2 / sumValues * 100)
        attributingStringThird.append(getAttributedString(
            string: "\(Int(values.2 / count * maxValue)) \(chartType.getPostfix()) (\(third)%)",
            color: chartType.getColors().2
        ))
        rightTopLabel.attributedText = attributingStringFirst
        rightMiddleLabel.attributedText = attributingStringSecond
        rightBottomLabel.attributedText = attributingStringThird
    
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
        diagramChart.columnColors = chartType.getColors()
        rightTopLabel.textColor = chartType.getColor()
        leftTopLabel.text = chartType.getTitle()
        if Locale.current.languageCode != "en" {
            leftTopLabel.font = R.font.sfProDisplaySemibold(size: 16.fitW)
        }
        leftTopLabel.textColor = chartType.getColor()
        
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        leftStack.addArrangedSubview(leftTopLabel)
        leftStack.addArrangedSubview(leftBottomLabel)
        rightStack.addArrangedSubview(rightTopLabel)
        rightStack.addArrangedSubview(rightMiddleLabel)
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
            make.top.equalToSuperview().offset(8)
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
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProDisplaySemibold(size: 13)!
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}

extension TripleDiagramChartView: WidgetChart {
    func setChartFormat(_ format: ChartFormat) {
        chartFormat = format
    }
}

extension TripleDiagramChartView: TripleDiagramChartViewInterface {
    func getChartType() -> TripleDiagramChartType {
        self.chartType
    }
    
    func getCountHorizontalLines() -> Int {
        diagramChart.countHorizontalLines
    }
}
