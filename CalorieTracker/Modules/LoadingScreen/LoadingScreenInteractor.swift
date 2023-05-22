//
//  LoadingScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.05.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol LoadingScreenInteractorInterface: AnyObject {
    var loadingManager: IncrementalUpdateManager? { get set }
    func prepareLoadingManager()
    func startUpdate()
    
}

class LoadingScreenInteractor {
    weak var presenter: LoadingScreenPresenterInterface?
    var loadingManager: IncrementalUpdateManager?
}

extension LoadingScreenInteractor: LoadingScreenInteractorInterface {
    func prepareLoadingManager() {
        loadingManager?.statusHandler = { [weak self] event in
            self?.presenter?.receivedEventFormLoadingManager(event: event)
        }
    }
    
    func startUpdate() {
        loadingManager?.start()
    }
}
