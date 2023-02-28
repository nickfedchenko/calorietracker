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
    let shortTitle: String?
    let value, kcal: Double?
    let isNamed, isReference, isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case productUnitID = "productUnitId"
        case title, shortTitle, value, kcal, isNamed, isReference, isDefault
    }
    
    enum ConvenientUnit: WithGetTitleProtocol {
        func getTitle(_ lenght: Lenght) -> String? {
            switch self {
            case .gram(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .oz(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .portion(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .cup(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .cupGrated(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .cupSliced(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .teaSpoon(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .tableSpoon(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .piece(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .smallSize(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .middleSize(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .hugeSize(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .pack(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .ml(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .floz(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            case .custom(title: let title, shortTitle: let shortTitle, coefficient: _):
                return lenght == .short ? shortTitle ?? title : title
            }
        }
        
        case gram(title: String, shortTitle: String?, coefficient: Double?)
        case oz(title: String, shortTitle: String?, coefficient: Double?)
        case portion(title: String, shortTitle: String?, coefficient: Double?)
        case cup(title: String, shortTitle: String?, coefficient: Double?)
        case cupGrated(title: String, shortTitle: String?, coefficient: Double?)
        case cupSliced(title: String, shortTitle: String?, coefficient: Double?)
        case teaSpoon(title: String, shortTitle: String?, coefficient: Double?)
        case tableSpoon(title: String, shortTitle: String?, coefficient: Double?)
        case piece(title: String, shortTitle: String?, coefficient: Double?)
        case smallSize(title: String, shortTitle: String?, coefficient: Double?)
        case middleSize(title: String, shortTitle: String?, coefficient: Double?)
        case hugeSize(title: String, shortTitle: String?, coefficient: Double?)
        case pack(title: String, shortTitle: String?, coefficient: Double?)
        case ml(title: String, shortTitle: String?, coefficient: Double?)
        case floz(title: String, shortTitle: String?, coefficient: Double?)
        case custom(title: String, shortTitle: String?, coefficient: Double?)
        
        var id: Int {
            switch self {
            case .gram:
                return 1
            case .oz:
                return 2
            case .portion:
                return 3
            case .cup:
                return 4
            case .cupGrated:
                return 5
            case .cupSliced:
                return 6
            case .teaSpoon:
                return 7
            case .tableSpoon:
                return 8
            case .piece:
                return 9
            case .smallSize:
                return 10
            case .middleSize:
                return 11
            case .hugeSize:
                return 12
            case .pack:
                return 13
            case .ml:
                return 14
            case .floz:
                return 15
            default:
                return -1
            }
        }
    }
    
    func getTitle(_ lenght: Lenght) -> String? {
        if lenght == .short {
            return shortTitle ?? title
        } else {
            return title
        }
    }
    
    var convenientUnit: ConvenientUnit  {
        switch id {
        case 1:
            return .gram(title: title, shortTitle: shortTitle, coefficient: value)
        case 2:
            return .oz(title: title, shortTitle: shortTitle, coefficient: value)
        case 3:
            return .portion(title: title, shortTitle: shortTitle, coefficient: value)
        case 4:
            return .cup(title: title, shortTitle: shortTitle, coefficient: value)
        case 5:
            return .cupGrated(title: title, shortTitle: shortTitle, coefficient: value)
        case 6:
            return .cupSliced(title: title, shortTitle: shortTitle, coefficient: value)
        case 7:
            return .teaSpoon(title: title, shortTitle: shortTitle, coefficient: value)
        case 8:
            return .tableSpoon(title: title, shortTitle: shortTitle, coefficient: value)
        case 9:
            return .piece(title: title, shortTitle: shortTitle, coefficient: value)
        case 10:
            return .smallSize(title: title, shortTitle: shortTitle, coefficient: value)
        case 11:
            return .middleSize(title: title, shortTitle: shortTitle, coefficient: value)
        case 12:
            return .hugeSize(title: title, shortTitle: shortTitle, coefficient: value)
        case 13:
            return .pack(title: title, shortTitle: shortTitle, coefficient: value)
        case 14:
            return .ml(title: title, shortTitle: shortTitle, coefficient: value)
        case 15:
            return .floz(title: title, shortTitle: shortTitle, coefficient: value)
        default:
            return .custom(title: title, shortTitle: shortTitle, coefficient: value)
        }
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
