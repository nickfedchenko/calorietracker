//
//  CreateProductPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 11.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol CreateProductPresenterInterface: AnyObject {
    func didTapCloseButton()
    func didTapScanButton(_ complition: @escaping (String) -> Void)
}

class CreateProductPresenter {
    
    unowned var view: CreateProductViewControllerInterface
    let router: CreateProductRouterInterface?
    let interactor: CreateProductInteractorInterface?
    
    init(
        interactor: CreateProductInteractorInterface,
        router: CreateProductRouterInterface,
        view: CreateProductViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CreateProductPresenter: CreateProductPresenterInterface {
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func didTapScanButton(_ complition: @escaping (String) -> Void) {
        router?.openScanViewController { barcode in
            complition(barcode)
        }
    }
}
