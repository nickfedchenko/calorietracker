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
    let networkService: NetworkEngineInterface = NetworkEngine.shared
    
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
        guard let productName = view.getProductName(),
        let protein = stringFromDouble(formValues[.protein] ?? ""),
        let fat = stringFromDouble(formValues[.fat] ?? ""),
        let kcal = stringFromDouble(formValues[.kcal] ?? ""),
        let carbs = stringFromDouble(formValues[.carb] ?? "")
        else {
            return
        }
        let hundredProtein = protein
        let hundredFat = fat
        let hundredKcal = kcal
        let hundredCarbs = carbs
        let productId = UUID().uuidString
        brand = (brand ?? "").isEmpty ? nil : brand
        let photoURL: URL? = {
            if
                let image = image,
                let data = image.jpegData(compressionQuality: 1),
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filePath = path.appendingPathComponent("\(productId).png")
                do {
                    try data.write(to: filePath, options: .atomic)
                    return filePath
                } catch {
                    print("Can't save image")
                    return nil
                }
            } else {
                return nil
            }
        }()
        
        let bcf = ByteCountFormatter()
               bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
               bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(image?.jpegData(compressionQuality: 0.5)?.count ?? Data().count))
        print(string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let product = Product(
            id: productId,
            title: productName,
            isUserProduct: true,
            barcode: barcode,
            brand: brand,
            protein: hundredProtein,
            fat: hundredFat,
            carbs: hundredCarbs,
            kcal: hundredKcal,
            productURL: 8,
            photo: photoURL != nil ? .url(photoURL!) : nil,
            composition: .init(
                totalFat: stringFromDouble(formValues[.fat] ?? ""),
                saturatedFat: stringFromDouble(formValues[.satFat] ?? ""),
                transFat: stringFromDouble(formValues[.transFat] ?? ""),
                polyUnsatFat: stringFromDouble(formValues[.polyFat] ?? ""),
                monoUnsatFat: stringFromDouble(formValues[.monoFat] ?? "") ,
                cholesterol: stringFromDouble(formValues[.choleterol] ?? ""),
                sodium: stringFromDouble(formValues[.sodium] ?? ""),
                totalCarbs: stringFromDouble(formValues[.carb] ?? ""),
                diataryFiber: stringFromDouble(formValues[.dietaryFiber] ?? ""),
                netCarbs: stringFromDouble(formValues[.netCarbs] ?? ""),
                totalSugars: stringFromDouble(formValues[.sugars] ?? ""),
                inclAddedSugars: stringFromDouble(formValues[.addSugars] ?? ""),
                sugarAlc: stringFromDouble(formValues[.sugarAlco] ?? ""),
                protein: stringFromDouble(formValues[.protein] ?? ""),
                vitaminD: stringFromDouble(formValues[.vitaminD] ?? ""),
                calcium: stringFromDouble(formValues[.calcium] ?? ""),
                iron: stringFromDouble(formValues[.iron] ?? ""),
                potassium: stringFromDouble(formValues[.potassium] ?? ""),
                vitaminA: stringFromDouble(formValues[.vitaminA] ?? ""),
                vitaminC: stringFromDouble(formValues[.vitaminC] ?? "")
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
        
        let backendModel = BackendSubmitModel(product: product)
        networkService.uploadUserProduct(product: backendModel) { result in
            switch result {
            case .success(let response):
                print(response.error)
                print(response.success)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
