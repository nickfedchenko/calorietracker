//
//  RecomendationModel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.03.2023.
//

import Foundation

struct RecomendationsSectionModel {
    let section: String
    let links: [RecommendationLink]
}

struct RecommendationLink {
    var text: String
    var link: String
}

