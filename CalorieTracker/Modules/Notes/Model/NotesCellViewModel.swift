//
//  NotesCellViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

struct NotesCellViewModel {
    let note: Note
    let estimation: Estimation?
    let text: String
    let date: Date
    let weight: Double
    let image: UIImage?
}
