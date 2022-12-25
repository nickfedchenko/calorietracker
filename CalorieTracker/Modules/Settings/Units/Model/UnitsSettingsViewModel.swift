//
//  UnitsSettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

struct UnitsSettingsViewModel {
    private let unitsCategoryType: [UnitsSettingsCategoryType]
    
    private var presenter: UnitsSettingsPresenterInterface?
    var needUpadate: (() -> Void)?
    
    init(
        types unitsCategoryType: [UnitsSettingsCategoryType],
        presenter: UnitsSettingsPresenterInterface? = nil
    ) {
        self.unitsCategoryType = unitsCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        unitsCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = R.string.localizable.settingsApp()
            return cell
        case .weight, .energy, .liquid, .serving, .lenght:
            let cell: SettingsUnitsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.didChangeUnits = { units in
                presenter?.setUnits(type, units: units)
            }
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat = width * 0.128
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> UnitsSettingsCategoryType? {
        unitsCategoryType[safe: indexPath.row]
    }
    
    func getIndexType(_ type: UnitsSettingsCategoryType) -> Int? {
        unitsCategoryType.firstIndex(of: type)
    }
    
    private func getCategoryCellViewModel(
        _ type: UnitsSettingsCategoryType
    ) -> SettingsUnitsCellViewModel? {
        switch type {
        case .title:
            return nil
        case .lenght:
            return .init(
                metricTitle: BAMeasurement.measurmentSuffix(.lenght, isMetric: true),
                imperialTitle: BAMeasurement.measurmentSuffix(.lenght, isMetric: false),
                title: R.string.localizable.length(),
                unit: presenter?.getLenghtUnits() ?? .metric
            )
        case .energy:
            return .init(
                metricTitle: BAMeasurement.measurmentSuffix(.energy, isMetric: true),
                imperialTitle: BAMeasurement.measurmentSuffix(.energy, isMetric: false),
                title: R.string.localizable.energy(),
                unit: presenter?.getEnergyUnits() ?? .metric
            )
        case .liquid:
            return .init(
                metricTitle: BAMeasurement.measurmentSuffix(.liquid, isMetric: true),
                imperialTitle: BAMeasurement.measurmentSuffix(.liquid, isMetric: false),
                title: R.string.localizable.liquid(),
                unit: presenter?.getLiquidUnits() ?? .metric
            )
        case .serving:
            return .init(
                metricTitle: BAMeasurement.measurmentSuffix(.serving, isMetric: true),
                imperialTitle: BAMeasurement.measurmentSuffix(.serving, isMetric: false),
                title: R.string.localizable.serving(),
                unit: presenter?.getServingUnits() ?? .metric
            )
        case .weight:
            return .init(
                metricTitle: BAMeasurement.measurmentSuffix(.weight, isMetric: true),
                imperialTitle: BAMeasurement.measurmentSuffix(.weight, isMetric: false),
                title: R.string.localizable.weight(),
                unit: presenter?.getWeightUnits() ?? .metric
            )
        }
    }
}
