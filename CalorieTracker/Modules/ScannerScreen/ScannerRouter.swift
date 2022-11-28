//
//  ScannerRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.11.2022.
//

import UIKit

protocol ScannerRouterInterface: AnyObject {
    func close()
    func openProductViewController(_ product: Product)
}

class ScannerRouter: NSObject {
    weak var viewController: UIViewController?

    static func setupModule() -> ScannerViewController {
        let vc = ScannerViewController()
        let router = ScannerRouter()

        vc.router = router
        router.viewController = vc
        return vc
    }
}

extension ScannerRouter: ScannerRouterInterface {
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(product)
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
    func close() {
        viewController?.dismiss(animated: true)
    }
}
