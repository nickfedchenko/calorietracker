//
//  NutritionFactsVM.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import Foundation
import UIKit

struct NutritionFactsVM {
    enum CellType {
        case first
        case second
        case third
        case fourth
        case fifth
    }
    
    private var cells: [(key: Product.ProductKey, type: CellType)] = [
        (key: .protein, type: .first),
        (key: .protein, type: .second),
        (key: .protein, type: .third),
        (key: .protein, type: .fourth),
        (key: .protein, type: .fifth)
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
        
        cell.viewModel = viewModels?[indexPath.row]
        
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
            viewModels.append(
                {
                    switch cell.type {
                    case .first:
                        return getModelTypeFirst(cell.key)
                    case .second:
                        return getModelTypeSecond(cell.key)
                    case .third:
                        return getModelTypeThird(cell.key)
                    case .fourth:
                        return getModelTypeFourth(cell.key)
                    case .fifth:
                        return getModelTypeFifth(cell.key)
                    }
                }()
            )
        }
        
        self.viewModels = viewModels
    }
}

extension NutritionFactsVM {
    private func getModelTypeFirst(_ key: Product.ProductKey) -> NutritionFactsCellVM {
        NutritionFactsCellVM(
            title: product.getTitle(key),
            subtitle: "\(product[key] ?? 0)",
            font: .average,
            cellWidth: .large,
            separatorLineHeight: .large)
    }
    
    private func getModelTypeSecond(_ key: Product.ProductKey) -> NutritionFactsCellVM {
        NutritionFactsCellVM(
            title: product.getTitle(key),
            subtitle: "\(product[key] ?? 0)",
            font: .large,
            cellWidth: .large,
            separatorLineHeight: .average)
    }
    
    private func getModelTypeThird(_ key: Product.ProductKey) -> NutritionFactsCellVM {
        NutritionFactsCellVM(
            title: product.getTitle(key),
            subtitle: "\(product[key] ?? 0)",
            font: .average,
            cellWidth: .large,
            separatorLineHeight: .small)
    }
    
    private func getModelTypeFourth(_ key: Product.ProductKey) -> NutritionFactsCellVM {
        NutritionFactsCellVM(
            title: product.getTitle(key),
            subtitle: "\(product[key] ?? 0)",
            font: .small,
            cellWidth: .average,
            separatorLineHeight: .small)
    }
    
    private func getModelTypeFifth(_ key: Product.ProductKey) -> NutritionFactsCellVM {
        NutritionFactsCellVM(
            title: product.getTitle(key),
            subtitle: "\(product[key] ?? 0)",
            font: .small,
            cellWidth: .small,
            separatorLineHeight: .small)
    }
}

private extension Product {
    enum ProductKey {
        case protein
        case fat
        case carbs
        case kcal
    }
    
    subscript(_ key: ProductKey) -> Double? {
        switch key {
        case .protein:
            return self.protein
        case .fat:
            return self.fat
        case .carbs:
            return self.carbs
        case .kcal:
            return Double(self.kcal)
        }
    }
    
    func getTitle(_ key: ProductKey) -> String {
        switch key {
        case .protein:
            return "Protein"
        case .fat:
            return "Total Fat"
        case .carbs:
            return "Total Carbohydrate"
        case .kcal:
            return "Calories"
        }
    }
}
