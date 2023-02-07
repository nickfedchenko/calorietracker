//
//  ScannerRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.11.2022.
//

import UIKit

protocol ScannerRouterInterface: AnyObject {
    func close()
    func barCodeSuccessfullyRecognized(barcode: String)
}

class ScannerRouter: NSObject {
    weak var viewController: UIViewController?
    var foundBarCodeHandler: ((String) -> Void)?

    static func setupModule(foundBarcodeHandler: ((String) -> Void)? = nil) -> ScannerViewController {
        let vc = ScannerViewController()
        let router = ScannerRouter()
        router.foundBarCodeHandler = foundBarcodeHandler
        vc.router = router
        router.foundBarCodeHandler = foundBarcodeHandler
        router.viewController = vc
        return vc
    }
}

extension ScannerRouter: ScannerRouterInterface {
    
    func barCodeSuccessfullyRecognized(barcode: String) {
        close()
        foundBarCodeHandler?(barcode)
    }
    
    func close() {
        viewController?.dismiss(animated: true)
    }
}
