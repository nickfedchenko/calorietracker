//
//  AllergicRestrictions.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

enum AllergicRestrictions: CaseIterable, Codable {
    case gluten
    case fish
    case shellfish
    case dairy
    case eggs
    case nuts
    case peanut
    case soya
    case wheat
}

// MARK: - AllergicRestrictions + description

extension AllergicRestrictions {
    var description: String {
        switch self {
        case .gluten:
            return R.string.localizable.onboardingSecondAllergicRestrictionsGluten()
        case .fish:
            return R.string.localizable.onboardingSecondAllergicRestrictionsFish()
        case .shellfish:
            return R.string.localizable.onboardingSecondAllergicRestrictionsShellfish()
        case .dairy:
            return R.string.localizable.onboardingSecondAllergicRestrictionsDairy()
        case .eggs:
            return R.string.localizable.onboardingSecondAllergicRestrictionsEggs()
        case .nuts:
            return R.string.localizable.onboardingSecondAllergicRestrictionsNuts()
        case .peanut:
            return R.string.localizable.onboardingSecondAllergicRestrictionsPeanut()
        case .soya:
            return R.string.localizable.onboardingSecondAllergicRestrictionsSoya()
        case .wheat:
            return R.string.localizable.onboardingSecondAllergicRestrictionsWheat()
        }
    }
}
