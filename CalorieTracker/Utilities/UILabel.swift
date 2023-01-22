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
            var paragraphStyle = NSMutableParagraphStyle()
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
}
