//
//  WeightsListRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol WeightsListRouterInterface: AnyObject {
    func openEnterWeightController()
}

class WeightsListRouter: NSObject {

    weak var presenter: WeightsListPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> WeightsListViewController {
        let vc = WeightsListViewController()
        let interactor = WeightsListInteractor()
        let router = WeightsListRouter()
        let presenter = WeightsListPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension WeightsListRouter: WeightsListRouterInterface {
    func openEnterWeightController() {
        let vc = KeyboardEnterValueViewController(.weight(.add))
        vc.needUpdate = { [weak self] in
            RateRequestManager.increment(for: .addWeight)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self?.presenter?.updateTableView()
            }
        }
        viewController?.present(vc, animated: true)
    }
}
