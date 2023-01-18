//
//  NotesPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 04.01.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol NotesPresenterInterface: AnyObject {
    func getNotesCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func numberOfItemsInSection() -> Int
    func getHeight(_ screenWidth: CGFloat) -> CGFloat 
    func didTapCloseButton()
    func didTapCell(_ indexPath: IndexPath)
    func updateNotes()
    func deleteNote(_ indexPass: IndexPath)
}

class NotesPresenter {

    unowned var view: NotesViewControllerInterface
    let router: NotesRouterInterface?
    let interactor: NotesInteractorInterface?
    
    private var notesViewModels: [NotesCellViewModel] = []
    private var notes: [Note] = [] {
        didSet {
            updateNotesViewModel()
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
        let weightData = WeightWidgetService.shared.getAllWeight()
        
        notesViewModels = notes.map { note in
            NotesCellViewModel(
                note: note,
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
    
    private func notesUpdate() {
        notes = NotesWidgetService.shared.getAllNotes()
    }
}

extension NotesPresenter: NotesPresenterInterface {
    func getNotesCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: NotesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = notesViewModels[safe: indexPath.row]
        return cell
    }
    
    func numberOfItemsInSection() -> Int {
        return notesViewModels.count
    }
    
    func getHeight(_ screenWidth: CGFloat) -> CGFloat {
        let width = screenWidth - 40
        let height = width * 0.299 + 12
        return height
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func updateNotes() {
        notesUpdate()
        updateNotesViewModel()
        view.reload()
    }
    
    func didTapCell(_ indexPath: IndexPath) {
        guard let model = notesViewModels[safe: indexPath.row] else {
            return
        }
        
        router?.openNotesViewingVC(model)
    }
    
    func deleteNote(_ indexPass: IndexPath) {
        guard let note = notes[safe: indexPass.row] else { return }
        notes.remove(at: indexPass.row)
        DispatchQueue.global().async {
            NotesWidgetService.shared.deleteNote(note)
        }
    }
}
