//
//  CalorieGoalSettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

struct CalorieGoalSettingsViewModel {
    private let calorieGoalCategoryType: [CalorieGoalSettingsCategoryType]
    
    private var presenter: CalorieGoalSettingsPresenterInterface?
    
    init(
        types calorieGoalCategoryType: [CalorieGoalSettingsCategoryType],
        presenter: CalorieGoalSettingsPresenterInterface? = nil
    ) {
        self.calorieGoalCategoryType = calorieGoalCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        calorieGoalCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = "CALORIE GOAL"
            return cell
        case .description:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = "Calorie Distribution"
            return cell
        case .breakfast, .goal, .lunch, .dinner, .snacks:
            let cell: SettingsGoalCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        var height: CGFloat
        switch getTypeCell(indexPath) {
        case .title:
            height = width * 0.107
        case .description:
            height = width * 0.075
        case .breakfast, .goal, .lunch, .dinner, .snacks:
            height = width * 0.192
        default:
            return .zero
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> CalorieGoalSettingsCategoryType? {
        calorieGoalCategoryType[safe: indexPath.row]
    }
    
    func getIndexType(_ type: CalorieGoalSettingsCategoryType) -> Int? {
        calorieGoalCategoryType.firstIndex(of: type)
    }
    
    private func getCategoryCellViewModel(
        _ type: CalorieGoalSettingsCategoryType
    ) -> SettingsGoalCellViewModel? {
        switch type {
        case .goal:
            return .init(
                title: "Goal",
                leftDescription: nil,
                rightDescription: presenter?.getGoalKcalStr()
            )
        case .breakfast:
            return .init(
                title: "Breakfast",
                leftDescription: presenter?.getBreakfastPercentStr(),
                rightDescription: presenter?.getBreakfastGoalKcalStr()
            )
        case .lunch:
            return .init(
                title: "Lunch",
                leftDescription: presenter?.getLunchPercentStr(),
                rightDescription: presenter?.getLunchGoalKcalStr()
            )
        case .dinner:
            return .init(
                title: "Dinner",
                leftDescription: presenter?.getDinnerPercentStr(),
                rightDescription: presenter?.getDinnerGoalKcalStr()
            )
        case .snacks:
            return .init(
                title: "Snacks",
                leftDescription: presenter?.getSnacksPercentStr(),
                rightDescription: presenter?.getSnacksGoalKcalStr()
            )
        default:
            return nil
        }
    }
}
