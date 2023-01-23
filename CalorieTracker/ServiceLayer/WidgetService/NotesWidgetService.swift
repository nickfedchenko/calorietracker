//
//  NotesWidgetService.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.01.2023.
//

import Foundation

protocol NotesWidgetServiceInterface {
    func getAllNotes() -> [Note]
    func getLastNote() -> Note?
    func deleteNote(_ note: Note)
}

final class NotesWidgetService {
    static let shared: NotesWidgetServiceInterface = NotesWidgetService()
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension NotesWidgetService: NotesWidgetServiceInterface {
    func getAllNotes() -> [Note] {
        let notes = localDomainService.fetchNotes().sorted(by: { $0.date < $1.date })
        return notes
    }
    
    func getLastNote() -> Note? {
        let notes = localDomainService.fetchNotes().sorted(by: { $0.date < $1.date })
        return notes.last
    }
    
    func deleteNote(_ note: Note) {
        localDomainService.delete(note)
    }
}

