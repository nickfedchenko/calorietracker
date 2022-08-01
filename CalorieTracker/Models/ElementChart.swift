//
//  ElementChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 29.07.2022.
//

import UIKit

enum ElementChart {
    case oneTenths
    case twoTenths
    case threeTenths
    case fourTenths
    case fiveTenths
    case sixTenths
    case sevenTenths
    case eightTenths
    case nineTenths
    case tenTenths
    case start
    case end
    case leftMore
    case rightMore
    case spacer
    case spacerFlex
}

extension ElementChart {
    var image: UIImage? {
        switch self {
        case .oneTenths:
            return R.image.exercisesWidget.chart.oneTenth()
        case .twoTenths:
            return R.image.exercisesWidget.chart.twoTenths()
        case .threeTenths:
            return R.image.exercisesWidget.chart.threeTenths()
        case .fourTenths:
            return R.image.exercisesWidget.chart.fourTenths()
        case .fiveTenths:
            return R.image.exercisesWidget.chart.fiveTenths()
        case .sixTenths:
            return R.image.exercisesWidget.chart.sixTenths()
        case .sevenTenths:
            return R.image.exercisesWidget.chart.sevenTenths()
        case .eightTenths:
            return R.image.exercisesWidget.chart.eightTenths()
        case .nineTenths:
            return R.image.exercisesWidget.chart.nineTenths()
        case .tenTenths:
            return R.image.exercisesWidget.chart.tenTenths()
        case .start:
            return R.image.exercisesWidget.chart.start()
        case .end:
            return R.image.exercisesWidget.chart.end()
        case .leftMore:
            return R.image.exercisesWidget.chart.leftMore()
        case .rightMore:
            return R.image.exercisesWidget.chart.rightMore()
        case .spacer:
            return R.image.exercisesWidget.chart.spacer()
        case .spacerFlex:
            return R.image.exercisesWidget.chart.spacerFlex()
        }
    }
}
