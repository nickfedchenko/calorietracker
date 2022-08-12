import Foundation

typealias ProductsResult = (Result<[Product], ErrorDomain>) -> Void

/// Codable структура.
struct Product: Codable {
    var id: Int
    let barcode: String?
    let title: String
    let protein, fat, carbs: Double
    let kcal: Int
    let photo: URL?
    let composition: Composition?
    let isBasic, isBasicState, isDished: Bool?
    let brand: String?
    let servings: [Serving]?
    
    init?(from managedModel: DomainProduct) {
        id = Int(managedModel.id)
        barcode = managedModel.barcode
        title = managedModel.title
        protein = managedModel.protein
        fat = managedModel.fat
        carbs = managedModel.carbs
        kcal = Int(managedModel.kcal)
        photo = managedModel.photo
        isBasic = managedModel.isBasic
        isBasicState = managedModel.isBasicState
        isDished = managedModel.isDished
        brand = managedModel.brand
        if let servingsData = managedModel.servings {
            servings = try? JSONDecoder().decode([Serving].self, from: servingsData)
        } else {
            servings = nil
        }
        
        if let compositionData = managedModel.composition {
            composition = try? JSONDecoder().decode(Composition.self, from: compositionData)
        } else {
            composition = nil
        }
    }
}

struct Composition: Codable {
    let vitaminA, vitaminD, vitaminC, vitaminK, vitaminB1, calcium, sugar, salt, fiber, saturatedFat, unsaturatedFat,
        transFat, sodium, cholesterol, potassium, sugarAlc, glycemicIndex, iron, magnesium, phosphorus, zinc, copper,
        manganese, selenium, fluoride, vitB2, vitB3, vitB5, vitB6, vitB7, vitB9, vitB12, vitE: Double?
    
    enum CodingKeys: String, CodingKey {
            case sodium
            case saturatedFat = "saturated_fat"
            case sugar, fiber
            case unsaturatedFat = "unsaturated_fat"
            case cholesterol, potassium, calcium, iron, salt
            case transFat = "trans_fat"
            case vitaminC = "vitamin_c"
            case manganese, selenium, magnesium
            case vitB2 = "vit_b2"
            case phosphorus, zinc, copper
            case vitB3 = "vit_b3"
            case vitaminK = "vitamin_k"
            case vitE = "vit_e"
            case vitaminD = "vitamin_d"
            case vitaminA = "vitamin_a"
            case vitaminB1 = "vitamin_b1"
            case fluoride
            case vitB5 = "vit_b5"
            case vitB6 = "vit_b6"
            case vitB7 = "vit_b7"
            case vitB9 = "vit_b9"
            case vitB12 = "vit_b12"
            case sugarAlc = "sugar_alc"
            case glycemicIndex = "glycemic_index"
        }
}

struct Serving: Codable {
    let title: String
    let plural: String?
    let weight: Int?
}
