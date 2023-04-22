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

struct BackendSubmitModel: Encodable {
    let userToken: String
    let lang: String
    let type: String
    let product: String
    
    init(product: Product) {
        self.userToken = Apphud.userID()
        self.lang = Locale.current.languageCode ?? "en"
        self.type = "product"
        let encoder = JSONEncoder()
        let submitProduct = product.generateBackendSubmitProduct()
        let submitProductData = (try? encoder.encode(submitProduct)) ?? Data()
        if let productJson = String(data: submitProductData, encoding: .utf8) {
            self.product = productJson
        } else {
            self.product = ""
        }
    }
}

struct BackendSubmitProduct: Encodable {
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
