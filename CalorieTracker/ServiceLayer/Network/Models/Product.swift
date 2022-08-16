import Foundation

typealias ProductsResult = (Result<[Product], ErrorDomain>) -> Void

/// Product
struct Product: Codable {
    let id: Int
    let barcode: String?
    let title: String
    private var rawProtein, rawFat, rawCarbs: Double
    private var rawKcal: Int
    let photo: URL?
    let composition: Composition?
    let isBasic, isBasicState, isDished: Bool?
    let brand: String?
    let servings: [Serving]?
    
    var protein: Double {
        get {
            UDM.weightIsMetric ? rawProtein : rawProtein * ImperialConstants.lbsToGramsRatio
        }
        
        set {
            rawProtein = UDM.weightIsMetric ? newValue : newValue / ImperialConstants.lbsToGramsRatio
        }
    }
    
    var fat: Double {
        get {
            UDM.weightIsMetric ? rawFat : rawFat * ImperialConstants.lbsToGramsRatio
        }
        
        set {
            rawFat = UDM.weightIsMetric ? newValue : newValue / ImperialConstants.lbsToGramsRatio
        }
    }
    
    var carbs: Double {
        get {
            UDM.weightIsMetric ? rawCarbs : rawCarbs * ImperialConstants.lbsToGramsRatio
        }
        
        set {
            rawCarbs = UDM.weightIsMetric ? newValue : newValue / ImperialConstants.lbsToGramsRatio
        }
    }
    
    var kcal: Int {
        get {
            UDM.energyIsMetric ? rawKcal : Int(Double(rawKcal) * ImperialConstants.kJToKcalRatio)
        }
        
        set {
            rawKcal = UDM.energyIsMetric ? newValue : Int(Double(newValue) / ImperialConstants.kJToKcalRatio)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case rawProtein = "protein"
        case rawFat = "fat"
        case rawCarbs = "carbs"
        case rawKcal = "kcal"
        case id, barcode, title, photo, composition, isBasic, isBasicState, isDished, brand, servings
    }
    
    init?(from managedModel: DomainProduct) {
        id = Int(managedModel.id)
        barcode = managedModel.barcode
        title = managedModel.title
        rawProtein = managedModel.protein
        rawFat = managedModel.fat
        rawCarbs = managedModel.carbs
        rawKcal = Int(managedModel.kcal)
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
    
    init?(from searchModel: SearchProduct) {
        id = searchModel.productID
        barcode = searchModel.sourceObject.barcode
        title = searchModel.title
        rawProtein = searchModel.proteins
        rawFat = searchModel.fats
        rawCarbs = searchModel.carbohydrates
        rawKcal = searchModel.kcal
        photo = searchModel.photo
        composition = Composition(from: searchModel.sourceObject)
        isBasic = searchModel.sourceObject.isBasic == 0 ? false : true
        isBasicState = searchModel.sourceObject.isBasicState == 0 ? false : true
        isDished = searchModel.sourceObject.isDished == 0 ? false : true
        brand = searchModel.sourceObject.brand
        servings = searchModel.sourceObject.servings.compactMap { Serving(from: $0) }
    }
}

struct Composition: Codable {
    private var vitaminA, vitaminD, vitaminC, vitaminK, vitaminB1, calcium, sugar, salt,
                fiber, saturatedFat, unsaturatedFat, transFat, sodium, cholesterol, potassium,
                sugarAlc, iron, magnesium, phosphorus, zinc, copper, manganese,
                selenium, fluoride, vitB2, vitB3, vitB5, vitB6, vitB7, vitB9, vitB12,
                vitE: Double?
    
    let glycemicIndex: Double?
    
    init?(from model: SourceObject) {
        vitaminA = Double(model.vitaminA100G ?? "0")
        vitaminD = Double(model.vitaminD100G ?? "0")
        vitaminC = Double(model.vitaminC100G ?? "0")
        vitaminK = model.vitaminK100G
        vitaminB1 = model.vitaminB1100G
        calcium = Double(model.calcium100G ?? "0")
        sugar = Double(model.sugars100G ?? "0")
        salt = Double(model.salt100G ?? "0")
        fiber = Double(model.fiber100G ?? "0")
        saturatedFat = model.saturatedFat
        unsaturatedFat = model.unsaturatedFat
        transFat = model.transFat
        sodium = model.sodium
        cholesterol = model.cholesterol
        potassium = model.potassium
        sugarAlc = model.sugarAlc
        iron = model.iron
        magnesium = model.magnesium
        phosphorus = model.phosphorus
        zinc = model.zinc
        copper = model.copper
        manganese = model.manganese
        selenium = model.selenium
        fluoride = model.fluoride
        vitB2 = model.vitB2
        vitB3 = model.vitB3
        vitB5 = model.vitB5
        vitB6 = model.vitB6
        vitB7 = model.vitB7
        vitB9 = model.vitB9
        vitB12 = model.vitB12
        vitE = Double(model.vitE ?? 0)
        glycemicIndex = model.glycemicIndex
    }
    
    enum CodingKeys: String, CodingKey {
        case sodium
        case saturatedFat = "saturated_fat"
        case sugar
        case fiber
        case unsaturatedFat = "unsaturated_fat"
        case cholesterol
        case potassium
        case calcium
        case iron
        case salt
        case transFat = "trans_fat"
        case vitaminC = "vitamin_c"
        case manganese
        case selenium
        case vitB2 = "vit_b2"
        case phosphorus
        case zinc
        case copper
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
        case magnesium
    }
    
    private func processWeightToGet(_ value: Double?) -> Double? {
        guard let value = value else {
            return nil
        }
        return UDM.weightIsMetric ? value : value * ImperialConstants.lbsToGramsRatio
    }
    
    private func processWeightToSet(_ value: Double?) -> Double? {
        guard let value = value else {
            return nil
        }
        return UDM.weightIsMetric ? value : value / ImperialConstants.lbsToGramsRatio
    }
}

struct Serving: Codable {
    let title: String
    let plural: String?
    private var rawWeight: Double?
    
    init?(from model: SearchServing) {
        title = model.title
        plural = nil
    }
    
    var weight: Double? {
        get {
            guard let rawWeight = rawWeight else {
                return nil
            }
            return UDM.weightIsMetric ? rawWeight : rawWeight * ImperialConstants.lbsToGramsRatio
        }
        set {
            guard let newValue = newValue else { return }
            rawWeight = UDM.weightIsMetric ? newValue : newValue / ImperialConstants.lbsToGramsRatio
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title, plural
        case rawWeight = "weight"
    }
}
