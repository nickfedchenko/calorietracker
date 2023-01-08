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
    
    func saveProduct() {
        let formValues = view.getFormValues()
        let image = view.getImage()
        let brand = view.getBrand()
        let barcode = view.getBarcode()
        let servingDescription = view.getServingDescription()
        let servingWeight = view.getServingWeight()
        
        guard let productName = view.getProductName(),
        let protein = stringFromDouble(formValues[.protein] ?? ""),
        let fat = stringFromDouble(formValues[.fat] ?? ""),
        let kcal = stringFromDouble(formValues[.kcal] ?? ""),
        let carbs = stringFromDouble(formValues[.carb] ?? "")
        else { return }
        
        let product: Product = .init(
            id: UUID().uuidString,
            title: productName,
            isUserProduct: true,
            barcode: barcode,
            brand: brand,
            protein: protein,
            fat: fat,
            carbs: carbs,
            kcal: kcal,
            photo: {
                guard let data = image?.pngData() else { return nil }
                return .data(data)
            }(),
            composition: .init(
                vitaminA: stringFromDouble(formValues[.vitaminA] ?? ""),
                vitaminD: stringFromDouble(formValues[.vitaminD] ?? ""),
                vitaminC: stringFromDouble(formValues[.vitaminC] ?? ""),
                calcium: stringFromDouble(formValues[.calcium] ?? ""),
                sugar: stringFromDouble(formValues[.sugars] ?? ""),
                fiber: stringFromDouble(formValues[.dietaryFiber] ?? ""),
                satFat: stringFromDouble(formValues[.satFat] ?? ""),
                unsatFat: stringFromDouble(formValues[.monoFat] ?? ""),
                transFat: stringFromDouble(formValues[.transFat] ?? ""),
                sodium: stringFromDouble(formValues[.sodium] ?? ""),
                cholesterol: stringFromDouble(formValues[.choleterol] ?? ""),
                potassium: stringFromDouble(formValues[.potassium] ?? ""),
                sugarAlc: stringFromDouble(formValues[.sugarAlco] ?? ""),
                iron: stringFromDouble(formValues[.iron] ?? ""),
                addSugar: stringFromDouble(formValues[.addSugars] ?? "")
            ),
            servings: [
                .init(
                    title: servingDescription,
                    weight: servingWeight
                )
            ]
        )
        
        localDomainService.saveProducts(products: [product], saveInPriority: true)
        router?.openProductViewController(product)
    }
}