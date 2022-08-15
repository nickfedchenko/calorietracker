import Foundation

typealias ProductsResult = (Result<[Product], ErrorDomain>) -> Void

/// Codable структура.
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
}

struct Composition: Codable {
    private var rawVitaminA, rawVitaminD, rawVitaminC, rawVitaminK, rawVitaminB1, rawCalcium, rawSugar, rawSalt,
                rawFiber, rawSaturatedFat, rawUnsaturatedFat, rawTransFat, rawSodium, rawCholesterol, rawPotassium,
                rawSugarAlc, rawIron, rawMagnesium, rawPhosphorus, rawZinc, rawCopper, rawManganese,
                rawSelenium, rawFluoride, rawVitB2, rawVitB3, rawVitB5, rawVitB6, rawVitB7, rawVitB9, rawVitB12,
                rawVitE: Double?
    
    let glycemicIndex: Double?
    
    enum CodingKeys: String, CodingKey {
        case rawSodium = "sodium"
        case rawSaturatedFat = "saturated_fat"
        case rawSugar = "sugar"
        case rawFiber = "fiber"
        case rawUnsaturatedFat = "unsaturated_fat"
        case rawCholesterol = "cholesterol"
        case rawPotassium = "potassium"
        case rawCalcium = "calcium"
        case rawIron = "iron"
        case rawSalt = "salt"
        case rawTransFat = "trans_fat"
        case rawVitaminC = "vitamin_c"
        case rawManganese = "manganese"
        case rawSelenium = "selenium"
        case rawVitB2 = "vit_b2"
        case rawPhosphorus = "phosphorus"
        case rawZinc = "zinc"
        case rawCopper = "copper"
        case rawVitB3 = "vit_b3"
        case rawVitaminK = "vitamin_k"
        case rawVitE = "vit_e"
        case rawVitaminD = "vitamin_d"
        case rawVitaminA = "vitamin_a"
        case rawVitaminB1 = "vitamin_b1"
        case rawFluoride = "flouride"
        case rawVitB5 = "vit_b5"
        case rawVitB6 = "vit_b6"
        case rawVitB7 = "vit_b7"
        case rawVitB9 = "vit_b9"
        case rawVitB12 = "vit_b12"
        case rawSugarAlc = "sugar_alc"
        case glycemicIndex = "glycemic_index"
        case rawMagnesium = "magnesium"
    }
    
    var sodium: Double? {
        get {
            processWeightToGet(rawSodium)
        }
        set {
            rawSodium = processWeightToSet(newValue)
        }
    }
    
    var saturatedFat: Double? {
        get {
            processWeightToGet(rawSaturatedFat)
        }
        set {
            rawSaturatedFat = processWeightToSet(newValue)
        }
    }
    
    var sugar: Double? {
        get {
            processWeightToGet(rawSugar)
        }
        set {
            rawSugar = processWeightToSet(newValue)
        }
    }
    
    var fiber: Double? {
        get {
            processWeightToGet(rawFiber)
        }
        set {
            rawFiber = processWeightToSet(newValue)
        }
    }
    
    var unsaturatedFat: Double? {
        get {
            processWeightToGet(rawUnsaturatedFat)
        }
        set {
            rawUnsaturatedFat = processWeightToSet(newValue)
        }
    }
    
    var cholesterol: Double? {
        get {
            processWeightToGet(rawCholesterol)
        }
        set {
            rawCholesterol = processWeightToSet(newValue)
        }
    }
    
    var potassium: Double? {
        get {
            processWeightToGet(rawPotassium)
        }
        set {
            rawPotassium = processWeightToSet(newValue)
        }
    }
    
    var calcium: Double? {
        get {
            processWeightToGet(rawCalcium)
        }
        set {
            rawCalcium = processWeightToSet(newValue)
        }
    }
    
    var iron: Double? {
        get {
            processWeightToGet(rawIron)
        }
        set {
            rawIron = processWeightToSet(newValue)
        }
    }
    
    var salt: Double? {
        get {
            processWeightToGet(rawSalt)
        }
        set {
            rawSalt = processWeightToSet(newValue)
        }
    }
    
    var transFat: Double? {
        get {
            processWeightToGet(rawTransFat)
        }
        set {
            rawTransFat = processWeightToSet(newValue)
        }
    }
    
    var vitaminC: Double? {
        get {
            processWeightToGet(rawVitaminC)
        }
        set {
            rawVitaminC = processWeightToSet(newValue)
        }
    }
    
    var manganese: Double? {
        get {
            processWeightToGet(rawManganese)
        }
        set {
            rawManganese = processWeightToSet(newValue)
        }
    }
    
    var selenium: Double? {
        get {
            processWeightToGet(rawSelenium)
        }
        set {
            rawSelenium = processWeightToSet(newValue)
        }
    }
    
    var magnesium: Double? {
        get {
            processWeightToGet(rawMagnesium)
        }
        set {
            rawMagnesium = processWeightToSet(newValue)
        }
    }
    
    var vitB2: Double? {
        get {
            processWeightToGet(rawVitB2)
        }
        set {
            rawVitB2 = processWeightToSet(newValue)
        }
    }
    
    var phosphorus: Double? {
        get {
            processWeightToGet(rawPhosphorus)
        }
        set {
            rawPhosphorus = processWeightToSet(newValue)
        }
    }
    
    var zinc: Double? {
        get {
            processWeightToGet(rawZinc)
        }
        set {
            rawZinc = processWeightToSet(newValue)
        }
    }
    
    var copper: Double? {
        get {
            processWeightToGet(rawCopper)
        }
        set {
            rawCopper = processWeightToSet(newValue)
        }
    }
    
    var vitB3: Double? {
        get {
            processWeightToGet(rawVitB3)
        }
        set {
            rawVitB3 = processWeightToSet(newValue)
        }
    }
    
    var vitaminK: Double? {
        get {
            processWeightToGet(rawVitaminK)
        }
        set {
            rawVitaminK = processWeightToSet(newValue)
        }
    }
    
    var vitE: Double? {
        get {
            processWeightToGet(rawVitE)
        }
        set {
            rawVitE = processWeightToSet(newValue)
        }
    }
    
    var vitaminD: Double? {
        get {
            processWeightToGet(rawVitaminD)
        }
        set {
            rawVitaminD = processWeightToSet(newValue)
        }
    }
    
    var vitaminA: Double? {
        get {
            processWeightToGet(rawVitaminA)
        }
        set {
            rawVitaminA = processWeightToSet(newValue)
        }
    }
    
    var vitaminB1: Double? {
        get {
            processWeightToGet(rawVitaminB1)
        }
        set {
            rawVitaminB1 = processWeightToSet(newValue)
        }
    }
    
    var fluoride: Double? {
        get {
            processWeightToGet(rawFluoride)
        }
        set {
            rawFluoride = processWeightToSet(newValue)
        }
    }
    
    var vitB5: Double? {
        get {
            processWeightToGet(rawVitB5)
        }
        set {
            rawVitB5 = processWeightToSet(newValue)
        }
    }
    
    var vitB6: Double? {
        get {
            processWeightToGet(rawVitB6)
        }
        set {
            rawVitB6 = processWeightToSet(newValue)
        }
    }
    
    var vitB7: Double? {
        get {
            processWeightToGet(rawVitB7)
        }
        set {
            rawVitB7 = processWeightToSet(newValue)
        }
    }
    
    var vitB9: Double? {
        get {
            processWeightToGet(rawVitB9)
        }
        set {
            rawVitB9 = processWeightToSet(newValue)
        }
    }
    
    var vitB12: Double? {
        get {
            processWeightToGet(rawVitB12)
        }
        set {
            rawVitB12 = processWeightToSet(newValue)
        }
    }
    
    var sugarAlc: Double? {
        get {
            processWeightToGet(rawSugarAlc)
        }
        set {
            rawSugarAlc = processWeightToSet(newValue)
        }
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
