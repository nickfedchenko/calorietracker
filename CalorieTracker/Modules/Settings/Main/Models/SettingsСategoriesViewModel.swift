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
        default:
            let cell: SettingsCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.type = type
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: 72)
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
    
    // swiftlint:disable:next function_body_length
    private func getCategoryCellViewModel(_ type: SettingsCategoryType) -> SettingsCategoryCellViewModel? {
        switch type {
        case .profile:
            return .init(
                title: R.string.localizable.settingsProfileTitle(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.profileIcon(),
                imageBackgroundColor: UIColor(hex: "1EA162"),
                remindersCount: 2
            )
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
                title: R.string.localizable.settingsMyGoalsTitle(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.goals(),
                imageBackgroundColor: R.color.settings.goals(),
                remindersCount: 0
            )
        case .app:
            return .init(
                title: R.string.localizable.settingsApp(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.app(),
                imageBackgroundColor: R.color.settings.app(),
                remindersCount: 0
            )
        case .reminders:
            return .init(
                title: R.string.localizable.settingsMainRemindersTitle(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.reminders(),
                imageBackgroundColor: R.color.settings.reminders(),
                remindersCount: 0
            )
        case .rate:
            return .init(
                title: R.string.localizable.settingsMainRateTitle(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.rate(),
                imageBackgroundColor: R.color.settings.rate(),
                remindersCount: 0
            )
        case .help:
            return .init(
                title: R.string.localizable.settingsMainHelpTitle(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.help(),
                imageBackgroundColor: R.color.settings.help(),
                remindersCount: 0
            )
        case .sources:
            return .init(
                title: R.string.localizable.settingsRecommendationsSources(),
                description: nil,
                titleColor: R.color.foodViewing.basicDark(),
                descriptionColor: nil,
                image: R.image.settings.settingsExclamationMark(),
                imageBackgroundColor: R.color.settings.help(),
                remindersCount: 0
            )
        }
    }
}
