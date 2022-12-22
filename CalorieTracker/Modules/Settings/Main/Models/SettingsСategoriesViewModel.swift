//
//  SettingsСategoriesViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import UIKit

struct SettingsСategoriesViewModel {
    private let settingsCategoryTypes: [SettingsCategoryType]
    var presenter: SettingsPresenterInterface?
    
    init(_ settingsCategoryTypes: [SettingsCategoryType], presenter: SettingsPresenterInterface? = nil) {
        self.settingsCategoryTypes = settingsCategoryTypes
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        settingsCategoryTypes.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = settingsCategoryTypes[safe: indexPath.row] else {
            return nil
        }
        switch type {
        case .profile:
            let cell: SettingsProfileCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getProfileCellViewModel()
            cell.type = type
            return cell
        case .chat, .goals, .rate, .help, .app, .reminders:
            let cell: SettingsCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.type = type
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        switch settingsCategoryTypes[safe: indexPath.row] {
        case .profile:
            height = width * 0.256
        case .chat, .goals, .rate, .help, .app, .reminders:
            height = width * 0.192
        default:
            return .zero
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getIndexType(_ type: SettingsCategoryType) -> Int? {
        settingsCategoryTypes.firstIndex(of: type)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> SettingsCategoryType? {
        settingsCategoryTypes[safe: indexPath.row]
    }
    
    private func getProfileCellViewModel() -> SettingsProfileCellViewModel {
        .init(
            title: "Profile",
            name: presenter?.getNameProfile() ?? "",
            description: presenter?.getDescriptionProfile(),
            titleColor: R.color.foodViewing.basicDark(),
            nameColor: R.color.foodViewing.basicPrimary(),
            descriptionColor: R.color.foodViewing.basicPrimary(),
            image: nil,
            imageBackgroundColor: R.color.foodViewing.basicPrimary()
        )
    }
    
    private func getCategoryCellViewModel(_ type: SettingsCategoryType) -> SettingsCategoryCellViewModel? {
        switch type {
        case .profile:
            return nil
        case .chat:
            return .init(
                title: "Live Chat Support",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.chat(),
                imageBackgroundColor: R.color.settings.chat(),
                remindersCount: 2
            )
        case .goals:
            return .init(
                title: "My Goals",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.goals(),
                imageBackgroundColor: R.color.settings.goals(),
                remindersCount: 0
            )
        case .app:
            return .init(
                title: "App Settings",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.app(),
                imageBackgroundColor: R.color.settings.app(),
                remindersCount: 0
            )
        case .reminders:
            return .init(
                title: "Reminders",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.reminders(),
                imageBackgroundColor: R.color.settings.reminders(),
                remindersCount: 0
            )
        case .rate:
            return .init(
                title: "Rate this App",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.rate(),
                imageBackgroundColor: R.color.settings.rate(),
                remindersCount: 0
            )
        case .help:
            return .init(
                title: "Help & FAQ",
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.help(),
                imageBackgroundColor: R.color.settings.help(),
                remindersCount: 0
            )
        }
    }
}
