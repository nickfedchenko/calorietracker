//
//  CTTabBar.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.07.2022.
//

import AsyncDisplayKit
import UIKit

final class CTTabBarController: ASTabBarController {
    enum Constants {
        static let bottomInset: CGFloat = {
            switch UIDevice.screenType {
            case .h19x414:
                return 32
            case .h19x428:
                return 32
            case .h19x375:
                return 26
            case .h19x390:
                return 32
            case .h16x414:
                return 0
            case .h16x375:
                return 0
            case .unknown:
                return 0
            }
        }()
    }
    
    private lazy var customTabBar = CTTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.removeFromSuperview()
        customTabBar.delegate = self
        setupSubviews()
        print("current frame is \(view.frame)")
    }
    
    private func setupSubviews() {
        view.addSubview(customTabBar)
        
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }
}

extension CTTabBarController: CTTabBarDelegate {
    func tabSelected(at index: Int) {
        selectedIndex = index
    }
}
