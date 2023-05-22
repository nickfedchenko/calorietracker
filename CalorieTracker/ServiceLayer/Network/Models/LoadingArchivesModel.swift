//
//  LoadingArchivesModel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.05.2023.
//

import Foundation

typealias ArchivesListListResult = (Result<ArchivesListResponse, ErrorDomain>) -> Void

struct ArchivesListResponse: Codable {
    let error: Bool
    let links: [ArchiveLinkModel]
}

struct ArchiveLinkModel: Codable {
    let url: URL
    let updatedAt: Date
}
