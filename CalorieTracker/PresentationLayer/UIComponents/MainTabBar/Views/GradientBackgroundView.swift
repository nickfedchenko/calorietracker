//
//  GradientView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 02.08.2022.
//

import UIKit

final class GradientBackgroundView: UIView {
    enum Direction {
        case left, right
    }

    private let direction: Direction
    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        drawGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGradient() {
        direction == .left
            ? drawLeftSidedGradient()
            : drawRightSidedGradient()
    }
    
    private func drawLeftSidedGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
            R.color.tabBarBackground() ?? UIColor.white,
            R.color.tabBarBackground()?.withAlphaComponent(0) ?? UIColor.white]
            .compactMap { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.9, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
    }
    
    private func drawRightSidedGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
            R.color.tabBarBackground()?.withAlphaComponent(0) ?? UIColor.white,
            R.color.tabBarBackground() ?? UIColor.white]
            .compactMap { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.1, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
    }
    
    class override var layerClass: AnyClass {
        CAGradientLayer.self
    }
}
