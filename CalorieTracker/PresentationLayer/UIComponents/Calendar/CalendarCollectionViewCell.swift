//
//  CalendarCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 13.08.2022.
//

import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CalendarCollectionViewCell.self)

    weak var calendarView: CalendarView? {
        didSet {
            didSetCalendarView()
        }
    }
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var shapeCircle: CAShapeLayer?
    private var backgroundShape: ActionCAShapeLayer?
    
    private var exceededColor: UIColor? = R.color.calendarWidget.header()
    private var hitColor: UIColor? = R.color.calendarWidget.hitCircle()
    private var selectionColor: UIColor?
        
    private var defaultTextColor: UIColor? {
        switch calorieCorridor {
        case .exceeded, .hit:
            return R.color.calendarWidget.textDefault()
        default:
            return calendarView?.defaultCalendarFlag == true
            ? R.color.calendarWidget.textDefault()
            : R.color.calendarWidget.textGray()
        }
    }
    
    var day: CalendarDay? {
        didSet {
            guard let day = day else { return }
            numberLabel.attributedText = NSAttributedString(string: day.number)
            updateSelectionStatus()
        }
    }
    
    var calorieCorridor: CalorieCorridor? {
        didSet {
            didChangeCalorieCorridor()
        }
    }
    
    var calorieCorridorPart: CalorieCorridorPart? {
        didSet {
            didChangeCalorieCorridorPart()
        }
    }
    
    var isSelectedCell: Bool = false {
        didSet {
            updateSelectionStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        shapeCircle = getCircleShape(size: frame.size)
        layer.addSublayer(shapeCircle ?? CAShapeLayer())
        drawBackground(rect: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyDefaultStyle()
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionBackgroundView.layer.cornerRadius = 16
        selectionBackgroundView.addSubview(numberLabel)
        addSubview(selectionBackgroundView)
        
        numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectionBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-11)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(32)
        }
    }
    
    private func didChangeCalorieCorridorPart() {
        switch calorieCorridorPart {
        case .left:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            backgroundShape?.strokeStart = 0.5
            CATransaction.commit()
            backgroundShape?.isHidden = false
        case .right:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            backgroundShape?.strokeEnd = 0.5
            CATransaction.commit()
            backgroundShape?.isHidden = false
        case .middle:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            backgroundShape?.strokeStart = 0
            backgroundShape?.strokeEnd = 1
            CATransaction.commit()
            backgroundShape?.isHidden = false
        default:
            backgroundShape?.isHidden = true
        }
    }
    
    private func didChangeCalorieCorridor() {
        updateSelectionStatus()
        
        switch calorieCorridor {
        case .exceeded:
            shapeCircle?.fillColor = exceededColor?.cgColor
            shapeCircle?.isHidden = false
        case .hit:
            shapeCircle?.fillColor = hitColor?.cgColor
            shapeCircle?.isHidden = false
        default:
            shapeCircle?.isHidden = true
        }
    }
    
    private func didSetCalendarView() {
        backgroundShape?.strokeColor = calendarView?.calorieCorridorPartColor?.cgColor
        numberLabel.font = calendarView?.font
        selectionBackgroundView.layer.borderColor = calendarView?.selectionColor?.cgColor
        selectionColor = calendarView?.selectionColor
    }
    
    private func drawBackground(rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: rect.width, y: 20))
        
        let shape = ActionCAShapeLayer()
        shape.allowActions = false
        shape.path = path.cgPath
        shape.lineWidth = 32
        shape.lineCap = .round
        shape.isHidden = true
        
        backgroundShape = shape
        layer.addSublayer(shape)
    }
    
    private func getCircleShape(size: CGSize) -> CAShapeLayer {
        let path = UIBezierPath(
            ovalIn: CGRect(
                origin: CGPoint(
                    x: size.width / 2.0 - 2,
                    y: 39
                ),
                size: CGSize(width: 4, height: 4)
            )
        )
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.green.cgColor
        
        return shape
    }
}

// MARK: - Appearance
private extension CalendarCollectionViewCell {
    func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.presentDay {
            applyPresentDayStyle()
        } else if isSelectedCell {
            applySelectedStyle()
        } else {
            applyDefaultStyle()
        }
    }
    
    func applyPresentDayStyle() {
        numberLabel.textColor = R.color.calendarWidget.textDefault()
        selectionBackgroundView.backgroundColor = calendarView?.backgroundColor
        selectionBackgroundView.layer.borderColor = selectionColor?.cgColor
        selectionBackgroundView.layer.borderWidth = 1
    }
    
    func applySelectedStyle() {
        numberLabel.textColor = .white
        selectionBackgroundView.backgroundColor = selectionColor
        selectionBackgroundView.layer.borderWidth = 0
    }
    
    func applyDefaultStyle() {
        numberLabel.textColor = defaultTextColor
        selectionBackgroundView.backgroundColor = .clear
        selectionBackgroundView.layer.borderWidth = 0
    }
}
