//
//  CreateProductRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 11.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol CreateProductRouterInterface: AnyObject {
    func closeViewController()
    func openScanViewController(_ complition: @escaping (String) -> Void)
    func openProductViewController(_ product: Product)
}

class CreateProductRouter: NSObject {
    
    weak var presenter: CreateProductPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> CreateProductViewController {
        let vc = CreateProductViewController()
        let interactor = CreateProductInteractor()
        let router = CreateProductRouter()
        let presenter = CreateProductPresenter(interactor: interactor, router: router, view: vc)
        
        vc.keyboardManager = KeyboardManager()
        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension CreateProductRouter: CreateProductRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func openScanViewController(_ complition: @escaping (String) -> Void) {
        let vc = ScannerRouter.setupModule()
        vc.modalPresentationStyle = .overFullScreen
        
        vc.complition = { barcode in
            complition(barcode)
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openProductViewController(_ product: Product) {
        let vc = ProductRouter.setupModule(product, .createProduct, .breakfast)
        vc.modalPresentationStyle = .overFullScreen
        
        vc.shouldClose = {
            self.closeViewController()
        }
        
        viewController?.present(vc, animated: true)
    }
}
