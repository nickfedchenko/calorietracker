//
//  UILabel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.01.2023.
//

import UIKit

extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributedString.length)
            )
            attributedText = attributedString
        }
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font!],
            context: nil
        )
        let linesRoundedUp = Int(ceil(textSize.height / charSize))
        return linesRoundedUp
    }
    
    func colorString(
        text: String?,
        coloredText: String?,
        color: UIColor? = .red,
        additionalAttributes: [NSAttributedString.Key: Any]?
    ) {
        let attributedString = NSMutableAttributedString(string: text!, attributes: additionalAttributes)
        let range = (text! as NSString).range(of: coloredText!)
        attributedString.setAttributes([.foregroundColor: color!], range: range)
        self.attributedText = attributedString
    }
    
    func colorString(
        text: String?,
        coloredText: [String?],
        color: UIColor? = .red,
        additionalAttributes: [NSAttributedString.Key: Any]?,
        coloredPartFont: UIFont?
    ) {
        let attributedString = NSMutableAttributedString(string: text!, attributes: additionalAttributes)
        for textToColor in coloredText {
            let range = (text! as NSString).range(of: textToColor!)
            attributedString.setAttributes(
                [.foregroundColor: color!, .font: coloredPartFont ?? .systemFont(ofSize: 17)], range: range
            )
        }
        self.attributedText = attributedString
    }
    
    func changeFontFor(textPart: String, font: UIFont?) {
        guard let attrString = attributedText else { return }
        let mutableString = NSMutableAttributedString(attributedString: attrString)
        var range = (self.text! as NSString).range(of: textPart)
        var attributes: [NSAttributedString.Key: Any] = [.font: font ?? .systemFont(ofSize: 16)]
        let possibleForegroundOption = attrString.attribute(
            .foregroundColor,
            at: range.lowerBound,
            longestEffectiveRange: &range,
            in: range
        )
        attributes[.foregroundColor] = possibleForegroundOption
        mutableString.setAttributes(attributes, range: range)
        attributedText = mutableString
    }
}
