//
//  GoalsSettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

struct GoalsSettingsViewModel {
    private let goalsCategoryType: [GoalsSettingsCategoryType]
    
    private var presenter: GoalsSettingsPresenterInterface?
    var needUpadate: (() -> Void)?
    
    init(
        types goalsCategoryType: [GoalsSettingsCategoryType],
        presenter: GoalsSettingsPresenterInterface? = nil
    ) {
        self.goalsCategoryType = goalsCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        goalsCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = "MY GOALS"
            return cell
        case .goal, .startWeight, .weight, .activityLevel, .weekly, .calorie, .nutrient:
            let cell: SettingsGoalCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat = width * 0.192
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> GoalsSettingsCategoryType? {
        goalsCategoryType[safe: indexPath.row]
    }
    
    func getIndexType(_ type: GoalsSettingsCategoryType) -> Int? {
        goalsCategoryType.firstIndex(of: type)
    }
    
    private func getCategoryCellViewModel(
        _ type: GoalsSettingsCategoryType
    ) -> SettingsGoalCellViewModel? {
        switch type {
        case .title:
            return nil
        case .goal:
            return .init(
                title: "Goal",
                leftDescription: nil,
                rightDescription: presenter?.getGoal()
            )
        case .startWeight:
            return .init(
                title: "Starting Weight",
                leftDescription: nil,
                rightDescription: presenter?.getStartWeight()
            )
        case .weight:
            return .init(
                title: "Goal Weight",
                leftDescription: nil,
                rightDescription: presenter?.getGoalWeight()
            )
        case .activityLevel:
            return .init(
                title: "Activity Level",
                leftDescription: nil,
                rightDescription: presenter?.getActivityLevel()
            )
        case .weekly:
            return .init(
                title: "Weekly Goal",
                leftDescription: nil,
                rightDescription: presenter?.getWeeklyGoal()
            )
        case .calorie:
            return .init(
                title: "Calorie Goal",
                leftDescription: nil,
                rightDescription: presenter?.getCalorieGoal()
            )
        case .nutrient:
            return .init(
                title: "Nutrient Goals",
                leftDescription: nil,
                rightDescription: presenter?.getNutrientGoal()
            )
        }
    }
}
