//
//  WeightLineChartPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.08.2022.
//

import UIKit

protocol WeightLineChartPresenterInterface: AnyObject {
    func getPoints() -> [CGPoint]
    func countTheNumberOfHorizontalLines() -> [Int]
}

class WeightLineChartPresenter {
    unowned var view: WeightLineChartInterface
    
    init(view: WeightLineChartInterface) {
        self.view = view
    }
}

extension WeightLineChartPresenter: WeightLineChartPresenterInterface {
    func getPoints() -> [CGPoint] {
        guard let model = view.getModel() else { return [] }
        
        let sortedData = model.data.sorted(by: { $0.date < $1.date })
        
        guard let weightInt = view.getWeight() else { return [] }
        
        let dateStart = model.dateStart.timeIntervalSinceReferenceDate
        let dateEnd = Date().timeIntervalSinceReferenceDate
        let dateDifferent = CGFloat(dateEnd - dateStart)
        let weightDifferent = CGFloat(weightInt.max - weightInt.min)
        
        let points = sortedData.map {
            return CGPoint(
                x: CGFloat($0.date.timeIntervalSinceReferenceDate - dateStart) / dateDifferent,
                y: ($0.weight - CGFloat(weightInt.min)) / weightDifferent
            )
        }
        
        return points
    }
    
    func countTheNumberOfHorizontalLines() -> [Int] {
        guard let weight = view.getWeight() else { return [] }
        switch weight.max - weight.min {
        case 0...5:
            return Array(weight.min...weight.max).reversed()
        case 5...10:
            return Array(weight.min...weight.max).filter { $0 % 2 == 0 }.reversed()
        case 10...40:
            return Array(weight.min...weight.max).filter { $0 % 5 == 0 }.reversed()
        case 40...:
            return Array(weight.min...weight.max).filter { $0 % 10 == 0 }.reversed()
        default:
            return []
        }
    }
}
