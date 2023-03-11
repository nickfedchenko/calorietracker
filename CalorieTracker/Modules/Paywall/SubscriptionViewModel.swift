//
//  SubscriptionViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.12.2022.
//

import ApphudSDK
import Foundation

final class SubscriptionViewModel {
    
    // MARK: - Property list
    private var products: [ApphudProduct] = [] {
        didSet {
            reloadHandler?()
        }
    }
    var reloadHandler: (() -> Void)?
    var selectedIndex = 0
    
    // MARK: - Publick methods
    
    func loadProducts() {
        Apphud.paywallsDidLoadCallback { [weak self] paywalls in
            guard let products = paywalls.first?.products	 else { return }
            self?.products = products.reversed()
        }
    }
    
    func getProductToPurchase() -> ApphudProduct? {
        return products[safe: selectedIndex]
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func makeModelForProduct(at indexPath: IndexPath) -> SubscriptionAmountModel {
        guard !products.isEmpty else {
            return .init(title: "Loading info".localized, describe: nil)
        }
        let product = products[indexPath.item]
        let periodTitle = makePeriodStirng(for: product)
        let priceString = makePriceString(for: product)
        let weeklyPriceString = makeWeeklyPrice(for: product)
        return .init(
            title: "\(periodTitle) - \(priceString)",
            describe: weeklyPriceString
        )
    }
    
    private func makePeriodStirng(for product: ApphudProduct) -> String {
        guard let skProduct = product.skProduct else {
            return "Loading info".localized
        }
        switch skProduct.subscriptionPeriod?.unit {
        case .year:
            return "Annualy".localized
        case .month:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                return R.string.localizable.monthly().lowercased().capitalized
            } else {
                return "Error fetching payment info"
            }
        case .day:
            if skProduct.subscriptionPeriod?.numberOfUnits == 7 {
                return R.string.localizable.weekly().lowercased().capitalized
            } else {
                return "Error fetching payment info"
            }
        case .week:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                return R.string.localizable.weekly().lowercased().capitalized
            } else {
                return "Error fetching payment info"
            }
        default:
            return "Error fetching payment info"
        }
    }
    
    private func makePriceString(for product: ApphudProduct) -> String {
        guard
            let skProduct = product.skProduct,
            let currencySymbol = skProduct.priceLocale.currencySymbol
        else {
            return ""
        }
        let price = skProduct.price.doubleValue
        
        let shouldTruncate = price.truncatingRemainder(dividingBy: 1) > 0 ? false : true
        let priceString = currencySymbol + (
            shouldTruncate
                ? String(format: "%.0f", price)
                : String(format: "%.2f", price)
        )
        return priceString
    }
    
    private func makeWeeklyPrice(for product: ApphudProduct) -> String {
        guard
            let skProduct = product.skProduct,
            let currencySymbol = skProduct.priceLocale.currencySymbol
        else {
            return ""
        }
        let price = skProduct.price.doubleValue
        var string = ""
        var weeklyPrice: Double = 0
        switch skProduct.subscriptionPeriod?.unit {
        case .year:
            weeklyPrice = price / 52
        case .day:
            if skProduct.subscriptionPeriod?.numberOfUnits == 7 {
                weeklyPrice = price
            }
        case .week:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                weeklyPrice = price
            }
        case .month:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                weeklyPrice = price / 4.34
            }
        default:
           return ""
        }
        
        let shouldTruncate = weeklyPrice.truncatingRemainder(dividingBy: 1) > 0 ? false : true
        string = currencySymbol + (
            shouldTruncate
                ? String(format: "%.0f", weeklyPrice)
                : String(format: "%.2f", weeklyPrice)
        )
        string += " - \("week".localized)"
        return string
    }
}
