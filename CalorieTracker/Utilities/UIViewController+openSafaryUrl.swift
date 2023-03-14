//
//  UIViewController+openSafaryUrl.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 26.12.2022.
//

import ApphudSDK
import SafariServices
import UIKit

extension UIViewController {
    func openSafaryUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let safaryVC = SFSafariViewController(url: url)
        self.present(safaryVC, animated: true)
    }
    
    
    var hasActiveSubscription: Bool {
        Apphud.hasActiveSubscription()
    }
}
