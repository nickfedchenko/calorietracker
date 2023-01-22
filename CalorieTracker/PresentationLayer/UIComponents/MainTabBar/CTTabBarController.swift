//
//  CTTabBar.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.07.2022.
//

import AsyncDisplayKit
import UIKit

final class CTTabBarController: ASTabBarController {
    private let footer = CTTabBarGradientFooter()
    let blurView = UIVisualEffectView(effect: nil)
    private var blurRadiusDriver: UIViewPropertyAnimator?
    var isTabBarHidden: Bool = false
    var shouldHideBlur = false
    
    enum Constants {
        /// Так как в макете отступ не соответствует отступу SafeAreaInsets.bottom - такое вот полуручное управления пришлось применить
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
            case .h19x430:
                return 32
            case .h19x393:
                return 32
            }
        }()
        
        static var tabBarHeight: CGFloat {
            return 116
        }
    }
    
    private lazy var customTabBar = CTTabBar()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !shouldHideBlur else { return }
        reinitBlurView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.removeFromSuperview()
        customTabBar.delegate = self
        setupSubviews()
        let viewControllers = customTabBar.tabItems.map { $0.configuration.viewControler }
        setViewControllers(viewControllers, animated: false)
    }
    
    func hideTabBar() {
        blurView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(116)
            make.top.equalTo(view.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        isTabBarHidden = true
    }
    
    func showTabBar() {
        blurView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(116.fitH)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        isTabBarHidden = false
    }
    
    func makeBlurTransperent() {
        blurView.effect = nil
        footer.alpha = 0
        shouldHideBlur = true
    }
    
    func restoreBlur() {
        shouldHideBlur = false
        reinitBlurView()
        footer.alpha = 1
    }
    
    private func setupSubviews() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(footer)
        blurView.contentView.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
        
        blurView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(110.fitH)
        }
        
        footer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
        blurRadiusDriver?.fractionComplete = 0.1
    }
}

extension CTTabBarController: CTTabBarDelegate {
    func tabSelected(at index: Int) {
        selectedIndex = index
    }
    
    
}
