//
//  SelectedFoodCellsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.11.2022.
//

import UIKit

protocol SelectedFoodCellsRouterInterface: AnyObject {
    func close()
    func openProductViewController(_ product: Product)
}

class SelectedFoodCellsRouter: NSObject {
    weak var viewController: UIViewController?

    static func setupModule(_ foods: [Food]) -> SelectedFoodCellsViewController {
        let vc = SelectedFoodCellsViewController(foods)
        let router = SelectedFoodCellsRouter()

        vc.router = router
        router.viewController = vc
        return vc
    }
}

extension SelectedFoodCellsRouter: SelectedFoodCellsRouterInterface {
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(product)
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
    func close() {
        viewController?.dismiss(animated: true)
    }
}
