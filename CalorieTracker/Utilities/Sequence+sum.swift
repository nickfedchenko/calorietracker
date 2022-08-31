//
//  Sequence+sum.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.08.2022.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
