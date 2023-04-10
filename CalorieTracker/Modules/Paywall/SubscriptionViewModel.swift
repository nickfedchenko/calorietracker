//
//  SubscriptionViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.12.2022.
//

import ApphudSDK
import Foundation

final class SubscriptionViewModel {
    
    enum ExperimentType: String {
        case variant1 = "Variation_1"
        case variant2 = "Variation_2"
    }
    
    // MARK: - Property list
    private var products: [ApphudProduct] = [] {
        didSet {
            reloadHandler?(experimentType)
        }
    }
    var reloadHandler: ((ExperimentType?) -> Void)?
    var selectedIndex = 0
    var shouldPerformExperiment: Bool = true
    var targetPaywall: ApphudPaywall?
    var experimentType: ExperimentType? {
        if
            let paywall = targetPaywall,
            paywall.experimentName != nil {
            return .init(rawValue: paywall.variationName ?? "")
        } else {
            return nil
        }
    }
    // MARK: - Publick methods
    
    func loadProducts() {
        Apphud.paywallsDidLoadCallback { [weak self] paywalls in
            
            guard
                let paywall = paywalls.first(where: { $0.identifier == "Main" }),
                let products = paywalls.first(where: { $0.identifier == "Main" })?.products	 else { return }
            self?.targetPaywall = paywall
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
        if shouldPerformExperiment,
        let experimentType = experimentType {
            let product = products[indexPath.item]
            let periodTitle = makePeriodStirng(for: product)
            let priceString = makePriceString(for: product)
            let weeklyPriceString = (experimentType == .variant2 ? "Try 3 days for free, then  ".localized : "" )
            + makeWeeklyPrice(for: product)
            return .init(
                title: "\(periodTitle)",
                describe: weeklyPriceString,
                priceString: priceString
            )
        } else {
            guard !products.isEmpty else {
                return .init(title: "Loading info".localized, describe: nil, priceString: "")
            }
            let product = products[indexPath.item]
            let periodTitle = makePeriodStirng(for: product)
            let priceString = makePriceString(for: product)
            let weeklyPriceString = makeWeeklyPrice(for: product)
            return .init(
                title: "\(periodTitle)",
                describe: weeklyPriceString,
                priceString: priceString
            )
        }
    }
    
    private func makePeriodStirng(for product: ApphudProduct) -> String {
        guard let skProduct = product.skProduct else {
            return "Loading info".localized
        }
        switch skProduct.subscriptionPeriod?.unit {
        case .year:
            return R.string.localizable.yearlySubscription()
        case .month:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                return R.string.localizable.monthlySubscription()
            } else {
                return "Error fetching payment info"
            }
        case .day:
            if skProduct.subscriptionPeriod?.numberOfUnits == 7 {
                return R.string.localizable.weeklySubscription()
            } else {
                return "Error fetching payment info"
            }
        case .week:
            if skProduct.subscriptionPeriod?.numberOfUnits == 1 {
                return R.string.localizable.weeklySubscription()
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
