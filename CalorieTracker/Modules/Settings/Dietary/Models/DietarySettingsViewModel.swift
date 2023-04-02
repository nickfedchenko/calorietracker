//
//  DietarySettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

struct DietarySettingsViewModel {
    private let dietaryCategoryType: [DietarySettingsCategoryType]
    
    private var presenter: DietarySettingsPresenterInterface?
    var needUpadate: (() -> Void)?
    
    init(
        types dietaryCategoryType: [DietarySettingsCategoryType],
        presenter: DietarySettingsPresenterInterface? = nil
    ) {
        self.dietaryCategoryType = dietaryCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        dietaryCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = R.string.localizable.settingsDietaryTitle().uppercased()
            return cell
        default:
            let cell: SettingsCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            
            switch presenter?.getUserData()?.dietary {
            case .classic where type == .classic:
                cell.cellState = .isSelected
            case .pescatarian where type == .pescatarian:
                cell.cellState = .isSelected
            case .vegetarian where type == .vegetarian:
                cell.cellState = .isSelected
            case .vegan where type == .vegan:
                cell.cellState = .isSelected
            default:
                cell.cellState = .isNotSelected
            }
            
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat = width * 0.192
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> DietarySettingsCategoryType? {
        dietaryCategoryType[safe: indexPath.row]
    }
    
    private func getCategoryCellViewModel(
        _ type: DietarySettingsCategoryType
    ) -> SettingsCategoryCellViewModel? {
        switch type {
        case .classic:
            return .init(
                title: R.string.localizable.settingsDietaryClassicTitle(),
                description: R.string.localizable.settingsDietaryClassicDecription(),
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: R.color.foodViewing.basicDark(),
                image: R.image.settings.dietaryClassic(),
                imageBackgroundColor: R.color.settings.dietaryClassic(),
                remindersCount: 0
            )
        case .pescatarian:
            return .init(
                title: R.string.localizable.settingsDietaryPescatarianTitle(),
                description: R.string.localizable.settingsDietaryPescatarianDecription(),
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: R.color.foodViewing.basicDark(),
                image: R.image.settings.dietaryPescatarian(),
                imageBackgroundColor: R.color.settings.dietaryPescatarian(),
                remindersCount: 0
            )
        case .vegetarian:
            return .init(
                title: R.string.localizable.settingsDietaryVegetarianTitle(),
                description: R.string.localizable.settingsDietaryVegetarianDecription(),
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: R.color.foodViewing.basicDark(),
                image: R.image.settings.dietaryVegetarian(),
                imageBackgroundColor: R.color.settings.dietaryVegetarian(),
                remindersCount: 0
            )
        case .vegan:
            return .init(
                title: R.string.localizable.settingsDietaryVeganTitle(),
                description: R.string.localizable.settingsDietaryVeganDecription(),
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: R.color.foodViewing.basicDark(),
                image: R.image.settings.dietaryVegan(),
                imageBackgroundColor: R.color.settings.dietaryVegan(),
                remindersCount: 0
            )
        default:
            return nil
        }
    }
}
