//
//  TripleDiagramChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.09.2022.
//

import UIKit

final class TripleDiagramChart: UIView {
    var countColumns: Int = 7
    var countHorizontalLines: Int = 4
    var verticalStep: Int = 750
    var startDate: Date?
    var moreGoal: Bool = false
    
    var backgroundLinesColor: UIColor? = R.color.diagramChart.backgroundLines()
    var goalLineColor: UIColor? = R.color.diagramChart.goal()
    var columnColors: (UIColor?, UIColor?, UIColor?)
    var defaultColumnColor: UIColor?
    
    var data: [Int: (CGFloat, CGFloat, CGFloat)]? {
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
        drawHorizontalLines()
        
        let spasing = layoutColumn.spasing + layoutColumn.width
        for index in 0..<countColumns {
            var column: UIView?
            if let value = data[index] {
                column = getColumnShape(
                    values: value,
                    pointX: bounds.width - layoutColumn.width / 2.0 - CGFloat(index) * spasing
                )
            }
            addSubview(column ?? UIView())
        }
    }
    
    private func getColumnShape(values: (CGFloat, CGFloat, CGFloat), pointX: CGFloat) -> UIView {
        guard let layoutColumn = layoutColumn else { return UIView() }
        let value = [values.0, values.1, values.2].sum()
        let size = CGSize(
            width: layoutColumn.width,
            height: bounds.height * value
        )
        let origin = CGPoint(
            x: pointX - layoutColumn.width / 2.0,
            y: bounds.height * (1 - value)
        )
        
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 1
        stack.backgroundColor = .white
        stack.layer.borderColor = UIColor.white.cgColor
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 2
        stack.clipsToBounds = true
        
        let firstView = UIView()
        let secondView = UIView()
        let thirdView = UIView()
        firstView.backgroundColor = columnColors.0
        secondView.backgroundColor = columnColors.1
        thirdView.backgroundColor = columnColors.2
        
        stack.addArrangedSubviews(firstView, secondView, thirdView)
        
        firstView.snp.makeConstraints { make in
            make.height.equalTo((size.height - 2) * values.0 / value)
        }
        secondView.snp.makeConstraints { make in
            make.height.equalTo((size.height - 2) * values.1 / value)
        }
        thirdView.snp.makeConstraints { make in
            make.height.equalTo((size.height - 2) * values.2 / value)
        }
        
        stack.frame = CGRect(origin: origin, size: size)
        
        return stack
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
