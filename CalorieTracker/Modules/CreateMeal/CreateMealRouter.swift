//
//  CreateMealRouter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation
import UIKit

protocol CreateMealRouterInterface: AnyObject {
    func openAddFoodVC(with searchRequest: String)
}

class CreateMealRouter: NSObject {

    weak var presenter: CreateMealPresenterInterface?
    weak var viewController: UIViewController?
    var didSelectProduct: ((Product) -> Void)?

    static func setupModule() -> CreateMealViewController {
        let vc = CreateMealViewController()
        let interactor = CreateMealInteractor()
        let router = CreateMealRouter()
        let presenter = CreateMealPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        router.viewController = vc
        
        return vc
    }
}

extension CreateMealRouter: CreateMealRouterInterface {
    
    func openAddFoodVC(with searchRequest: String) {
        let vc = AddFoodRouter.setupModule(
            addFoodYCoordinate: UDM.mainScreenAddButtonOriginY,
            tabBarIsHidden: true,
            searchRequest: searchRequest,
            wasFromMealCreateVC: true
        )
        
        vc.didSelectProduct = { [weak self] product in
            self?.presenter?.addProduct(product)
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
}
