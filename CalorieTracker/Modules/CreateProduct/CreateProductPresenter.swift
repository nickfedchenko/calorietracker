//
//  CreateProductPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 11.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol CreateProductPresenterInterface: AnyObject {
    func didTapCloseButton()
    func didTapScanButton(_ complition: @escaping (String) -> Void)
    func saveProduct()
}

class CreateProductPresenter {
    
    unowned var view: CreateProductViewControllerInterface
    let router: CreateProductRouterInterface?
    let interactor: CreateProductInteractorInterface?
    let localDomainService: LocalDomainServiceInterface = LocalDomainService()
    
    init(
        interactor: CreateProductInteractorInterface,
        router: CreateProductRouterInterface,
        view: CreateProductViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func stringFromDouble(_ str: String?) -> Double? {
        guard let str = str else { return nil }
        return Double(str)
    }
}

extension CreateProductPresenter: CreateProductPresenterInterface {
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func didTapScanButton(_ complition: @escaping (String) -> Void) {
        router?.openScanViewController { barcode in
            complition(barcode)
        }
    }
    
    // swiftlint:disable:next function_body_length
    func saveProduct() {
        let formValues = view.getFormValues()
        let image = view.getImage()
        var brand = view.getBrand()
        let barcode = view.getBarcode()
        let servingDescription = view.getServingDescription()
        let servingWeight = view.getServingWeight() ?? 100
        let coefficient = 100 / servingWeight
        guard let productName = view.getProductName(),
        let protein = stringFromDouble(formValues[.protein] ?? ""),
        let fat = stringFromDouble(formValues[.fat] ?? ""),
        let kcal = stringFromDouble(formValues[.kcal] ?? ""),
        let carbs = stringFromDouble(formValues[.carb] ?? "")
        else {
            return
        }
        let hundredProtein = protein * coefficient
        let hundredFat = fat * coefficient
        let hundredKcal = kcal * coefficient
        let hundredCarbs = carbs * coefficient
        brand = (brand ?? "").isEmpty ? nil : brand
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let product = Product(
            id: UUID().uuidString,
            title: productName,
            isUserProduct: true,
            barcode: barcode,
            brand: brand,
            protein: hundredProtein,
            fat: hundredFat,
            carbs: hundredCarbs,
            kcal: hundredKcal,
            productURL: 8,
            photo: nil,
            composition: .init(
                totalFat: (stringFromDouble(formValues[.fat] ?? "") ?? 0) * coefficient,
                saturatedFat: (stringFromDouble(formValues[.satFat] ?? "") ?? 0) * coefficient,
                transFat: (stringFromDouble(formValues[.transFat] ?? "") ?? 0) * coefficient,
                polyUnsatFat: (stringFromDouble(formValues[.polyFat] ?? "") ?? 0) * coefficient,
                monoUnsatFat: (stringFromDouble(formValues[.monoFat] ?? "") ?? 0) * coefficient,
                cholesterol: (stringFromDouble(formValues[.choleterol] ?? "") ?? 0) * coefficient,
                sodium: (stringFromDouble(formValues[.sodium] ?? "") ?? 0) * coefficient,
                totalCarbs: (stringFromDouble(formValues[.carb] ?? "") ?? 0) * coefficient,
                diataryFiber: (stringFromDouble(formValues[.dietaryFiber] ?? "") ?? 0) * coefficient,
                netCarbs: (stringFromDouble(formValues[.netCarbs] ?? "") ?? 0) * coefficient,
                totalSugars: (stringFromDouble(formValues[.sugars] ?? "") ?? 0) * coefficient,
                inclAddedSugars: (stringFromDouble(formValues[.addSugars] ?? "") ?? 0) * coefficient,
                sugarAlc: (stringFromDouble(formValues[.sugarAlco] ?? "") ?? 0) * coefficient,
                protein: (stringFromDouble(formValues[.protein] ?? "") ?? 0) * coefficient,
                vitaminD: (stringFromDouble(formValues[.vitaminD] ?? "") ?? 0) * coefficient,
                calcium: (stringFromDouble(formValues[.calcium] ?? "") ?? 0) * coefficient,
                iron: (stringFromDouble(formValues[.iron] ?? "") ?? 0) * coefficient,
                potassium: (stringFromDouble(formValues[.potassium] ?? "") ?? 0) * coefficient,
                vitaminA: (stringFromDouble(formValues[.vitaminA] ?? "") ?? 0) * coefficient,
                vitaminC: (stringFromDouble(formValues[.vitaminC] ?? "") ?? 0) * coefficient
            ),
            servings: [
                .init(
                    size: servingDescription,
                    weight: servingWeight
                )
            ],
            ketoRating: nil,
            baseTags: [],
            createdAt: dateFormatter.string(from: Date())
        )
        
        RateRequestManager.increment(for: .createFood)
        localDomainService.saveProducts(products: [product], saveInPriority: true)
        router?.openProductViewController(product)
    }
}
