//
//  UITableView+.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.01.2023.
//

import UIKit

extension UITableViewCell: ReusableView {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
}
