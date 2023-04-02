//
//  LineChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.09.2022.
//

import UIKit

final class LineChart: UIView {
    private let lineSpasingSize = CGSize(width: 14, height: 7)
    
    var countColumns: Int = 8
    var countHorizontalLines: Int = 4
    var countVerticalLines: Int = 4
    var startValue: Int = 0
    var goalValue: CGFloat? {
        didSet {
            print(goalValue)
        }
    }
    var goalTitle: String?
    var startDate: Date?
    var titles: [Int] = [] {
        didSet {
            print("titles set")
        }
    }
    
    var backgroundLinesColor: UIColor? = R.color.diagramChart.backgroundLines()
    var goalLineColor: UIColor? = R.color.diagramChart.goal()
    var columnColor: UIColor? = R.color.diagramChart.column()
    
    var data: [Int: CGFloat]? {
        didSet {
            didChangeData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        didChangeData()
    }
    
    private func didChangeData() {
        guard let data = data, frame != .zero else { return }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        subviews.forEach { $0.removeFromSuperview() }
        let newSize = CGSize(
            width: bounds.width - lineSpasingSize.width * 2,
            height: bounds.height - lineSpasingSize.height * 2
        )
        drawHorizontalLines()
        drawVerticalLines()
        drawLineChart(
            data.map {
                CGPoint(
                    x: CGFloat(
                        countColumns - $0.key
                    ) * newSize.width / CGFloat(countColumns) + lineSpasingSize.width,
                    y: (1 - $0.value) * newSize.height + lineSpasingSize.height
                )
            }
        )
        
        if let goalValue = goalValue {
            let newHeight = bounds.height - lineSpasingSize.height * 2
            let pointY = newHeight - goalValue * newHeight + lineSpasingSize.height
            layer.addSublayer(getHorizontalBrokenLine(pointY: pointY))
            
            let labelSize = CGSize(width: 33, height: 16)
            let label: UILabel = {
                let label = UILabel()
                label.font = R.font.sfProDisplaySemibold(size: 13)
                label.textColor = R.color.diagramChart.goal()
                label.text = goalTitle
                label.sizeToFit()
                return label
            }()
            addSubview(label)
            label.frame.origin = CGPoint(
                x: bounds.width + 2,
                y: pointY - labelSize.height / 2.0
            )
        }
    }
    
    private func drawLineChart(_ points: [CGPoint]) {
        let path = UIBezierPath()
        points.sorted(by: { $0.x < $1.x }).enumerated().forEach {
            if $0.offset == 0 {
                path.move(to: $0.element)
            } else {
                path.addLine(to: $0.element)
            }
            drawCircle($0.element)
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1.5
        shape.strokeColor = columnColor?.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(shape)
    }
    
    private func drawCircle(_ point: CGPoint) {
        let path = UIBezierPath(
            arcCenter: point,
            radius: 1.5,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = columnColor?.cgColor
        
        layer.addSublayer(shape)
    }
    
    private func drawHorizontalLines() {
        let newHeight = bounds.height - lineSpasingSize.height * 2
        let spasing = newHeight / max(1, CGFloat(titles.count - 1))
        let labelSize = CGSize(width: 33, height: 16)
        
        for index in 0..<titles.count {
            let pointY = lineSpasingSize.height + newHeight - CGFloat(index) * spasing
            
            let label: UILabel = {
                let label = UILabel()
                label.font = R.font.sfProDisplaySemibold(size: 13)
                label.textColor = R.color.diagramChart.backgroundLines()
                label.text = "\(titles.reversed()[index]) kg"
                label.sizeToFit()
                return label
            }()
            addSubview(label)
            label.frame.origin = CGPoint(
                x: bounds.width + 2,
                y: pointY - labelSize.height / 2.0
            )
            
            layer.addSublayer(getLine(point: CGPoint(x: 0, y: pointY)))
        }
    }
    
    private func drawVerticalLines() {
        let newWidth = bounds.width - lineSpasingSize.width * 2
        let spasing = newWidth / CGFloat(countVerticalLines)
        let labelSize = CGSize(width: 33, height: 16)
        
        for index in 0...countVerticalLines {
            let pointX = lineSpasingSize.width + newWidth - CGFloat(index) * spasing
            
            let label: UILabel = {
                let label = UILabel()
                label.font = R.font.sfProDisplaySemibold(size: 13)
                label.textColor = R.color.diagramChart.backgroundLines()
                label.textAlignment = .center
                label.text = "\(index)"
                return label
            }()
            addSubview(label)
            label.frame = CGRect(
                origin: CGPoint(
                    x: pointX - labelSize.width / 2.0,
                    y: bounds.height
                ),
                size: labelSize
            )
            
            layer.addSublayer(getLine(point: CGPoint(x: pointX, y: 0)))
        }
    }
    
    private func getLine(point: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        if point.x == 0 {
            path.move(to: CGPoint(x: 0, y: point.y))
            path.addLine(to: CGPoint(x: bounds.width, y: point.y))
        } else {
            path.move(to: CGPoint(x: point.x, y: 0))
            path.addLine(to: CGPoint(x: point.x, y: bounds.height))
        }

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 1
        shape.strokeColor = backgroundLinesColor?.cgColor
        
        return shape
    }
    
    private func getHorizontalBrokenLine(pointY: CGFloat) -> CAShapeLayer {
        let spasing: CGFloat = 3
        let width: CGFloat = 3
        let path = UIBezierPath()
        
        var lineWidth: CGFloat = width
        path.move(to: CGPoint(x: 0, y: pointY))
        path.addLine(to: CGPoint(x: width, y: pointY))
        while lineWidth < bounds.width {
            lineWidth += spasing
            path.move(to: CGPoint(
                x: lineWidth,
                y: pointY
            ))
            lineWidth += width
            path.addLine(to: CGPoint(
                x: min(lineWidth, bounds.width),
                y: pointY
            ))
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 1
        shape.strokeColor = goalLineColor?.cgColor
        shape.shadowColor = UIColor.white.cgColor
        shape.shadowRadius = 1
        shape.shadowOffset = CGSize(width: 0, height: 0.2)
        
        return shape
    }
}
