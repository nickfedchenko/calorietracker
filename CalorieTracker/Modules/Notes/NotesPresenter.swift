//
//  NotesPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 04.01.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol NotesPresenterInterface: AnyObject {
    func getNotesCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func numberOfItemsInSection() -> Int
    func getSize(_ width: CGFloat) -> CGSize
    func didTapCloseButton()
    func didTapCell(_ indexPath: IndexPath)
    func updateNotes()
}

class NotesPresenter {

    unowned var view: NotesViewControllerInterface
    let router: NotesRouterInterface?
    let interactor: NotesInteractorInterface?
    
    private var notesViewModels: [NotesCellViewModel] = [] {
        didSet {
            view.reload()
        }
    }
    
    init(
        interactor: NotesInteractorInterface,
        router: NotesRouterInterface,
        view: NotesViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func updateNotesViewModel() {
        let notes = DSF.shared.getAllStoredNotes()
        let weightData = WeightWidgetService.shared.getAllWeight()
        
        notesViewModels = notes.map { note in
            NotesCellViewModel(
                estimation: note.estimation,
                text: note.text,
                date: note.date,
                weight: weightData.first(where: { $0.day == Day(note.date) })?.value ?? 0,
                image: {
                    guard let url = note.imageUrl else { return nil }
                    return UIImage(fileURLWithPath: url)
                }()
            )
        }
    }
}

extension NotesPresenter: NotesPresenterInterface {
    func getNotesCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NotesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.viewModel = notesViewModels[safe: indexPath.row]
        return cell
    }
    
    func numberOfItemsInSection() -> Int {
        return notesViewModels.count
    }
    
    func getSize(_ screenWidth: CGFloat) -> CGSize {
        let width = screenWidth - 40
        let height = width * 0.299
        return .init(width: width, height: height)
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func updateNotes() {
        updateNotesViewModel()
    }
    
    func didTapCell(_ indexPath: IndexPath) {
        guard let model = notesViewModels[safe: indexPath.row] else {
            return
        }
        
        router?.openNotesViewingVC(model)
    }
}
