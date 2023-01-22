//
//  FiltersButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import UIKit

final class FiltersButton: UIButton {
    let shapeLayer = CAShapeLayer()
    let badgeView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "DE422B")
        view.layer.cornerRadius = 4
        view.layer.cornerCurve = .circular
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addShapeLayer()
        addBadgeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadow()
    }
    
    private func addShapeLayer() {
        layer.insertSublayer(shapeLayer, at: 0)
        shapeLayer.zPosition = 0
        imageView?.layer.zPosition = 2
    }
    
    func hideBadge() {
        UIView.animate(withDuration: 0.3) {
            self.badgeView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { _ in
            self.badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    func showBadge() {
        UIView.animate(withDuration: 0.3) {
            self.badgeView.transform = .identity
        }
    }
    
    private func addBadgeView() {
        addSubview(badgeView)
        badgeView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        badgeView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func drawShadow() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.shadowColor = UIColor(hex: "06BBBB").cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowOpacity = 0.2
      
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor(hex: "123E5E").cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.25
    }
}
