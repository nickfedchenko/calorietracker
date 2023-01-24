//
//  SettingsProfileViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.12.2022.
//

import UIKit

struct SettingsProfileViewModel {
    private let profileCategoryType: [ProfileSettingsCategoryType]
    private var presenter: ProfileSettingsPresenterInterface?
    var needUpadate: (() -> Void)?
    
    init(
        types profileCategoryType: [ProfileSettingsCategoryType],
        presenter: ProfileSettingsPresenterInterface? = nil
    ) {
        self.profileCategoryType = profileCategoryType
        self.presenter = presenter
    }
    
    func numberOfItemsInSection() -> Int {
        profileCategoryType.count
    }
    
    // swiftlint:disable:next cyclomatic_complexity
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
            cell.title = "PROFILE"
            return cell
        default:
            let cell: SettingsProfileTextFieldCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.viewModel = getCategoryCellViewModel(type)
            cell.text = {
                switch type {
                case .name:
                    return presenter?.getNameStr()
                case .lastName:
                    return presenter?.getLastNameStr()
                case .city:
                    return presenter?.getCityStr()
                case .sex:
                    return presenter?.getUserSexStr()
                case .date:
                    return presenter?.getDateStr()
                case .height:
                    return presenter?.getHeightStr()
                default:
                    return nil
                }
            }()
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
    
    func getIndexType(_ type: ProfileSettingsCategoryType) -> Int? {
        profileCategoryType.firstIndex(of: type)
    }
    
    private func getDietaryCellViewModel() -> SettingsCategoryCellViewModel {
        let dietary = presenter?.getDietary() ?? .classic
        
        return .init(
            title: "Dietary Preference",
            description: nil,
            titleColor: R.color.foodViewing.basicDark(),
            descriptionColor: nil,
            image: getImageForDietaryCell(dietary),
            imageBackgroundColor: getColorForDietaryCell(dietary),
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
    
    private func getColorForDietaryCell(_ dietary: UserDietary) -> UIColor? {
        switch dietary {
        case .classic:
            return R.color.settings.dietaryClassic()
        case .pescatarian:
            return R.color.settings.dietaryPescatarian()
        case .vegetarian:
            return R.color.settings.dietaryVegetarian()
        case .vegan:
            return R.color.settings.dietaryVegan()
        }
    }
    
    private func getImageForDietaryCell(_ dietary: UserDietary) -> UIImage? {
        switch dietary {
        case .classic:
            return R.image.settings.dietaryClassic()
        case .pescatarian:
            return R.image.settings.dietaryPescatarian()
        case .vegetarian:
            return R.image.settings.dietaryVegetarian()
        case .vegan:
            return R.image.settings.dietaryVegan()
        }
    }
}
