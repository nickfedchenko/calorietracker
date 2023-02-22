//
//  MicrophoneButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.02.2023.
//

import UIKit

final class MicrophoneButton: UIControl {
    enum MicrophoneButtonState {
        case selected, unselected
    }
    
    private var selectedColor: CGColor = UIColor(hex: "0C695E").cgColor
    private var unselectedColor: CGColor = UIColor(hex: "B3EFDE").cgColor
    private var selectedTintColor: UIColor = UIColor(hex: "E2FBF4")
    private var unselectedTintColor: UIColor = UIColor(hex: "0C695E")
    
    private var buttonState: MicrophoneButtonState = .unselected
    
    let dropShadowLayerFirst = CAShapeLayer()
    let dropShadowLayerSecond = CAShapeLayer()
    let backgroundShape = CAShapeLayer()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.addFood.menu.micro()
        view.tintColor = unselectedTintColor
        view.contentMode = .center
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelectedState()
            } else {
                setUnselectedState()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(backgroundShape, at: 0)
        layer.insertSublayer(dropShadowLayerFirst, at: 0)
        layer.insertSublayer(dropShadowLayerSecond, at: 0)
        setupSubviews()
        clipsToBounds = false
        backgroundShape.fillColor = unselectedColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadows()
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSelectedState() {
        let animator = CABasicAnimation(keyPath: "fillColor")
        animator.fromValue = unselectedColor
        animator.toValue = selectedColor
        animator.duration = 0.3
//        animator.isAdditive = true
        animator.isRemovedOnCompletion = false
        animator.fillMode = .forwards
        backgroundShape.add(animator, forKey: nil)
//        backgroundShape.fillColor = selectedColor
        UIView.animate(withDuration: 0.3) {
            self.imageView.tintColor = self.selectedTintColor
        }
    }
    
    private func setUnselectedState() {
        let animator = CABasicAnimation(keyPath: "fillColor")
        animator.fromValue = selectedColor
        animator.toValue = unselectedColor
        animator.duration = 0.3
        animator.isRemovedOnCompletion = false
        animator.fillMode = .forwards
//        animator.isAdditive = true
        backgroundShape.add(animator, forKey: nil)
//        backgroundShape.fillColor = unselectedColor
        UIView.animate(withDuration: 0.3) {
            self.imageView.tintColor = self.unselectedTintColor
        }
    }
    
    private func drawShadows() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        dropShadowLayerFirst.frame = bounds
        dropShadowLayerFirst.path = path
        dropShadowLayerFirst.shadowPath = path
        dropShadowLayerFirst.shadowColor = UIColor(hex: "06BBBB").cgColor
        dropShadowLayerFirst.shadowOpacity = 0.2
        dropShadowLayerFirst.shadowOffset = CGSize(width: 0, height: 4)
        dropShadowLayerFirst.shadowRadius = 10
        
        dropShadowLayerSecond.frame = bounds
        dropShadowLayerSecond.shadowPath = path
        dropShadowLayerSecond.shadowColor = UIColor(hex: "123E5E").cgColor
        dropShadowLayerSecond.shadowOpacity = 0.25
        dropShadowLayerSecond.shadowOffset = CGSize(width: 0, height: 0.5)
        dropShadowLayerSecond.shadowRadius = 2
        dropShadowLayerSecond.path = path
        
        backgroundShape.path = path
        backgroundShape.cornerCurve = .continuous
        backgroundShape.strokeColor = UIColor(hex: "1BA17C").cgColor
        backgroundShape.lineWidth = 1
    }
}
