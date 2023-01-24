import Foundation

typealias ProductsResult = (Result<[ProductDTO], ErrorDomain>) -> Void

/// Product
struct ProductDTO: Codable {
    let id: Int
    let title: String
    let productTypeID: Int
    let brand, barcode: String?
    let marketCategory: AdditionalTag?
    let productURL: Int?
    let units: [UnitElement]
    let marketUnit: MarketUnitClass?
    let serving: Serving
    let ketoRating: String?
    let nutritions: [Nutrition]
    let baseTags: [ExceptionTag]
    let photo: String
    let isDraft: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case productTypeID = "productTypeId"
        case brand, barcode, marketCategory
        case productURL = "product_url"
        case units, marketUnit, serving, ketoRating, nutritions, baseTags, photo, isDraft, createdAt
    }
    
    var protein: Double {
        guard let protein = nutritions.first(where: { $0.nutritionType == .protein }) else {
            return .zero
        }
        return protein.value ?? .zero
    }
    
    var fat: Double {
        guard let fat = nutritions.first(where: { $0.nutritionType == .fatsOverall }) else {
            return .zero
        }
        return fat.value ?? .zero
    }
    
    var kcal: Double {
        guard let kcal = nutritions.first(where: { $0.nutritionType == .kcal }) else {
            return .zero
        }
        return kcal.value ?? .zero
    }
    
    var carbs: Double {
        guard let carbs = nutritions.first(where: { $0.nutritionType == .carbsTotal }) else {
            return .zero
        }
        return carbs.value ?? .zero
    }
    
//    init?(from searchModel: SearchProduct) {
//        id = searchModel.productID
//        barcode = searchModel.sourceObject.barcode
//        title = searchModel.title
//        rawProtein = searchModel.proteins
//        rawFat = searchModel.fats
//        rawCarbs = searchModel.carbohydrates
//        rawKcal = searchModel.kcal
//        photo = searchModel.photo
//        composition = CompositionDTO(from: searchModel.sourceObject)
//        isBasic = searchModel.sourceObject.isBasic == 0 ? false : true
//        isBasicState = searchModel.sourceObject.isBasicState == 0 ? false : true
//        isDished = searchModel.sourceObject.isDished == 0 ? false : true
//        brand = searchModel.sourceObject.brand
//        servings = searchModel.sourceObject.servings.compactMap { ServingDTO(from: $0) }
//    }
}

struct UnitElement: Codable {
    let id: Int?
    let productUnitID: Int?
    let title: String
    let value, kcal: Double?
    let isNamed, isReference, isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case productUnitID = "productUnitId"
        case title, value, kcal, isNamed, isReference, isDefault
    }
}

struct Nutrition: Codable {
    enum NutritionType: Int {
        case fatsOverall = 1
        case saturatedFats
        case transFats
        case polyUnsaturatedFats
        case monoUnsaturatedFats
        case cholesterol
        case sodium
        case carbsTotal
        case alimentaryFiber
        case netCarbs
        case sugarOverall
        case includingAdditionalSugars
        case sugarSpirits
        case protein
        case vitaminD
        case calcium
        case ferrum
        case potassium
        case vitaminA
        case vitaminC
        case kcal
        case undefined
    }
    
    let id: Int
    let title: String
    let unit: MarketUnitClass
    let value: Double?
    
    var nutritionType: NutritionType {
        return NutritionType(rawValue: id) ?? .undefined
    }
}

struct ExceptionTag: Hashable, Codable {

    enum ConvenientExceptionTag: Int, CaseIterable, Codable {
        case peanut = 2
        case gluten = 3
        case meat = 4
        case mutton = 5
        case beef = 6
        case pork = 7
        case starchyVegetables = 8
        case milkProducts = 9
        case seafood = 10
        case nuts = 11
        case poultry = 12
        case chicken = 13
        case turkey = 14
        case fish = 15
        case soy = 16
        case eggs = 17
        case honey = 18
    }
    
    let id: Int
    let title: String
    var convenientTag: ConvenientExceptionTag? {
        ConvenientExceptionTag(rawValue: id)
    }
    
    var colorRepresentationTag: TagTypeColorRepresentation? {
        guard let convenientTag = convenientTag else { return nil }
        switch convenientTag {
        case _:
            return .ingredients
        }
    }
}
