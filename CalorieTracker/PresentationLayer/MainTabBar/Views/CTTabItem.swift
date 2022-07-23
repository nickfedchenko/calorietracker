//
//  CTTabItem.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.07.2022.
//

import AsyncDisplayKit

protocol CTTabItemDelegate: AnyObject {
    func tabSelected(at index: Int)
}

final class CTTabItem: UIView {
    enum CTTabConfiguration: CaseIterable {
        case myDay, progress, food // cook
        
        var stateImages: (selected: UIImage?, deselected: UIImage?) {
            switch self {
            case .myDay:
                return (R.image.myDaySelected(), R.image.myDayDeselected())
            case .progress:
                return (R.image.progressSelected(), R.image.progressDeselected())
            case .food:
                return (R.image.foodSelected(), R.image.foodDeselected())
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
                return MainScreenViewController()
            case .progress:
                return MainScreenViewController()
            case .food:
                return MainScreenViewController()
            }
        }
    }
    
    let configuration: CTTabConfiguration
    weak var delegate: CTTabItemDelegate?
    
    let iconImage = UIImageView()
    let title: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 11)
        label.textColor = R.color.tabTitleTextColor()
        return label
    }()
    
    var isSelected: Bool = false {
        didSet {
          let transition = CATransition()
            transition.duration = 0.1
            transition.type = .fade
            transition.subtype = .fromBottom
                self.iconImage.image = self.isSelected
                ? self.configuration.stateImages.selected
                : self.configuration.stateImages.deselected
            iconImage.layer.add(transition, forKey: nil)
            if isSelected {
                self.iconImage.snp.remakeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
                UIView.animate(withDuration: 0.1) {
                    self.title.alpha = 0
                    self.layoutIfNeeded()
                }
            } else {
                self.iconImage.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(7)
                }
                UIView.animate(withDuration: 0.1) {
                    self.title.alpha = 1
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    init(with configuration: CTTabConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupSubviews()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGestureRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSelection)))
    }
    
    private func setupSubviews() {
        addSubview(iconImage)
        addSubview(title)
        iconImage.image = configuration.stateImages.deselected
        title.attributedText = NSAttributedString(string: configuration.title)
        
        snp.makeConstraints { make in
            make.height.width.equalTo(64)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(1)
            make.centerX.equalTo(iconImage)
        }
    }
    
    @objc private func toggleSelection() {
        delegate?.tabSelected(at: tag)
    }
}
