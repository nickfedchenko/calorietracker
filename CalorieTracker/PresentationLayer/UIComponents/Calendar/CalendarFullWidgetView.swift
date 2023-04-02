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
    var didChangeSelectedDate: ((Date) -> Void)?
    
    var didTapCloseButton: (() -> Void)?
    var date: Date? {
        didSet {
            UDM.currentlyWorkingDay = Day(date ?? Date())
        }
    }
    
    private var presenter: CalendarFullWidgetPresenterInterface?
    
    private lazy var calendarView: CalendarView = getCalendarView()
    private lazy var dateLabel: UILabel = getDateLabel()
    private lazy var leftButton: UIButton = getLeftButton()
    private lazy var rightButton: UIButton = getRightButton()
    private lazy var headerView: UIView = getHeaderView()
    private lazy var dateFormatter: DateFormatter = getDateFormatter()
    private lazy var dismissChevron: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.foodViewing.topChevronOriginal(), for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.didTapCloseButton?()
        },
            for: .touchUpInside
        )
        return button
    }()
    
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
        
        updateDateLabel(UDM.currentlyWorkingDay.date ?? Date())
        
        calendarView.dateDataCompletion = { date in
            return CalendarWidgetService.shared.getCalendarData(year: date.year, month: date.month)
        }
        
        calendarView.didChangeDate = { [weak self] date in
            Vibration.selection.vibrate()
            self?.updateDateLabel(date)
            self?.didChangeSelectedDate?(date)
            if date.day == Date().day {
                LoggingService.postEvent(event: .calcurrentdate)
            }
        }
    }
    
    private func setupConstraints() {
        addSubviews(headerView, calendarView, dismissChevron)
        headerView.addSubviews(leftButton, dateLabel, rightButton)
        
       
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(56)
        }
        
//        leftButton.aspectRatio()
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
//        rightButton.aspectRatio()
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        dismissChevron.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(64)
//            make.top.equalTo(calendarView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func updateDateLabel(_ date: Date) {
        let todayDate = Date()
        let todayComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: todayDate
        )
        var targetComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        targetComponents.hour = todayComponents.hour
        targetComponents.minute = todayComponents.minute
        if todayDate > date {
            targetComponents.second = (todayComponents.second ?? 0) - 1
        } else {
            targetComponents.second = (todayComponents.second ?? 0) + 1
        }
        let targetDate = Calendar.current.date(from: targetComponents)
        switch Calendar.current.dateComponents([.day], from: todayDate, to: targetDate ?? Date()).day ?? 0 {
        case 0:
            dateLabel.text = R.string.localizable.calendarTopTitleToday()
        case -1:
            dateLabel.text = R.string.localizable.calendarTopTitleYesterday()
        case 1:
            dateLabel.text = R.string.localizable.calendarTomorrow()
        case 365...:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL, YYYY"
            dateLabel.text = dateFormatter.string(from: date).uppercased()
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            dateLabel.text = dateFormatter.string(from: date).uppercased()
        }
    }
    
    @objc private func didTapLeftButton() {
        Vibration.rigid.vibrate()
//        calendarView.didSwipeRight()
        calendarView.didTapLeftButton()
    }
    
    @objc private func didTapRightButton() {
        Vibration.rigid.vibrate()
//        calendarView.didSwipeLeft()
        calendarView.didTapRightButton()
    }
}

extension CalendarFullWidgetView: CalendarFullWidgetViewInterface {
    
}

// MARK: - Factory

extension CalendarFullWidgetView {
    func getCalendarView() -> CalendarView {
        return CalendarView(baseDate: UDM.currentlyWorkingDay.date ?? Date()) { date in
            self.date = date
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
    
    func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
}

extension CalendarFullWidgetView {
    struct Const {
        static let headerShadows: [Shadow] = [
            .init(
                color: R.color.calendarWidget.shadowFirst() ?? .black,
                opacity: 0.45,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2,
                spread: 0
            ),
            .init(
                color: R.color.calendarWidget.shadowSecond() ?? .black,
                opacity: 0.3,
                offset: CGSize(width: 0, height: 4),
                radius: 16,
                spread: 0
            )
        ]
    }
}

extension CalendarFullWidgetView: TransitionAnimationReady {
    func prepareForAppearing(with anchorSnapshot: UIView?) {
        headerView.alpha = 0
        calendarView.alpha = 0
        dismissChevron.alpha = 0
        addSubview(anchorSnapshot ?? UIView())
        anchorSnapshot?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    func animateAppearingFirstStage(targetFrame: CGRect, completion: @escaping () -> Void) {
        guard let snapshot = subviews.last else { return }
     
        snapshot.alpha = 0
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
      
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.4
        ) {
            self.frame = targetFrame
            self.layoutIfNeeded()
            self.headerView.alpha = 1
            self.calendarView.alpha = 1
            self.dismissChevron.alpha = 1
            self.calendarView.collectionView.reloadSections(IndexSet(integer: 0))
            
//            self.calendarView.setNeedsLayout()
//            self.calendarView.layoutIfNeeded()
         
        } completion: { _ in
            snapshot.removeFromSuperview()
            completion()
        }
        CATransaction.commit()
    }
    
    func prepareForDisappearing() {
        layoutIfNeeded()
    }
    
    
    func animateDisappearing(targetFrame: CGRect, completion: @escaping () -> Void) {
        calendarView.snp.removeConstraints()
        leftButton.snp.removeConstraints()
        rightButton.snp.removeConstraints()
        headerView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(36)
        }
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.4
        ) {
            self.frame = targetFrame
            self.layoutIfNeeded()
            self.calendarView.alpha = 0
            self.leftButton.alpha = 0
            self.rightButton.alpha = 0
            self.dismissChevron.alpha = 0
            self.headerView.alpha = 0
            self.backgroundColor = .clear
//            self.calendarView.setNeedsLayout()
//            self.calendarView.layoutIfNeeded()
         
        } completion: { _ in
            completion()
        }

    }
}
