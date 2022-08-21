//
//  WaterSliderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.08.2022.
//

import UIKit

final class WaterSliderView: UIView {
    private lazy var slider: SliderStepperView = {
        let view = SliderStepperView()
        view.sliderTrackColor = R.color.waterSlider.background()
        view.innerShadowColor = R.color.waterSlider.shadow()
        view.circleColor = R.color.waterSlider.shadow()
        view.sliderBackgroundColor = R.color.waterSlider.background()?.withAlphaComponent(0.1)
        view.sliderStep = 1 / CGFloat(countParts)
        return view
    }()
    
    private var circleLayers: [CAShapeLayer] = []
    private var textLabels: [UILabel] = []
    private var positionTextNode: Int = 0
    private var isFirstDraw = true
    
    var countParts: Int = 15
    var minMl: Int = 0
    var stepMl: Int = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        slider.didChangeStep = { oldStep, step in
            self.circleLayers[step].fillColor = R.color.waterSlider.shadow()?.cgColor
            self.circleLayers[oldStep].fillColor = R.color.waterSlider.circles()?.cgColor
            self.textLabels[oldStep].isHidden = true
            self.textLabels[step].isHidden = false
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        drawCircleses(count: countParts)
        setupWaterTextNodes(width: frame.width - 48)
        isFirstDraw = false
    }

    private func setupView() {
        addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupWaterTextNodes(width: CGFloat) {
        var textLabels: [UILabel] = []
        
        for index in 0...countParts {
            let label = UILabel()
            label.isHidden = index != 0
            label.textAlignment = .center
            label.attributedText = getAttributedString(
                string: index == 0 ? "\(minMl) ML" : "+\(minMl + index * stepMl) ML",
                color: index == 0 ? R.color.waterSlider.background() : R.color.waterSlider.shadow()
            )
            label.frame = CGRect(
                origin: CGPoint(
                    x: -26 + CGFloat(index) * width / CGFloat(countParts),
                    y: 0
                ),
                size: CGSize(width: 100, height: 20)
            )
            addSubview(label)
            textLabels.append(label)
        }
        
        self.textLabels = textLabels
    }
    
    private func drawCircleses(count: Int) {
        for i in 0...count {
            let radius = slider.frame.height / 2.0
            let startX = slider.frame.minX + radius
            let width = slider.frame.width - 2 * radius
            
            let shape = getCircle(
                point: CGPoint(
                    x: startX + CGFloat(i) * width / CGFloat(count),
                    y: slider.frame.minY - 9
                ),
                radius: 2,
                color: i == 0 ? R.color.waterSlider.shadow() : R.color.waterSlider.circles()
            )
            
            circleLayers.append(shape)
            layer.addSublayer(shape)
        }
    }
    
    private func getCircle(point: CGPoint, radius: CGFloat, color: UIColor?) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: point,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        let circlePath = CAShapeLayer()
        circlePath.path = path.cgPath
        circlePath.fillColor = color?.cgColor
        
        return circlePath
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
             let attributedString = NSMutableAttributedString(string: string)
             attributedString.addAttributes(
                 [
                     .foregroundColor: color ?? .black,
                     .font: UIFont.roundedFont(ofSize: 17, weight: .bold)
                 ],
                 range: NSRange(location: 0, length: string.count)
             )

             return attributedString
         }
}
