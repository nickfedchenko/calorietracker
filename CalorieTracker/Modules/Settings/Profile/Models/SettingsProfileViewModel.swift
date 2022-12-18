//
//  SettingsProfileViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.12.2022.
//

import UIKit

struct SettingsProfileViewModel {
    private let profileCategoryType: [ProfileSettingsCategoryType]
    
    var needUpadate: (() -> Void)?
    
    init(_ profileCategoryType: [ProfileSettingsCategoryType]) {
        self.profileCategoryType = profileCategoryType
    }
    
    func numberOfItemsInSection() -> Int {
        profileCategoryType.count
    }
    
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        guard let type = profileCategoryType[safe: indexPath.row] else {
            return nil
        }
        switch type {
        case .dietary:
            let cell: SettingsCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getDietaryCellViewModel()
            return cell
        case .title:
            let cell: SettingsProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.type = type
            cell.title = "Profile"
            return cell
        default:
            let cell: SettingsProfileTextFieldCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.type = type
            return cell
        }
    }
    
    func getCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        switch profileCategoryType[safe: indexPath.row] {
        case .name, .lastName, .city, .sex, .date, .height, .dietary:
            height = width * 0.192
        case .title:
            height = 24
        default:
            return .zero
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getTypeCell(_ indexPath: IndexPath) -> ProfileSettingsCategoryType? {
        profileCategoryType[safe: indexPath.row]
    }
    
    private func getDietaryCellViewModel() -> SettingsCategoryCellViewModel {
        .init(
            title: "Dietary Preference",
            description: nil,
            titleColor: R.color.foodViewing.basicDark(),
            descriptionColor: nil,
            image: R.image.settings.goals(),
            imageBackgroundColor: R.color.settings.goals(),
            remindersCount: 0
        )
    }
    
    private func getCategoryCellViewModel(
        _ type: ProfileSettingsCategoryType
    ) -> SettingsProfileTextFieldViewModel? {
        switch type {
        case .name:
            return .init(
                title: "First Name",
                isEnabled: true,
                value: .required(nil)
            )
        case .lastName:
            return .init(
                title: "Last Name",
                isEnabled: true,
                value: .required(nil)
            )
        case .city:
            return .init(
                title: "City",
                isEnabled: true,
                value: .optional
            )
        case .sex:
            return .init(
                title: "Sex",
                isEnabled: false,
                value: .required(nil)
            )
        case .date:
            return .init(
                title: "Date of Birth",
                isEnabled: false,
                value: .required("Month Day, Year")
            )
        case .height:
            return .init(
                title: "Height",
                isEnabled: false,
                value: .required(nil)
            )
        default:
            return nil
        }
    }
}
