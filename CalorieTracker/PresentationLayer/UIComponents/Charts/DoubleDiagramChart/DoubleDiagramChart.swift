//
//  DoubleDiagramChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

final class DoubleDiagramChart: UIView {
    var countColumns: Int = 7
    var countHorizontalLines: Int = 4
    var verticalStep: Int = 750
    var goalValue: CGFloat?
    var startDate: Date?
    var moreGoal: Bool = false
    
    var backgroundLinesColor: UIColor? = R.color.diagramChart.backgroundLines()
    var goalLineColor: UIColor? = R.color.diagramChart.goal()
    var columnColor: UIColor? = R.color.diagramChart.column()
    var defaultColumnColor: UIColor?
    
    var data: [Int: (CGFloat, CGFloat)]? {
        didSet {
            layoutColumn = getLayout()
            didChangeData()
        }
    }
    
    private var layoutColumn: (width: CGFloat, spasing: CGFloat)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layoutColumn = getLayout()
        didChangeData()
    }
    
    private func didChangeData() {
        guard let data = data, let layoutColumn = layoutColumn, frame != .zero else { return }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        subviews.forEach { $0.removeFromSuperview() }
        drawHorizontalLines()
        
        let spasing = layoutColumn.spasing + layoutColumn.width
        for index in 0..<countColumns {
            var columnBackground: CALayer?
            var columnForgraund: CALayer?
            if let value = data[index] {
                columnBackground = getColumnShape(
                    value: value.0,
                    pointX: bounds.width - layoutColumn.width / 2.0 - CGFloat(index) * spasing,
                    color: columnColor?.withAlphaComponent(0.5),
                    border: true
                )
                columnForgraund = getColumnShape(
                    value: value.1,
                    pointX: bounds.width - layoutColumn.width / 2.0 - CGFloat(index) * spasing,
                    color: columnColor,
                    border: false
                )
            }
            layer.addSublayer(columnBackground ?? CAShapeLayer())
            layer.addSublayer(columnForgraund ?? CAShapeLayer())
        }
        
        if let goalValue = goalValue {
            let pointY = bounds.height - goalValue * bounds.height
            layer.addSublayer(getHorizontalBrokenLine(pointY: pointY))
            
            let labelSize = CGSize(width: 33, height: 16)
            let label: UILabel = {
                let label = UILabel()
                label.font = R.font.sfProDisplaySemibold(size: 13)
                label.textColor = R.color.diagramChart.goal()
                label.text = "\(Int(goalValue * CGFloat(countHorizontalLines * verticalStep)))"
                return label
            }()
            addSubview(label)
            label.frame = CGRect(
                origin: CGPoint(
                    x: bounds.width + 2,
                    y: pointY - labelSize.height / 2.0
                ),
                size: labelSize
            )
        }
    }
    
    private func getColumnShape(value: CGFloat, pointX: CGFloat, color: UIColor?, border: Bool) -> CALayer {
        guard let layoutColumn = layoutColumn else { return CAShapeLayer() }

        let size = CGSize(
            width: border ? layoutColumn.width : layoutColumn.width - 2,
            height: bounds.height * value
        )
        let origin = CGPoint(
            x: pointX - layoutColumn.width / 2.0 + (border ? 0 : 1),
            y: bounds.height * (1 - value)
        )
        let rect = CGRect(origin: origin, size: size)
        let path = UIBezierPath(
            roundedRect: rect,
            cornerRadius: 2
        )
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = color?.cgColor
        shape.lineWidth = 2
        shape.strokeColor = border ? UIColor.white.cgColor : UIColor.clear.cgColor
        
        return shape
    }
    
    private func drawHorizontalLines() {
        let spasing = bounds.height / CGFloat(countHorizontalLines)
        let labelSize = CGSize(width: 33, height: 16)
        
        for index in 0...countHorizontalLines {
            let pointY = bounds.height - CGFloat(index) * spasing
            
            if index != 0 {
                let label: UILabel = {
                    let label = UILabel()
                    label.font = R.font.sfProDisplaySemibold(size: 13)
                    label.textColor = R.color.diagramChart.backgroundLines()
                    label.text = "\(index * verticalStep)"
                    return label
                }()
                addSubview(label)
                label.frame = CGRect(
                    origin: CGPoint(
                        x: bounds.width + 2,
                        y: pointY - labelSize.height / 2.0
                    ),
                    size: labelSize
                )
            }
        
            layer.addSublayer(getHorizontalLine(pointY: pointY))
        }
    }
    
    private func getHorizontalLine(pointY: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: pointY))
        path.addLine(to: CGPoint(x: bounds.width, y: pointY))
        
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
    
    private func getLayout() -> (width: CGFloat, spasing: CGFloat) {
        let countColumns: CGFloat = CGFloat(self.countColumns)
        let factor: CGFloat = 1.8
        let width = bounds.width / (countColumns * factor)
        let spasing = (bounds.width - (countColumns * width)) / (countColumns - 1)
        
        return (width: width, spasing: spasing)
    }
}
