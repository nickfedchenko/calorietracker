//
//  GradientLayer.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.11.2022.
//

import UIKit

final class GradientLayer: CAGradientLayer {
    // swiftlint:disable: nesting
    struct Gradient {
        let bounds: CGRect
        let colors: [UIColor?]
        let axis: Axis
        let locations: [NSNumber]
    }
    
    enum Axis {
        case horizontal(DirectionHorizontal)
        case vertical(DirectionVertical)
        
        enum DirectionHorizontal {
            case left, right
        }
        
        enum DirectionVertical {
            case top, bottom
        }
        
        func getPoints() -> (start: CGPoint, end: CGPoint) {
            switch self {
            case .horizontal(let direction):
                switch direction {
                case .right:
                    return (
                        CGPoint(x: 1, y: 0),
                        CGPoint(x: 0, y: 0)
                    )
                case .left:
                    return (
                        CGPoint(x: 0, y: 0),
                        CGPoint(x: 1, y: 0)
                    )
                }
            case .vertical(let direction):
                switch direction {
                case .bottom:
                    return (
                        CGPoint(x: 0, y: 1),
                        CGPoint(x: 0, y: 0)
                    )
                case .top:
                    return (
                        CGPoint(x: 0, y: 0),
                        CGPoint(x: 0, y: 1)
                    )
                }
            }
        }
    }
    
    init(_ gradient: Gradient) {
        super.init()
        drawGradient(gradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGradient(_ model: Gradient) {
        self.colors = model.colors.compactMap { $0?.cgColor }
        self.locations = model.locations
        self.frame = model.bounds
        self.startPoint = model.axis.getPoints().start
        self.endPoint = model.axis.getPoints().end
    }
}
