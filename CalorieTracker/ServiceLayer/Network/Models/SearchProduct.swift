import Foundation

typealias SearchProductsResponse = (Result<SearchProducts, ErrorDomain>) -> Void
// MARK: - Search product response
struct SearchProducts: Codable {
    let error: Bool
    let data: [SearchProduct]
}

// MARK: - Search product
struct SearchProduct: Codable {
    let productID: Int
    let foodID: String?
    let title, info: String
    let proteins, fats, carbohydrates: Double
    let kcal: Int
    let photo: URL
    let sourceObject: SourceObject

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case foodID = "foodId"
        case title, info, proteins, fats, carbohydrates, kcal, photo, sourceObject
    }
    // TODO: - Fix here
    func getConventionalProduct() -> Product? {
//        guard let productDTO = ProductDTO(from: self) else {
            return nil
//        }
//        return Product(productDTO)
    }
}

// MARK: - SourceObject
struct SourceObject: Codable {
    let id: Int
        let barcode: String?
        let title: String
        let info, ingredients: String?
        let compB, compZh, compU: Double
        let kkal: Int
        let kkalJoules: Int?
        let quantity, weight: Int
        let photo: String?
        let isAutocreated: Int
        let isOpenfoodfacts: Int?
        let isEan, isNutritionix: Int
        let nutriscoreScore: Double?
        let vitaminA100G, vitaminD100G, vitaminC100G: String?
        let vitaminK100G, vitaminB1100G: Double?
        let calcium100G, sugars100G, salt100G, fiber100G: String?
        let saturatedFat: Double?
        let unsaturatedFat, transFat: Double?
        let sodium: Double?
        let cholesterol, potassium: Double?
        let sugarAlc: Double?
        let glycemicIndex, iron, magnesium, phosphorus: Double?
        let zinc, copper, manganese: Double?
        let selenium, fluoride: Double?
        let vitB2: Double?
        let vitB3, vitB5, vitB6, vitB7: Double?
        let vitB9, vitB12: Double?
        let vitE: Int?
        let servingType: Int
        let nutritionFactsServing: [String: String?]?
        let nutritionFacts100G: NutritionFacts100G?
        let subCategoryID: Int?
        let subCategoryId2, ketoRating: String?
        let url: String?
        let isBasic, isBasicState, isDished: Int
        let hash: String
        let lang: String
        let isModerated, isDraft: Int
        let tag: String?
        let brand: String?
        let calorizator, fromApp, verified, approvedAutomatically: Int
        let studentID: Int?
        let studentCreatedAt: String?
        let createdAt, updatedAt: String
        let score: Double
        let subCategory: Category?
        let mainCategory: Category
        let categories: [Category]?
        let servings: [SearchServing]
        let tags: [SearchTag]

    enum CodingKeys: String, CodingKey {
        case id, barcode, title, info, ingredients
        case compB = "comp_b"
        case compZh = "comp_zh"
        case compU = "comp_u"
        case kkal
        case kkalJoules = "kkal_joules"
        case quantity, weight, photo
        case isAutocreated = "is_autocreated"
        case isOpenfoodfacts = "is_openfoodfacts"
        case isEan = "is_ean"
        case isNutritionix = "is_nutritionix"
        case nutriscoreScore = "nutriscore_score"
        case vitaminA100G = "vitamin_a_100g"
        case vitaminD100G = "vitamin_d_100g"
        case vitaminC100G = "vitamin_c_100g"
        case vitaminK100G = "vitamin_k_100g"
        case vitaminB1100G = "vitamin_b1_100g"
        case calcium100G = "calcium_100g"
        case sugars100G = "sugars_100g"
        case salt100G = "salt_100g"
        case fiber100G = "fiber_100g"
        case saturatedFat = "saturated_fat"
        case unsaturatedFat = "unsaturated_fat"
        case transFat = "trans_fat"
        case sodium, cholesterol, potassium
        case sugarAlc = "sugar_alc"
        case glycemicIndex = "glycemic_index"
        case iron, magnesium, phosphorus, zinc, copper, manganese, selenium, fluoride
        case vitB2 = "vit_b2"
        case vitB3 = "vit_b3"
        case vitB5 = "vit_b5"
        case vitB6 = "vit_b6"
        case vitB7 = "vit_b7"
        case vitB9 = "vit_b9"
        case vitB12 = "vit_b12"
        case vitE = "vit_e"
        case servingType = "serving_type"
        case nutritionFactsServing = "nutrition_facts_serving"
        case nutritionFacts100G = "nutrition_facts_100g"
        case subCategoryID = "sub_category_id"
        case subCategoryId2 = "sub_category_id2"
        case ketoRating = "keto_rating"
        case url
        case isBasic = "is_basic"
        case isBasicState = "is_basic_state"
        case isDished = "is_dished"
        case hash, lang
        case isModerated = "is_moderated"
        case isDraft = "is_draft"
        case tag, brand
        case calorizator
        case fromApp = "from_app"
        case verified
        case approvedAutomatically = "approved_automatically"
        case studentID = "student_id"
        case studentCreatedAt = "student_created_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case score
        case subCategory = "sub_category"
        case mainCategory = "main_category"
        case categories, servings, tags
    }
}

// MARK: - Category
struct Category: Codable {
    let id, categoryType: Int
    let title: String
    let categoryParentID: Int?
    let categorySubType: Int
    let categoryProductID, servingWeight: Double?
    let isAutocreated: Int
    let hash: String
    let lang: String
    let createdAt, updatedAt: String?
    let pivot: MainCategoryPivot?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryType = "category_type"
        case title
        case categoryParentID = "category_parent_id"
        case categorySubType = "category_sub_type"
        case categoryProductID = "category_product_id"
        case servingWeight = "serving_weight"
        case isAutocreated = "is_autocreated"
        case hash, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pivot
    }
}

// MARK: - MainCategoryPivot
struct MainCategoryPivot: Codable {
    let productID, categoryID: Int

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case categoryID = "category_id"
    }
}

// MARK: - NutritionFacts100G
struct NutritionFacts100G: Codable {
    let kkal: MixedValue?
    
    let vitA: Double?
    let vitC: Double?
    let vitD, vitE: Double?
    let vitK: Int?
    let compB, compU: MixedValue?
    let vitB1, vitB2, vitB3, vitB5: Int?
    let vitB6, vitB7, vitB9: Double?
    let compZh: MixedValue
    let vitB12: Int?

    enum CodingKeys: String, CodingKey {
        case kkal
        case vitA = "vit_a"
        case vitC = "vit_c"
        case vitD = "vit_d"
        case vitE = "vit_e"
        case vitK = "vit_k"
        case compB = "comp_b"
        case compU = "comp_u"
        case vitB1 = "vit_b1"
        case vitB2 = "vit_b2"
        case vitB3 = "vit_b3"
        case vitB5 = "vit_b5"
        case vitB6 = "vit_b6"
        case vitB7 = "vit_b7"
        case vitB9 = "vit_b9"
        case compZh = "comp_zh"
        case vitB12 = "vit_b12"
    }
}

// MARK: - Serving
struct SearchServing: Codable {
    let id, productID: Int
    let title: String
    let unitID, servingWeight: Int?
    let lang: String
    let hash, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title
        case unitID = "unit_id"
        case servingWeight = "serving_weight"
        case lang, hash
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Tag
struct SearchTag: Codable {
    let id: Int
    let tag: String
    let createdAt, updatedAt: String
    let pivot: Pivot

    enum CodingKeys: String, CodingKey {
        case id, tag
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pivot
    }
}

// MARK: - TagPivot
struct Pivot: Codable {
    let productID, tagID: Int

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case tagID = "tag_id"
    }
}

enum MixedValue: Codable {
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(
            MixedValue.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CompB")
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
