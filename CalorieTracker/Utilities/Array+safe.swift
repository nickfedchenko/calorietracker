//
//  Array+safe.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.11.2022.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
