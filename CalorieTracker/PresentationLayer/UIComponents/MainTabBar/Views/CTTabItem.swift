//
//  CTTabItem.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.07.2022.
//

import AsyncDisplayKit
import Lottie

protocol CTTabItemDelegate: AnyObject {
    func tabSelected(at index: Int)
}

final class CTTabItem: UIView {
    /// Configuration enum
    enum CTTabConfiguration: CaseIterable {
        case myDay, progress, food // cook
        
        var animationName: String {
            switch self {
            case .myDay:
                return R.file.myDayJson()?.relativePath ?? ""
            case .progress:
                return R.file.progressJson()?.relativePath ?? ""
            case .food:
                return R.file.foodJson()?.relativePath ?? ""
                //            case .cook:
                //
            }
        }
        
        var title: String {
            switch self {
            case .myDay:
                return "MY DAY"
            case .progress:
                return "PROGRESS"
            case .food:
                return "FOOD"
                //            case .cook:
                //                return "COOK"
            }
        }
        
        var viewControler: UIViewController {
            switch self {
            case .myDay:
                return MainScreenRouter.setupModule()
            case .progress:
                return ProgressRouter.setupModule()
            case .food:
                return RecipesScreenRouter.setupModule()
            }
        }
    }
    
    // MARK: - Private properties
    private(set) var configuration: CTTabConfiguration
    
    private let iconView = LottieAnimationView()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 11.fontScale())
        label.textColor = R.color.tabTitleTextColor()
        return label
    }()
    
    // MARK: - Public properties
    weak var delegate: CTTabItemDelegate?
    
    var isSelected: Bool = false {
        
        didSet {
            if isSelected {
                
                UIView.animate(withDuration: 0.2) {
                    self.title.alpha = 0
                } completion: { _ in
                    self.iconView.play(toProgress: 1)
                }
            } else {
                iconView.play(fromProgress: 1, toProgress: 0, loopMode: nil) { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.title.alpha = 1
                    }
                }
            }
        }
    }
    
    // MARK: - Init
    init(with configuration: CTTabConfiguration) {
        self.configuration = configuration
        iconView.contentMode = .scaleAspectFill
        iconView.contentScaleFactor = 1
        iconView.animationSpeed = 3.2
        super.init(frame: .zero)
        setupSubviews()
        setupGestureRecognizer()
        iconView.animation = .filepath(configuration.animationName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupGestureRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSelection)))
    }
    
    private func setupSubviews() {
        addSubview(iconView)
        addSubview(title)
        //        iconImage.image = configuration.stateAnimations.deselected
        title.attributedText = NSAttributedString(string: configuration.title)
        
        snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(CTTabBar.Constants.itemHeight)
            make.top.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.bottom.equalTo(iconView).inset(6)
            make.centerX.equalTo(iconView)
        }
    }
    
    @objc private func toggleSelection() {
        delegate?.tabSelected(at: tag)
    }
}
