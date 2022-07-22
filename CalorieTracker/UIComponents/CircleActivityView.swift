//
//  CircleActivityView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.07.2022.
//

import UIKit

protocol CircleActivityViewDataSource: AnyObject {
    func circleActivityView(_ view: CircleActivityView, strokeColor index: Int) -> UIColor
    func circleActivityView(_ view: CircleActivityView, percentageOfFilling index: Int) -> CGFloat
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleString index: Int) -> String?
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleImage index: Int) -> UIImage?
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleColor index: Int) -> UIColor?
    func numberOfActivityCircles(_ view: CircleActivityView) -> Int
}

extension CircleActivityViewDataSource {
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleString index: Int) -> String? { return nil }
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleImage index: Int) -> UIImage? { return nil }
    func circleActivityView(_ view: CircleActivityView, activityCircleTitleColor index: Int) -> UIColor? { return nil }
}

final class CircleActivityView: UIView {

    weak var dataSource: CircleActivityViewDataSource?
    
    var startRadius: CGFloat = 19
    var radiusStep: CGFloat = 14
    var lineWidth: CGFloat = 12
    var colorBackCircles: UIColor? = .gray
    var titleFont: UIFont?
    
    private var numberOfActivityCircles: Int?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        numberOfActivityCircles = dataSource?.numberOfActivityCircles(self)
        
        drawBackgroundRings()
        drawActivityRings()
        drawActivityRingTitles()
    }
    
    private func drawActivityRingTitles() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        let size = CGSize(width: lineWidth, height: lineWidth)
        
        for indexShape in 0..<numberOfActivityCircles {
            let origin = CGPoint(
                x: frame.width / 2.0,
                y: frame.height / 2.0 - startRadius - radiusStep * CGFloat(indexShape)
            )
            let rect = CGRect(
                origin: CGPoint(
                    x: origin.x - size.width / 2.0,
                    y: origin.y - size.height / 2.0
                ),
                size: size
            )
            
            layer.addSublayer(createCircleShape(
                center: origin,
                radius: lineWidth / 2.0,
                fillColor: dataSource?.circleActivityView(self, strokeColor: indexShape) ?? .white
            ))
            
            if let titleImage = dataSource?.circleActivityView(self, activityCircleTitleImage: indexShape) {
                let imageView: UIImageView = {
                    let view = UIImageView()
                    view.image = titleImage
                    view.contentMode = .center
                    view.frame = rect
                    return view
                }()

                addSubview(imageView)
            } else if let titleStr = dataSource?.circleActivityView(self, activityCircleTitleString: indexShape) {
                let label: UILabel = {
                    let label = UILabel()
                    label.text = titleStr
                    label.textColor = dataSource?.circleActivityView(self, activityCircleTitleColor: indexShape)
                    label.font = titleFont
                    label.textAlignment = .center
                    label.frame = rect
                    return label
                }()

                addSubview(label)
            }
        }
    }
    
    private func drawActivityRings() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        
        for indexShape in 0..<numberOfActivityCircles {
            layer.addSublayer(createRingShape(
                center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0),
                radius: startRadius + radiusStep * CGFloat(indexShape),
                start: 0,
                end: dataSource?.circleActivityView(self, percentageOfFilling: indexShape) ?? 0,
                color: dataSource?.circleActivityView(self, strokeColor: indexShape) ?? .white,
                lineWidth: lineWidth
            ))
        }
    }
    
    private func drawBackgroundRings() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        
        for indexShape in 0..<numberOfActivityCircles {
            layer.addSublayer(createRingShape(
                center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0),
                radius: startRadius + radiusStep * CGFloat(indexShape),
                start: 0,
                end: 1,
                color: colorBackCircles,
                lineWidth: lineWidth
            ))
        }
    }
    
    private func createRingShape(center: CGPoint,
                                 radius: CGFloat,
                                 start: CGFloat,
                                 end: CGFloat,
                                 color: UIColor?,
                                 lineWidth: CGFloat) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2.0 + start * 2 * CGFloat.pi,
            endAngle: -CGFloat.pi / 2.0 + end * 2 * CGFloat.pi,
            clockwise: true
        )
        
        let shapeLayer: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = circlePath.cgPath
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = color?.cgColor
            shape.lineWidth = lineWidth
            shape.lineCap = .round
            return shape
        }()
        
        return shapeLayer
    }
    
    private func createCircleShape(center: CGPoint,
                                   radius: CGFloat,
                                   fillColor: UIColor) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        let shapeLayer: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = circlePath.cgPath
            shape.fillColor = fillColor.cgColor
            return shape
        }()
        
        return shapeLayer
    }
}
