//
//  CTTabBar.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.07.2022.
//

import AsyncDisplayKit
import UIKit

protocol CTTabBarDelegate: AnyObject {
    func tabSelected(at index: Int)
}

final class CTTabBar: UIView {
    
    // MARK: - Constants
    enum Constants {
        static let tabSpacing: CGFloat = (UIScreen.main.bounds.width - 40 - CGFloat(3 * 64)) / CGFloat(3 + 1)
        static let itemHeight: CGFloat = 64
        static let tabBarHeight: CGFloat = CTTabBarController.Constants.bottomInset + itemHeight
    }
    
    // MARK: - Public properties
    lazy var tabItems: [CTTabItem] = CTTabItem.CTTabConfiguration.allCases
        .map { CTTabItem(with: $0) }
    
    var isFirstLayout = true
    weak var delegate: CTTabBarDelegate?
    
    // MARK: - Private properties
    private let leftBackground: GradientBackgroundView = {
        let view = GradientBackgroundView(direction: .left)
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let rightBackground: GradientBackgroundView = {
        let view = GradientBackgroundView(direction: .right)
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private lazy var HStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        let spacing = Constants.tabSpacing
        stackView.spacing = spacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setTags()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateGradients() {
        leftBackground.layer.sublayers?.removeAll()
        let leftGradient = CAGradientLayer()
        leftGradient.colors = [UIColor.blue, UIColor.white].compactMap { $0.cgColor }
        leftGradient.startPoint = CGPoint(x: 0.85, y: 0.5)
        leftGradient.endPoint = CGPoint(x: 1, y: 0.5)
        leftGradient.locations = [0, 1]
        leftGradient.frame = leftBackground.bounds
        leftBackground.layer.addSublayer(leftGradient)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstLayout else { return }
        tabSelected(at: 0)
        isFirstLayout = false
    }
    
    // MARK: - Private methods
    private func setTags() {
        tabItems.enumerated().forEach { index, view in
            view.tag = index
            view.delegate = self
        }
    }
    
    private func setupSubviews() {
        addSubview(leftBackground)
        addSubview(rightBackground)
        addSubview(HStack)
        
        tabItems.forEach {
            $0.aspectRatio()
            HStack.addArrangedSubview($0)
        }
        
        HStack.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20 + Constants.tabSpacing)
        }
        
        rightBackground.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(tabItems[0].snp.trailing)
            make.top.bottom.equalToSuperview()
        }

        leftBackground.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.itemHeight)
        }
    }
}

// MARK: - CTTabItemDelegate
extension CTTabBar: CTTabItemDelegate {
    func tabSelected(at index: Int) {
        delegate?.tabSelected(at: index)
        updateBackground(for: index)
        tabItems.enumerated().forEach { viewIndex, view in
            if index == viewIndex {
                view.isSelected = true
            } else {
                if view.isSelected == false {
                    return
                } else {
                view.isSelected = false
                }
            }
        }
    }
    
    private func updateBackground(for selectedIndex: Int) {
    
        leftBackground.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            if selectedIndex != 0 {
            make.trailing.equalTo(tabItems[selectedIndex].snp.leading)
            } else {
                make.trailing.equalTo(leftBackground.snp.leading)
            }
        }

        rightBackground.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            if selectedIndex != 2 {
            make.leading.equalTo(tabItems[selectedIndex].snp.trailing)
            } else {
                make.leading.equalTo(rightBackground.snp.trailing)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
