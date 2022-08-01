//
//  ElementExercisesChartNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.07.2022.
//

import AsyncDisplayKit
import UIKit

final class ElementExercisesChartNode: ASDisplayNode {
    struct Exercise {
        let burnedKcal: Int?
        let exerciseType: ExerciseType?
        let elementChart: ElementChart
    }
    
    private lazy var chartImageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = UIView.ContentMode.scaleToFill
        return node
    }()
    
    private lazy var exerciseImageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = UIView.ContentMode.center
        return node
    }()
    
    private lazy var burnedKcalTextNode: ASTextNode = {
        let node = ASTextNode()
        node.style.alignSelf = .center
        return node
    }()
    
    let elementChart: ElementChart
    
    init(exercise: Exercise) {
        elementChart = exercise.elementChart
        super.init()
        automaticallyManagesSubnodes = true
        exerciseImageNode.image = exercise.exerciseType?.image
        chartImageNode.image = exercise.elementChart.image
        
        guard let burnedKcal = exercise.burnedKcal else { return }
        burnedKcalTextNode.attributedText = getAttributedStringWithImage(
            image: R.image.exercisesWidget.fire(),
            attributedString: getAttributedString(
                string: " \(burnedKcal)",
                size: 12,
                color: .black
            )
        )
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.justifyContent = .end
        stack.spacing = 4
        stack.children = [
            exerciseImageNode,
            burnedKcalTextNode
        ]
        
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 8,
                    left: 0,
                    bottom: 8,
                    right: 0
                ),
                child: stack
            ),
            background: chartImageNode
        )
    }
    
    private func getAttributedStringWithImage(image: UIImage?,
                                              attributedString: NSAttributedString) -> NSAttributedString {
        guard let image = image else { return NSMutableAttributedString() }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(
            x: 0,
            y: (UIFont.roundedFont(ofSize: 12, weight: .semibold).capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )
        let imageString = NSAttributedString(attachment: imageAttachment)
        let fullString = NSMutableAttributedString(attributedString: imageString)
        fullString.append(attributedString)
        
        return fullString
    }
    
    private func getAttributedString(string: String,
                                     size: CGFloat,
                                     color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: size, weight: .semibold)
            ],
            range: NSRange(location: 0, length: string.count)
        )

        return attributedString
    }
}
