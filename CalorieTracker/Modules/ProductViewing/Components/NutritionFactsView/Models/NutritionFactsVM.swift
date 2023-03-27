//
//  NutritionFactsVM.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

// swiftlint:disable: nesting
struct NutritionFactsVM {
    enum CellType {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
        case seventh
        
        struct CellConfigure {
            let font: NutritionFactsCellVM.CellFont
            let separator: NutritionFactsCellVM.SeparatorLineHeight
            let cellWidth: NutritionFactsCellVM.CellWidth
        }
        
        func getConfiguration() -> CellConfigure {
            switch self {
            case .first:
                return .init(font: .average, separator: .large, cellWidth: .large)
            case .second:
                return .init(font: .large, separator: .average, cellWidth: .large)
            case .third:
                return .init(font: .average, separator: .small, cellWidth: .large)
            case .fourth:
                return .init(font: .small, separator: .small, cellWidth: .average)
            case .fifth:
                return .init(font: .small, separator: .small, cellWidth: .small)
            case .sixth:
                return .init(font: .small, separator: .small, cellWidth: .large)
            case .seventh:
                return .init(font: .small, separator: .none, cellWidth: .large)
            }
        }
    }
    
    private struct CellModel {
        let key: Product.ProductKey
        let type: CellType
    }
    
    private var cells: [CellModel] = [
        .init(key: .kcal, type: .second),
        .init(key: .totalFat, type: .third),
        .init(key: .saturatedFat, type: .fourth),
        .init(key: .transFat, type: .fourth),
        .init(key: .polyFat, type: .fourth),
        .init(key: .monoFat, type: .fourth),
        .init(key: .cholesterol, type: .third),
        .init(key: .sodium, type: .third),
        .init(key: .totalCarbs, type: .third),
        .init(key: .dietaryFiber, type: .fourth),
        .init(key: .totalSugar, type: .fourth),
        .init(key: .inAddSugar, type: .fifth),
        .init(key: .sugarAlc, type: .fifth),
        .init(key: .protein, type: .first),
        .init(key: .vitaminD, type: .sixth),
        .init(key: .calcium, type: .sixth),
        .init(key: .iron, type: .sixth),
        .init(key: .potassium, type: .sixth),
        .init(key: .vitaminA, type: .sixth),
        .init(key: .vitaminC, type: .seventh)
    ]
    
    private(set) var viewModels: [NutritionFactsCellVM]?
    let product: Product
    
    init(_ product: Product) {
        self.product = product
        setupViewModels()
    }
    
    func getCell(_ collectionView: UICollectionView,
                 indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NutritionFactsCollectionViewCell = collectionView
            .dequeueReusableCell(for: indexPath)
        let viewModel = viewModels?[indexPath.row]
        cell.viewModel = viewModel
        
        return cell
    }
    
    func getCellSize(_ width: CGFloat, indexPath: IndexPath) -> CGSize {
        guard let cellWidth = viewModels?[safe: indexPath.row]?.cellWidth else { return .zero }
        let height: CGFloat = 36.0
        let newWidth = width * cellWidth.rawValue
        
        return CGSize(width: newWidth, height: height)
    }
    
    private mutating func setupViewModels() {
        var viewModels: [NutritionFactsCellVM] = []
        
        cells.forEach { cell in
            viewModels.append(getModel(cell))
        }
        
        self.viewModels = viewModels
    }
}

extension NutritionFactsVM {
    private func getModel(_ model: CellModel) -> NutritionFactsCellVM {
        let configuration = model.type.getConfiguration()
        return NutritionFactsCellVM(
            title: product.getTitle(model.key),
            subtitle: {
                guard let value = product[model.key] else {
                    return "-"
                }
                let suffix =  {
                    switch model.key {
                    case .totalFat, .saturatedFat, .polyFat, .monoFat, .totalCarbs, .dietaryFiber, .netCarbs,
                            .totalSugar, .inAddSugar, .sugarAlc, .protein:
                        return BAMeasurement.measurmentSuffix(.serving)
                    case .transFat, .vitaminD, .vitaminA:
                        return BAMeasurement.measurmentSuffix(.microNutrients)
                    default:
                        return BAMeasurement.measurmentSuffix(.milliNutrients)
                    }
                }()
                let targetValueString = value.removeZerosFromEnd()
                return targetValueString + " \(suffix)"
            }(),
            font: configuration.font,
            cellWidth: configuration.cellWidth,
            separatorLineHeight: configuration.separator
        )
    }
}

private extension Product {
    enum ProductKey {
      
        case totalFat
        case saturatedFat
        case transFat
        case polyFat
        case monoFat
        case cholesterol
        case sodium
        case totalCarbs
        case dietaryFiber
        case netCarbs
        case totalSugar
        case inAddSugar
        case sugarAlc
        case kcal
        case protein
        case vitaminD
        case calcium
        case iron
        case potassium
        case vitaminA
        case vitaminC
    }
    
    subscript(_ key: ProductKey) -> Double? {
        switch key {
        case .protein:
            return self.protein
        case .totalFat:
            return self.fat
        case .totalCarbs:
            return self.composition?.totalCarbs
        case .kcal:
            return Double(self.kcal)
        case .cholesterol:
            return self.composition?.cholesterol
        case .saturatedFat:
            return self.composition?.saturatedFat
        case .transFat:
            return self.composition?.transFat
        case .polyFat:
            return self.composition?.polyUnsatFat
        case .monoFat:
            return self.composition?.monoUnsatFat
        case .dietaryFiber:
            return self.composition?.diataryFiber
        case .totalSugar:
            return self.composition?.totalSugars
        case .inAddSugar:
            return self.composition?.inclAddedSugars
        case .sodium:
            return self.composition?.sodium
        case .vitaminD:
            return self.composition?.vitaminD
        case .calcium:
            return self.composition?.calcium
        case .iron:
            return self.composition?.iron
        case .potassium:
            return self.composition?.potassium
        case .vitaminA:
            return self.composition?.vitaminA
        case .vitaminC:
            return self.composition?.vitaminC
        case .sugarAlc:
            return composition?.sugarAlc
        case .netCarbs:
            return composition?.netCarbs
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func getTitle(_ key: ProductKey) -> String {
        switch key {
        case .protein:
            return R.string.localizable.protein()
        case .totalFat:
            return R.string.localizable.fat()
        case .totalCarbs:
            return R.string.localizable.carb()
        case .kcal:
            return R.string.localizable.kcal()
        case .cholesterol:
            return R.string.localizable.choleterol()
        case .saturatedFat:
            return R.string.localizable.satFat()
        case .transFat:
            return R.string.localizable.transFat()
        case .polyFat:
            return R.string.localizable.polyFat()
        case .monoFat:
            return R.string.localizable.monoFat()
        case .dietaryFiber:
            return R.string.localizable.dietaryFiber()
        case .totalSugar:
            return R.string.localizable.sugars()
        case .inAddSugar:
            return R.string.localizable.addSugars()
        case .sodium:
            return R.string.localizable.sodium()
        case .vitaminD:
            return R.string.localizable.vitaminD()
        case .calcium:
            return R.string.localizable.calcium()
        case .iron:
            return R.string.localizable.iron()
        case .potassium:
            return R.string.localizable.potassium()
        case .vitaminA:
            return R.string.localizable.vitaminA()
        case .vitaminC:
            return R.string.localizable.vitaminC()
        case .sugarAlc:
            return R.string.localizable.sugarAlco()
        case .netCarbs:
            return R.string.localizable.netCarbs()
        }
    }
}
