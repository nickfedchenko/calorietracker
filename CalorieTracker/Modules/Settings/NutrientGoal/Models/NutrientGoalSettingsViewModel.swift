//
//  NutrientGoalSettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

struct NutrientGoalSettingsViewModel {
    private let nutrientGoalCategoryType: [NutrientGoalSettingsCategoryType]
    
    private var presenter: NutrientGoalSettingsPresenterInterface?
    
    init(
        types nutrientGoalCategoryType: [NutrientGoalSettingsCategoryType],
        presenter: NutrientGoalSettingsPresenterInterface? = nil
    ) {
        self.nutrientGoalCategoryType = nutrientGoalCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        nutrientGoalCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = R.string.localizable.settingsNutrientGoalTitle()
            return cell
        case .nutritionTitle:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = presenter?.getNutritionGoalStr()
            let percent = (presenter?.getNutrientPercent().sum() ?? 0) * 100
            cell.setPercentLabel(value: percent)
            return cell
        case .nutrition:
            let cell: SettingsGoalCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getNutritionCellViewModel()
            return cell
        case .carbs, .protein, .fat:
            let cell: SettingsNutrientGoalCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.didChangePercent = { value in
                guard let type = cell.viewModel?.nutrientType else { return }
                self.presenter?.setPersent(value, type: type)
            }
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        var height: CGFloat
        var newWidth: CGFloat
        
        switch getTypeCell(indexPath) {
        case .protein, .carbs, .fat:
            newWidth = width - 64
            height = newWidth * 0.134
        case .title:
            newWidth = width - 40
            height = width * 0.107
        case .nutritionTitle:
            newWidth = width - 40
            height = width * 0.072
        case .nutrition:
            newWidth = width - 40
            height = width * 0.192
        default:
            return .zero
        }
        
        return CGSize(width: newWidth, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> NutrientGoalSettingsCategoryType? {
        nutrientGoalCategoryType[safe: indexPath.row]
    }
    
    func getIndexType(_ type: NutrientGoalSettingsCategoryType) -> Int? {
        nutrientGoalCategoryType.firstIndex(of: type)
    }
    
    private func getNutritionCellViewModel() -> SettingsGoalCellViewModel {
        .init(
            title: R.string.localizable.nutrition().uppercased(),
            leftDescription: nil,
            rightDescription: presenter?.getNutritionGoalStr()
        )
    }
    
    private func getCategoryCellViewModel(
        _ type: NutrientGoalSettingsCategoryType
    ) -> SettingsNutrientGoalCellViewModel? {
        let kcalPerPercentage = presenter?.getKcalPerPercentage() ?? 0
        let nutrientPercent = presenter?.getNutrientPercent()
        switch type {
        case .fat:
            return .init(
                percent: Int((nutrientPercent?.fat ?? 0) * 100),
                kcalPerPercentage: kcalPerPercentage,
                nutrientType: .fat
            )
        case .protein:
            return .init(
                percent: Int((nutrientPercent?.protein ?? 0) * 100),
                kcalPerPercentage: kcalPerPercentage,
                nutrientType: .protein
            )
        case .carbs:
            return .init(
                percent: Int((nutrientPercent?.carbs ?? 0) * 100),
                kcalPerPercentage: kcalPerPercentage,
                nutrientType: .carbs
            )
        default:
            return nil
        }
    }
}
