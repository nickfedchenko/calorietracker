//
//  BackendSubmitProduct.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.04.2023.
//

import ApphudSDK
import UIKit
typealias BackendSubmitResult = (Result<BackendUploadResponse, ErrorDomain>) -> Void

struct BackendUploadResponse: Codable {
    let error: Bool
    let success: Bool
}

struct BackendSubmitModel: Codable {
    let userToken: String
    let lang: String
    let type: String
    let model: [BackendSubmitProduct]
    
    init(product: Product) {
        let submitProduct = product.generateBackendSubmitProduct()
        self.model = [submitProduct]
        self.userToken = Apphud.userID()
        self.lang = Locale.current.languageCode ?? "en"
        self.type = "product"
    }
}

struct BackendSubmitProduct: Codable {
    let id: String
    let title: String
    let productTypeID: Int
    let barcode: String?
    let brand: String?
    let photo: String?
    let nutritions: [Nutrition]
    let serving: Serving?
    var units: [UnitElement]
    let createdAt: String
}
