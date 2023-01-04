//
//  UnitsSettingsPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

protocol UnitsSettingsPresenterInterface: AnyObject {
    func didTapBackButton()
    func getWeightUnits() -> Units
    func getLenghtUnits() -> Units
    func getEnergyUnits() -> Units
    func getLiquidUnits() -> Units
    func getServingUnits() -> Units
    func setUnits(_ type: UnitsSettingsCategoryType, units: Units)
}

class UnitsSettingsPresenter {
    
    unowned var view: UnitsSettingsViewControllerInterface
    let router: UnitsSettingsRouterInterface?
    
    init(
        router: UnitsSettingsRouterInterface,
        view: UnitsSettingsViewControllerInterface
    ) {
        self.view = view
        self.router = router
    }
}

extension UnitsSettingsPresenter: UnitsSettingsPresenterInterface {
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func getEnergyUnits() -> Units {
        UDM.energyIsMetric ? .metric : .imperial
    }
    
    func getLenghtUnits() -> Units {
        UDM.lengthIsMetric ? .metric : .imperial
    }
    
    func getLiquidUnits() -> Units {
        UDM.liquidCapacityIsMetric ? .metric : .imperial
    }
    
    func getWeightUnits() -> Units {
        UDM.weightIsMetric ? .metric : .imperial
    }
    
    func getServingUnits() -> Units {
        UDM.servingIsMetric ? .metric : .imperial
    }
    
    func setUnits(_ type: UnitsSettingsCategoryType, units: Units) {
        switch type {
        case .title:
            return
        case .weight:
            UDM.weightIsMetric = units == .metric
        case .lenght:
            UDM.lengthIsMetric = units == .metric
        case .energy:
            UDM.energyIsMetric = units == .metric
        case .liquid:
            UDM.liquidCapacityIsMetric = units == .metric
        case .serving:
            UDM.servingIsMetric = units == .metric
        }
    }
}
