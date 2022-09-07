//
//  WeightLineChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.08.2022.
//

import UIKit

protocol WeightLineChartInterface: AnyObject {
    func getModel() -> WeightLineChart.Model?
    func getWeight() -> (min: Int, max: Int)?
}

final class WeightLineChart: UIView {
    struct Model {
        let data: [(date: Date, weight: CGFloat)]
        let dateStart: Date
        let goal: CGFloat?
        
    }
    
    var goalLineColor: UIColor? = R.color.weightWidget.weightTextColor()
    var chartLineColor: UIColor? = R.color.weightWidget.chart()
    var backgroundLinesColor: UIColor? = R.color.weightWidget.backgroundLines()
    var format: String = "dd.MM"
    var drawPoints: Bool = true
    var model: Model? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let toolTip = ToolTipView()
    
    private var presenter: WeightLineChartPresenterInterface?
    private var pointsChart: [CGPoint]?
    private var shape: CAShapeLayer?
    
    private var weight: (min: Int, max: Int)? {
        guard let model = model,
               var maxWeight = model.data.map({ $0.weight }).max(),
               var minWeight = model.data.map({ $0.weight }).min() else { return nil }
        
        if let goal = model.goal {
            maxWeight = max(goal, maxWeight)
            minWeight = min(goal, minWeight)
        }
        
        return weightConvert(min: minWeight, max: maxWeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.presenter = WeightLineChartPresenter(view: self)
        backgroundColor = .clear
        toolTip.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let points = presenter?.getPoints(),
               let weight = weight,
               let countTheNumberOfHorizontalLines = presenter?.countTheNumberOfHorizontalLines() else { return }
        let count = CGFloat(countTheNumberOfHorizontalLines.count)

        let chartRect = CGRect(x: rect.width / 14,
                               y: rect.height / (count * 2),
                               width: rect.width * 6 / 7,
                               height: rect.height * (count - 1) / count)
        
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        drawVerticalLinesChart(rect: rect, count: 7)
        drawHorizontalLinesChart(rect: rect, count: Int(count))
        drawLineChart(rect: chartRect, points: points)
        
        if let goal = model?.goal {
            let newGoal = (goal - CGFloat(weight.min)) / CGFloat(weight.max - weight.min)
            let goalRect = CGRect(
                x: 0,
                y: chartRect.origin.y,
                width: rect.width,
                height: chartRect.height
            )

            drawGoalLine(rect: goalRect, goal: newGoal)
        }
        
        pointsChart = points.map {
            CGPoint(
                x: $0.x * chartRect.width + chartRect.origin.x,
                y: (1 - $0.y) * chartRect.height + chartRect.origin.y
            )
        }
    }
    
    private func weightConvert(min: CGFloat, max: CGFloat) -> (min: Int, max: Int)? {
        let minWeightInt = Int(floor(min))
        let maxWeightInt = Int(ceil(max))
        
        switch maxWeightInt - minWeightInt {
        case 0...5:
            return (min: minWeightInt,
                     max: maxWeightInt)
        case 5...10:
            return (min: minWeightInt / 2 * 2,
                     max: Int(ceil(Double(maxWeightInt) / 2.0) * 2))
        case 10...40:
            return (min: minWeightInt / 5 * 5,
                     max: Int(ceil(Double(maxWeightInt) / 5.0) * 5))
        case 40...:
            return (min: minWeightInt / 10 * 10,
                     max: Int(ceil(Double(maxWeightInt) / 10.0) * 10))
        default:
            return nil
        }
    }
    
    private func titlesOfVerticalLines() -> [String]? {
        guard let dateStart = model?.dateStart else { return nil }
        let dateNow = Date()
        
        let slice = abs(dateStart.timeIntervalSinceNow) / 6
        var dates: [Date] = []
        
        for i in 0...6 {
            dates.append(dateNow - Double(i) * slice)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dates.map { dateFormatter.string(from: $0) }.reversed()
    }
    
    private func addTitleAxis(rect: CGRect, title: String?) {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = R.font.sfProDisplaySemibold(size: 12)
        addSubview(label)
        label.frame = rect
    }
    
    private func getShapeCircle(point: CGPoint, radius: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: point,
                                      radius: radius,
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = chartLineColor?.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = 7
        shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
        shapeLayer.shadowOpacity = 0.15
        
        return shapeLayer
    }
    
    // MARK: - Draw method
    
    private func drawLineChart(rect: CGRect, points: [CGPoint]) {
        guard let firstPoint = points.first else { return }
        var pointsChart = points
        pointsChart.removeFirst()
        
        let path = UIBezierPath()
        path.lineWidth = 2
        chartLineColor?.setStroke()
        
        let pointChart = CGPoint(
            x: firstPoint.x * rect.width + rect.origin.x,
            y: (1 - firstPoint.y) * rect.height + rect.origin.y
        )
        
        path.move(to: pointChart)
        if drawPoints { layer.addSublayer(getShapeCircle(point: pointChart, radius: 4)) }
        
        for point in pointsChart {
            let pointChart = CGPoint(
                x: point.x * rect.width + rect.origin.x,
                y: (1 - point.y) * rect.height + rect.origin.y
            )
            path.addLine(to: pointChart)
            if drawPoints { layer.addSublayer(getShapeCircle(point: pointChart, radius: 4)) }
            
        }
        path.stroke()
    }
    
    private func drawGoalLine(rect: CGRect, goal: CGFloat?) {
        guard let goal = goal else { return }
        
        drawLine(rect: rect,
                 point: CGPoint(x: 0, y: goal),
                 axis: .horizontal,
                 lineWidth: 2,
                 color: goalLineColor)
    }
    
    private func drawVerticalLinesChart(rect: CGRect, count: Int) {
        guard let titles = titlesOfVerticalLines() else { return }
        let spasing = 1 / CGFloat(count * 2)
        let size = CGSize(width: 40, height: 40)
        var titleOfAxisX = 0
        
        for pointX in 1...(count * 2) where pointX % 2 != 0 {
            drawLine(rect: rect,
                     point: CGPoint(x: spasing * CGFloat(pointX), y: 0),
                     axis: .vertical,
                     lineWidth: 1,
                     color: backgroundLinesColor)
            let origin = CGPoint(
                x: spasing * CGFloat(pointX) * rect.width - size.width / 2,
                y: rect.height
            )
            addTitleAxis(
                rect: CGRect(
                    origin: origin,
                    size: size
                ),
                title: titles[titleOfAxisX]
            )
            titleOfAxisX += 1
        }
    }
    
    private func drawHorizontalLinesChart(rect: CGRect, count: Int) {
        guard let titles = presenter?.countTheNumberOfHorizontalLines() else { return }
        
        let spasing = 1 / CGFloat(count * 2)
        let size = CGSize(width: 40, height: 15)
        var titleOfAxisY = 0
        
        for pointY in 0...(count * 2) where pointY % 2 != 0 {
            drawLine(rect: rect,
                     point: CGPoint(x: 0, y: spasing * CGFloat(pointY)),
                     axis: .horizontal,
                     lineWidth: 1,
                     color: backgroundLinesColor)
            
            let origin = CGPoint(
                x: -size.width,
                y: spasing * CGFloat(pointY) * rect.height - size.height / 2
            )
            addTitleAxis(
                rect: CGRect(
                    origin: origin,
                    size: size
                ),
                title: String(titles[titleOfAxisY])
            )
            titleOfAxisY += 1
        }
    }
    
    private func drawLine(rect: CGRect,
                          point: CGPoint,
                          axis: NSLayoutConstraint.Axis,
                          lineWidth: CGFloat,
                          color: UIColor?) {
        let linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        color?.setStroke()
        
        switch axis {
        case .horizontal:
            let pointY = (1 - point.y) * rect.height + rect.origin.y
            linePath.move(to: CGPoint(x: rect.origin.x, y: pointY))
            linePath.addLine(to: CGPoint(x: rect.width + rect.origin.x, y: pointY))
        case .vertical:
            let pointX = point.x * rect.width + rect.origin.x
            linePath.move(to: CGPoint(x: pointX, y: rect.origin.y))
            linePath.addLine(to: CGPoint(x: pointX, y: rect.height + rect.origin.y))
        default:
            break
        }
        
        linePath.stroke()
    }
}

// MARK: - Touches

extension WeightLineChart {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointsChart = pointsChart, let data = model?.data.sorted(by: { $0.date < $1.date }) else { return }
        let toolTipSize = CGSize(width: 70, height: 60)
        for touch in touches {
            let point = touch.location(in: self).closestPoint(to: pointsChart)
            let flag = point.element.y - toolTipSize.height <= 0
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            
            shape?.removeFromSuperlayer()
            shape = getShapeCircle(point: point.element, radius: 5)
            
            toolTip.text = (
                date: dateFormatter.string(from: data[point.index].date),
                weight: String(
                    format: "%.1f " + "kg",
                    data[point.index].weight
                ).replacingOccurrences(of: ".", with: ",")
            )
            toolTip.rotated = flag
            toolTip.frame = CGRect(
                origin: CGPoint(
                    x: point.element.x - toolTipSize.width / 2.0,
                    y: point.element.y - (flag ? 0 : toolTipSize.height)
                ),
                size: toolTipSize
            )
            
            layer.addSublayer(shape ?? CAShapeLayer())
            addSubview(toolTip)
        }
    }
}

// MARK: - Interface

extension WeightLineChart: WeightLineChartInterface {
    func getWeight() -> (min: Int, max: Int)? {
        return weight
    }
    
    func getModel() -> Model? {
        return model
    }
}
