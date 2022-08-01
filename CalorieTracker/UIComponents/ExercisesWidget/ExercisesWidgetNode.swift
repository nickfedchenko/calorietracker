//
//  ExercisesWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.07.2022.
//

import AsyncDisplayKit

final class ExercisesWidgetNode: CTWidgetNode {
    
    struct Model {
        let exercises: [Exercise]
        let progress: CGFloat?
        let burnedKcal: Int
        let goalBurnedKcal: Int?
        
        struct Exercise {
            let burnedKcal: Int
            let exerciseType: ExerciseType
        }
    }
    
    private lazy var exercisesTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = getAttributedString(
            string: "EXERCISES",
            size: 16,
            color: R.color.exercisesWidget.secondGradientColor()
        )
        return node
    }()
    
    private lazy var burnedTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    private lazy var progressBar: LineProgressNode = {
        let node = LineProgressNode()
        node.style.height = ASDimension(unit: .points, value: 12)
        node.progress = 0
        node.backgroundLineColor = R.color.exercisesWidget.backgroundLine() ?? .white
        node.colors = [
            R.color.exercisesWidget.firstGradientColor() ?? .purple,
            R.color.exercisesWidget.secondGradientColor() ?? .purple
        ]
        return node
    }()
    
    private var indexEnd: Int { indexStart + min(model.exercises.count, 3) - 1 }
    private var indexStart = 0 {
        didSet {
            if indexStart < 0 { indexStart = 0 }
        }
    }
    
    var model: Model {
        didSet {
            didChangeModel()
        }
    }
    
    init(_ model: Model, with configuration: CTWidgetNodeConfiguration) {
        self.model = model
        super.init(with: configuration)
        didChangeModel()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didLoad() {
        super.didLoad()
        setGestureRecognizer()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let topTextStack = ASStackLayoutSpec.horizontal()
        topTextStack.justifyContent = .spaceBetween
        topTextStack.children = [
            exercisesTextNode,
            burnedTextNode
        ]
        
        let exercisesStackChildren = getFinalElementsChart()
        exercisesStackChildren.forEach {
            $0.style.width = getWidthElementChart(
                widthSuperView: constrainedSize.min.width,
                elementChart: $0.elementChart
            )
        }
        let exercisesStack = ASStackLayoutSpec.horizontal()
        exercisesStack.children = exercisesStackChildren
        
        let mainStack = ASStackLayoutSpec.vertical()
        var mainStackChildren: [ASLayoutElement] = [
            ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 0,
                    left: 8,
                    bottom: 0,
                    right: 8
                ), child: topTextStack
            ),
            exercisesStack
        ]
        if model.progress != nil {
            mainStackChildren.append(
                ASInsetLayoutSpec(
                    insets: UIEdgeInsets(
                        top: 0,
                        left: 8,
                        bottom: 0,
                        right: 8
                    ), child: progressBar
                )
            )
        }
        mainStack.justifyContent = .spaceBetween
        mainStack.children = mainStackChildren
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 5,
                left: 0,
                bottom: 8,
                right: 0
            ),
            child: mainStack
        )
    }
    
    private func setGestureRecognizer() {
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeGestureRecognizerLeft.direction = .left
        swipeGestureRecognizerRight.direction = .right
        
        self.view.addGestureRecognizer(swipeGestureRecognizerLeft)
        self.view.addGestureRecognizer(swipeGestureRecognizerRight)
    }
    
    private func didChangeModel() {
        
        let burnedKcal: NSMutableAttributedString = getAttributedString(
            string: String(model.burnedKcal),
            size: 16, color: R.color.exercisesWidget.secondGradientColor()
        )
        if let goalBurnedKcal = model.goalBurnedKcal {
            progressBar.progress = CGFloat(model.burnedKcal) / CGFloat(goalBurnedKcal)
            burnedKcal.append(getAttributedString(
                string: " / \(goalBurnedKcal)",
                size: 16,
                color: R.color.exercisesWidget.backgroundLine()
            ))
        }
        
        burnedTextNode.attributedText = burnedKcal
        
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
    
    // MARK: - setup ElementExercisesChartNodes
    
    private func getFinalElementsChart() -> [ElementExercisesChartNode] {
        let exercises = model.exercises
        var elements: [ElementExercisesChartNode] = []
        
        if let maxBurned = exercises.map({ $0.burnedKcal }).max() {
            elements = exercises.map {
                ElementExercisesChartNode(
                    exercise: ElementExercisesChartNode.Exercise(
                        burnedKcal: $0.burnedKcal,
                        exerciseType: $0.exerciseType,
                        elementChart: getElementChart(CGFloat($0.burnedKcal) / CGFloat(maxBurned))
                    )
                )
            }
        }
        
        var elementsChart = getExerciseElements(elements: elements)
        
        switch elementsChart.count {
        case 0:
            elementsChart.append(getElementChartNode(.spacerFlex))
            elementsChart.append(getElementChartNode(.spacerFlex))
            elementsChart.append(getElementChartNode(.spacerFlex))
        case 1:
            elementsChart.insert(
                getElementChartNode(.spacerFlex),
                at: 0
            )
            elementsChart.insert(
                getElementChartNode(.spacerFlex),
                at: elementsChart.count
            )
        case 2:
            elementsChart.insert(
                getElementChartNode(.spacerFlex),
                at: 1
            )
        default:
            break
        }
        
        elementsChart.insert(
            getElementChartNode(indexStart == 0 ? .start : .leftMore),
            at: 0
        )
        elementsChart.insert(
            getElementChartNode(indexEnd == model.exercises.count - 1 ? .end : .rightMore),
            at: elementsChart.count
        )
        
        return elementsChart
    }
    
    private func getExerciseElements(elements: [ElementExercisesChartNode]) -> [ElementExercisesChartNode] {
        guard elements.count > indexEnd else {
            indexStart -= 1
            if elements.count <= 3 {
                return elements
            } else {
                return Array(elements[indexStart...indexEnd])
            }
        }
        return !elements.isEmpty ? Array(elements[indexStart...indexEnd]) : []
    }
    
    private func getWidthElementChart(widthSuperView: CGFloat, elementChart: ElementChart) -> ASDimension {
        switch elementChart {
        case .oneTenths,
                .twoTenths,
                .threeTenths,
                .fourTenths,
                .fiveTenths,
                .sixTenths,
                .sevenTenths,
                .eightTenths,
                .nineTenths,
                .tenTenths,
                .spacerFlex:
            return ASDimension(unit: .points, value: widthSuperView / 4)
        case .start,
                .end,
                .leftMore,
                .rightMore,
                .spacer:
            return ASDimension(unit: .points, value: widthSuperView / 8)
        }
    }
    
    private func getElementChartNode(_ with: ElementChart) -> ElementExercisesChartNode {
        return ElementExercisesChartNode(
            exercise: ElementExercisesChartNode.Exercise(
                burnedKcal: nil,
                exerciseType: nil,
                elementChart: with
            )
        )
    }
    
    private func getElementChart(_ with: CGFloat) -> ElementChart {
        switch with * 10 {
        case 0...1:
            return ElementChart.oneTenths
        case 1...2:
            return ElementChart.twoTenths
        case 2...3:
            return ElementChart.threeTenths
        case 3...4:
            return ElementChart.fourTenths
        case 4...5:
            return ElementChart.fiveTenths
        case 5...6:
            return ElementChart.sixTenths
        case 6...7:
            return ElementChart.sevenTenths
        case 7...8:
            return ElementChart.eightTenths
        case 8...9:
            return ElementChart.nineTenths
        case 9...10:
            return ElementChart.tenTenths
        default:
            return ElementChart.spacerFlex
        }
    }
    
    private func getAttributedString(string: String,
                                     size: CGFloat,
                                     color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: size, weight: .bold)
            ],
            range: NSRange(location: 0, length: string.count)
        )

        return attributedString
    }
    
    // MARK: - Selector metods
    
    @objc private func didSwipeLeft() {
        indexStart += 1
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
    
    @objc private func didSwipeRight() {
        indexStart -= 1
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
}
