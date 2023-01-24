//
//  NotesRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 04.01.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol NotesRouterInterface: AnyObject {
    func closeViewController()
    func openNotesViewingVC(_ model: NotesCellViewModel)
}

class NotesRouter: NSObject {

    weak var presenter: NotesPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> NotesViewController {
        let vc = NotesViewController()
        let interactor = NotesInteractor()
        let router = NotesRouter()
        let presenter = NotesPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension NotesRouter: NotesRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func openNotesViewingVC(_ model: NotesCellViewModel) {
        let vc = NotesViewingViewController()
        vc.viewModel = model
        vc.needUpdate = { [weak self] in
            self?.presenter?.updateNotes()
        }
        viewController?.present(vc, animated: true)
    }
}
