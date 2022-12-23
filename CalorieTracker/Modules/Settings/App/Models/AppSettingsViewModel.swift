//
//  AppSettingsViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

struct AppSettingsViewModel {
    private let appCategoryType: [AppSettingsCategoryType]
    
    private var presenter: AppSettingsPresenterInterface?
    var needUpadate: (() -> Void)?
    
    init(
        types appCategoryType: [AppSettingsCategoryType],
        presenter: AppSettingsPresenterInterface? = nil
    ) {
        self.appCategoryType = appCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        appCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = getTypeCell(indexPath) else {
            return nil
        }
        
        switch type {
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.title = "APP SETTINGS"
            return cell
        case .account, .units, .sync, .database, .haptic, .meal, .about:
            let cell: SettingsCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat = width * 0.192
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> AppSettingsCategoryType? {
        appCategoryType[safe: indexPath.row]
    }
    
    func getIndexType(_ type: AppSettingsCategoryType) -> Int? {
        appCategoryType.firstIndex(of: type)
    }
    
    private func getCategoryCellViewModel(
        _ type: AppSettingsCategoryType
    ) -> SettingsCategoryCellViewModel? {
        switch type {
        case .title:
            return nil
        case .account:
            return .init(
                title: "Account",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.account(),
                imageBackgroundColor: R.color.settings.account(),
                remindersCount: 0
            )
        case .units:
            return .init(
                title: "Units of Measurement",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.units(),
                imageBackgroundColor: R.color.settings.units(),
                remindersCount: 0
            )
        case .sync:
            return .init(
                title: "Sync",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.sync(),
                imageBackgroundColor: R.color.settings.sync(),
                remindersCount: 0
            )
        case .database:
            return .init(
                title: "Database",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.database(),
                imageBackgroundColor: R.color.settings.database(),
                remindersCount: 0
            )
        case .haptic:
            return .init(
                title: "Haptic Feedback",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.haptic(),
                imageBackgroundColor: R.color.settings.haptic(),
                remindersCount: 0
            )
        case .meal:
            return .init(
                title: "Rename Meal Types",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.meal(),
                imageBackgroundColor: R.color.settings.meal(),
                remindersCount: 0
            )
        case .about:
            return .init(
                title: "About KCALC",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.about(),
                imageBackgroundColor: R.color.settings.about(),
                remindersCount: 0
            )
        }
    }
}
