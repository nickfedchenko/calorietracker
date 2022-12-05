//
//  CalendarFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.12.2022.
//

import UIKit

protocol CalendarFullWidgetViewInterface: AnyObject {
    
}

final class CalendarFullWidgetView: UIView, CTWidgetFullProtocol {
    var didTapCloseButton: (() -> Void)?
    
    private var presenter: CalendarFullWidgetPresenterInterface?
    
    private lazy var calendarView: CalendarView = getCalendarView()
    private lazy var dateLabel: UILabel = getDateLabel()
    private lazy var leftButton: UIButton = getLeftButton()
    private lazy var rightButton: UIButton = getRightButton()
    private lazy var headerView: UIView = getHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.presenter = CalendarFullWidgetPresenter(view: self)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
    }
    
    private func setupConstraints() {
        addSubviews(headerView, calendarView)
        headerView.addSubviews(leftButton, dateLabel, rightButton)
        
        headerView.aspectRatio(0.147)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        leftButton.aspectRatio()
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        rightButton.aspectRatio()
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
            make.top.lessThanOrEqualTo(headerView.snp.bottom)
        }
    }
    
    @objc private func didTapLeftButton() {
        
    }
    
    @objc private func didTapRightButton() {
        
    }
}

extension CalendarFullWidgetView: CalendarFullWidgetViewInterface {
    
}

// MARK: - Factory

extension CalendarFullWidgetView {
    func getCalendarView() -> CalendarView {
        return CalendarView(baseDate: Date()) { _ in
            
        }
    }
    
    func getDateLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.sfProDisplaySemibold(size: 18)
        return label
    }
    
    func getLeftButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.leftChevron(), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        return button
    }
    
    func getRightButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.rightChevron(), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        return button
    }
    
    func getHeaderView() -> ViewWithShadow {
        let view = ViewWithShadow(Const.headerShadows)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 16
        view.backgroundColor = R.color.calendarWidget.header()
        return view
    }
}

extension CalendarFullWidgetView {
    struct Const {
        static let headerShadows: [Shadow] = [
            .init(
                color: R.color.calendarWidget.shadowFirst() ?? .black,
                opacity: 0.45,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            .init(
                color: R.color.calendarWidget.shadowSecond() ?? .black,
                opacity: 0.3,
                offset: CGSize(width: 0, height: 4),
                radius: 16
            )
        ]
    }
}
