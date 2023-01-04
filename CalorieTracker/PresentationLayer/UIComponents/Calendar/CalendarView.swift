//
//  CalendarView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 13.08.2022.
//

import UIKit

final class CalendarView: UIView {
    var dateDataCompletion: (((year: Int, month: Int)) -> ([Day: CalorieCorridor]))?
    var didChangeDate: ((Date) -> Void)?
    var linesColor: UIColor? = R.color.calendarWidget.lines()
    var calorieCorridorPartColor: UIColor? = R.color.calendarWidget.calorieCorridorPart()
    var selectionColor: UIColor? = R.color.calendarWidget.header()
    var font: UIFont? = R.font.sfProDisplaySemibold(size: 16)
    var defaultCalendarFlag: Bool = true
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private lazy var days = generateDaysInMonth(for: baseDate)
    
    private var selectedDate: Date
    private var calorieCorridorPartDays: [Day] = []
    private var calendar = Calendar.current
    private var selectedFlag = false
    private var linesShape: [CAShapeLayer]?
    private var dateData: [Day: CalorieCorridor]?
    private let selectedDateChanged: ((Date) -> Void)
    
    private var baseDate: Date {
        didSet {
            didChangeBaseDate()
        }
    }
    
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    private var cellSize: CGSize {
        return CGSize(
            width: Int(frame.width / 7),
            height: 47
        )
    }
    
    private var lineSpasing: CGFloat {
        return (cellSize.width - (cellSize.height - 15)) / 2.0
    }
    
    // MARK: - Initializers
    
    init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged
        super.init(frame: .zero)

        setupView()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawLines()
        if let data = dateDataCompletion?((
            year: calendar.component(.year, from: baseDate),
            month: calendar.component(.month, from: baseDate)
        )) {
            dateData = data
            defaultCalendarFlag = data.isEmpty
            calorieCorridorPartDays = getCalorieCorridorPartDays()
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(cellSize.width * 7)
        }
    }
    
    @objc func didSwipeLeft() {
        let newDate = calculateDate(date: baseDate, value: 1)
        
        if calendar.component(.month, from: newDate) <= calendar.component(.month, from: Date()) &&
            calendar.component(.year, from: newDate) <= calendar.component(.year, from: Date()) {
            baseDate = newDate
        }
    }
    
    @objc func didSwipeRight() {
        baseDate = calculateDate(date: baseDate, value: -1)
    }
    
    private func setupView() {
        collectionView.register(
            CalendarCollectionViewCell.self,
            forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "default"
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(cellSize.height * CGFloat(numberOfWeeksInBaseDate))
        }
    }
    
    private func didChangeBaseDate() {
        didChangeDate?(baseDate)
        selectedFlag = true
        days = generateDaysInMonth(for: baseDate)

        if let data = dateDataCompletion?((
            year: calendar.component(.year, from: baseDate),
            month: calendar.component(.month, from: baseDate)
        )) {
            dateData = data
        }

        let collectionViewHeight = cellSize.height * CGFloat(numberOfWeeksInBaseDate)
        
        if let data = dateDataCompletion?((
            year: calendar.component(.year, from: baseDate),
            month: calendar.component(.month, from: baseDate)
        )) {
            dateData = data
            defaultCalendarFlag = data.isEmpty
            calorieCorridorPartDays = getCalorieCorridorPartDays()
        }
        
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionViewHeight)
        }
        
        collectionView.reloadData()
    }
    
    private func getCalorieCorridorPartDays() -> [Day] {
        guard let dateData = dateData, !dateData.isEmpty else { return [] }

        var days: [Day] = [Day(Date())]
        for index in 1...dateData.keys.count {
            if dateData.keys.contains(Day(Date()) - index) {
                days.append(Day(Date()) - index)
            } else {
                return days
            }
        }
        
        return days
    }
    
    private func drawLines() {
        var lines: [CAShapeLayer] = []
        for i in 1..<numberOfWeeksInBaseDate {
            let line = drawLine(
                point: CGPoint(x: lineSpasing, y: CGFloat(i) * cellSize.height),
                width: bounds.width - 2 * lineSpasing
            )
            collectionView.layer.addSublayer(line)
            lines.append(line)
        }
        linesShape?.forEach { $0.removeFromSuperlayer() }
        linesShape = lines
    }
    
    private func drawLine(point: CGPoint, width: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: point)
        path.addLine(to: CGPoint(x: point.x + width, y: point.y))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = linesColor?.cgColor
        shape.zPosition = 10
        
        return shape
    }
    
    private func setGestureRecognizer() {
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeGestureRecognizerLeft.direction = .left
        swipeGestureRecognizerRight.direction = .right
        
        collectionView.addGestureRecognizer(swipeGestureRecognizerLeft)
        collectionView.addGestureRecognizer(swipeGestureRecognizerRight)
    }
    
    private func calculateDate(date oldDate: Date, value: Int) -> Date {
        return self.calendar.date(
            byAdding: .month,
            value: value,
            to: oldDate
        ) ?? oldDate
    }
}

// MARK: - Day Generation

private extension CalendarView {
    func monthMetadata(for baseDate: Date) throws -> CalendarMonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(
            of: .day,
            in: .month,
            for: baseDate
        )?.count,
              let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate)
              )
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let numberDay = calendar.component(.weekday, from: firstDayOfMonth)
        let firstDayWeekday = numberDay == 1 ? 7 : numberDay - 1
        
        return CalendarMonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday
        )
    }
    
    func generateDaysInMonth(for baseDate: Date) -> [CalendarDay] {
        guard let metadata = try? monthMetadata(for: baseDate) else { return [] }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth
            ? day - offsetInInitialRow
            : -(offsetInInitialRow - day)
            
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth
            )
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date) -> CalendarDay {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate
        ) ?? baseDate
        
        return CalendarDay(
            date: date,
            number: dateFormatter.string(from: date),
            presentDay: Day(date) == Day(Date())
        )
    }
    
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [CalendarDay] {
        guard let lastDayInMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfDisplayedMonth
        ) else {
            return []
        }
        
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        let days: [CalendarDay] = (1...additionalDays).map {
            generateDay(
                offsetBy: $0,
                for: lastDayInMonth
            )
        }
        
        return days
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
}

// MARK: - CollectionDataSource

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell
        let cellDefault = collectionView.dequeueReusableCell(
            withReuseIdentifier: "default",
            for: indexPath
        )
        
        cell?.calendarView = self
        cell?.day = day
        cell?.calorieCorridor = dateData?[Day(day.date)]
        cell?.calorieCorridorPart = nil
        cell?.isSelectedCell = Day(day.date) == Day(selectedDate)
        
        if calendar.component(.month, from: day.date) == calendar.component(.month, from: baseDate) {
            guard calorieCorridorPartDays.count > 1,
                   let index = calorieCorridorPartDays.firstIndex(where: { Day(day.date) == $0 })
            else {
                return cell ?? cellDefault
            }
            
            switch index {
            case 0:
                cell?.calorieCorridorPart = .right
            case calorieCorridorPartDays.count - 1:
                cell?.calorieCorridorPart = .left
            default:
                cell?.calorieCorridorPart = .middle
            }
            
            return cell ?? cellDefault
        }
        
        return cellDefault
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
}

// MARK: - CollectionDelegateFlowLayout

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
        selectedDate = day.date
        
        if selectedFlag {
            collectionView.visibleCells.map { $0 as? CalendarCollectionViewCell }.forEach { $0?.isSelectedCell = false }
            selectedFlag = false
        }
        selectedCell?.isSelectedCell = true
        selectedDateChanged(day.date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell)?.isSelectedCell = false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return cellSize
    }
}
