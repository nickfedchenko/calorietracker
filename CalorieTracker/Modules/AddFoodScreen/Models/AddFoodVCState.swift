//
//  AddFoodVCState.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 13.11.2022.
//

import Foundation

enum AddFoodVCState: Equatable {
    case search(AddFoodVCSearchState)
    case `default`
}

enum AddFoodVCSearchState {
    case recent
    case noResults
    case foundResults
}
