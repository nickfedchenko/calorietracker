//
//  LightweightRecipeModel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 31.03.2023.
//

import UIKit

struct LightweightRecipeModel {
    let id: Int
    let title: String
    let servingKcal: Double
    let cookingTime: Int
    let eatingTags: [AdditionalTag]
    let photoUrl: URL?
    
    init?(from managedModel: DomainDish) {
        self.id = Int(managedModel.id)
        self.title = managedModel.title
        self.servingKcal = managedModel.servingValues?.kcal ?? 0
        self.cookingTime = Int(managedModel.cookTime)
        if
            let domainEatingTags = managedModel.eatingTags?.array as? [DomainEatingTag] {
            self.eatingTags = domainEatingTags.compactMap { AdditionalTag(from: $0) }
        } else {
            self.eatingTags = []
        }
        self.photoUrl = managedModel.photo
    }
    
    init?(from model: Dish) {
        self.id = model.id
        self.title = model.title
        self.servingKcal = model.values?.serving.kcal ?? 0
        self.cookingTime = model.cookTime
        self.eatingTags = model.eatingTags
        self.photoUrl = URL(string: model.photo)
    }
}
