import Foundation
// swiftlint:disable cyclomatic_complexity
typealias ProductsResult = (Result<[ProductDTO], ErrorDomain>) -> Void
typealias ProductsSearchResult = (Result<ProductsRemoteSearch, ErrorDomain>) -> Void

struct ProductsRemoteSearch: Codable {
    let error: Bool?
    let products: [SearchProductNew]
}
/// Product
struct ProductDTO: Codable {
    let id: Int
    let title: String
    let productTypeID: Int
    let brand, barcode: String?
    let productURL: Int?
    let units: [UnitElement]
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
        case brand, barcode
        case productURL = "product_url"
        case units, serving, ketoRating, nutritions, baseTags, photo, isDraft, createdAt
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
    
    // swiftlint:disable:next function_body_length
    init?(from ingredient: DomainDishIngredient) {
     
        guard  let product: Product = ingredient.product else { return nil }
        if let id = Int(product.id) {
            self.id = id
        } else {
            return nil
        }
        self.title = product.title
        self.brand = product.brand
        self.barcode = product.barcode
        self.productURL = product.productURL
        self.units = product.units ?? []
        self.serving = product.servings?.first ?? .init(size: "g", weight: 101)
        self.ketoRating = product.ketoRating
        // TODO: - Сохранить тип еще надо
        self.productTypeID = 1
        self.nutritions = {
            var nutritions: [Nutrition] = []
            
            if let vitaminA = product.composition?.vitaminA {
                nutritions.append(
                    Nutrition(
                        id: 19,
                        title: "Vitamin A",
                        unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                        ),
                        value: vitaminA
                    )
                )
            }
            
            if let vitaminD = product.composition?.vitaminD {
                nutritions.append(
                    .init(id: 14 ,
                          title: "Vitamin D",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: vitaminD)
                )
            }
            
            if let vitaminC = product.composition?.vitaminC {
                nutritions.append(
                    .init(id: 20 ,
                          title: "Vitamin C",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: vitaminC)
                )
            }
            
            if let calcium = product.composition?.calcium {
                nutritions.append(
                    .init(id: 16,
                          title: "Calcium",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: calcium
                         )
                )
            }
            
            if let totalSugar = product.composition?.totalSugars {
                nutritions.append(
                    .init(id: 11,
                          title: "Total sugar",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: totalSugar
                         )
                )
            }
            
            if let fiber = product.composition?.diataryFiber {
                nutritions.append(
                    .init(id: 9,
                          title: "Fiber",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: fiber
                         )
                )
            }
            
            if let satFat = product.composition?.saturatedFat {
                nutritions.append(
                    .init(id: 2,
                          title: "Saturated fat",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: satFat
                         )
                )
            }
            
            if let polyUnsatFat = product.composition?.polyUnsatFat {
                nutritions.append(
                    .init(id: 4,
                          title: "Polyunsaturated Fat",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: polyUnsatFat
                         )
                )
            }
            
            if let monoUnsatFat = product.composition?.monoUnsatFat {
                nutritions.append(
                    .init(id: 5,
                          title: "Monounsaturated Fat",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: monoUnsatFat
                         )
                )
            }
            
            if let transFat = product.composition?.transFat {
                nutritions.append(
                    .init(id: 3,
                          title: "Trans fat",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: transFat
                         )
                )
            }
            
            if let sodium = product.composition?.sodium {
                nutritions.append(
                    .init(id: 7,
                          title: "Sodium",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: sodium
                         )
                )
            }
            
            if let cholesterol = product.composition?.cholesterol {
                nutritions.append(
                    .init(id: 6,
                          title: "Cholesterol",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: cholesterol
                         )
                )
            }
            
            if let potassium = product.composition?.potassium {
                nutritions.append(
                    .init(id: 18,
                          title: "Potassium",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: potassium
                         )
                )
            }
            
            if let sugarAlc = product.composition?.sugarAlc {
                nutritions.append(
                    .init(id: 13,
                          title: "Sugar Alcohols",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: sugarAlc
                         )
                )
            }
            
            if let iron = product.composition?.iron {
                nutritions.append(
                    .init(id: 17,
                          title: "Iron",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: iron
                         )
                )
            }
            
            if let totalFat = product.composition?.totalFat {
                nutritions.append(
                    .init(id: 1,
                          title: "Total Fat",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: totalFat
                         )
                )
            }
            
            if let totalCarbs = product.composition?.totalCarbs {
                nutritions.append(
                    .init(id: 8,
                          title: "Total Carbohydrates",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: totalCarbs
                         )
                )
            }
            
            if let netCarbs = product.composition?.netCarbs {
                nutritions.append(
                    .init(id: 8,
                          title: "Net Carbs",
                          unit: .init(
                            id: Int(ingredient.unitID),
                            title: ingredient.unitTitle ?? "",
                            shortTitle: ingredient.unitShorTitle ?? "",
                            isOnlyForMarket: ingredient.unitIsOnlyForMarket
                          ),
                          value: netCarbs
                         )
                )
            }
           return nutritions
        }()
        self.baseTags = product.baseTags
        self.photo = {
            switch product.photo {
            case .data:
                return ""
            case .url(let url):
                return url.absoluteString
            case .none:
                return ""
            }
        }()
        self.isDraft = false
        self.createdAt = product.createdAt
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
        
        func getCoefficient() -> Double? {
            switch self {
            case .gram(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .oz(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .portion(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .cup(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .cupGrated(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .cupSliced(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .teaSpoon(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .tableSpoon(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .piece(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .smallSize(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .middleSize(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .hugeSize(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .pack(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .ml(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .floz(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
            case .custom(title: _, shortTitle: _, coefficient: let coefficient):
                return coefficient
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
        case fatsOverall = 1//
        case saturatedFats = 2//
        case transFats = 3//
        case polyUnsaturatedFats = 4//
        case monoUnsaturatedFats = 5//
        case cholesterol = 6//
        case sodium = 7//
        case carbsTotal = 8//
        case alimentaryFiber = 9//
        case netCarbs = 10
        case sugarOverall = 11//
        case includingAdditionalSugars = 12
        case sugarSpirits = 13//
        case protein = 14//
        case vitaminD = 15
        case calcium = 16//
        case ferrum = 17//
        case potassium = 18//
        case vitaminA = 19//
        case vitaminC = 20//
        case kcal = 21
        case undefined = 22
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
    
    init?(from domainTag: DomainExceptionTag?) {
        guard
            let domainTag = domainTag,
            let domainTagTitle = domainTag.title else { return nil }
        id = Int(domainTag.id)
        title = domainTagTitle
    }
    
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
