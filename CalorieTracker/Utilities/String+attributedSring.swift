//
//  String+attributedSring.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.12.2022.
//

import UIKit

enum StringSettings {
    case color(UIColor?)
    case font(UIFont?)
}

struct StringSettingsModel {
    let worldIndex: [Int]
    let attributes: [StringSettings]
}

extension String {
    func attributedSring(_ settings: [StringSettingsModel], separator: String.Element = " ") -> NSAttributedString {
        let finalAttributedString = NSMutableAttributedString()
        let worlds = self.split(separator: separator).map { String($0) }
        
        let attributedStrings: [NSMutableAttributedString] = worlds.enumerated().map { world in
            let attributedString = NSMutableAttributedString(string: world.element)
            let attributes = settings[worldIndex: world.offset]
            
            attributes.forEach { attribute in
                switch attribute {
                case .color(let color):
                    attributedString.addAttribute(
                        .foregroundColor,
                        value: color ?? .black,
                        range: NSRange(location: 0, length: world.element.count)
                    )
                case .font(let font):
                    attributedString.addAttribute(
                        .font,
                        value: font ?? .init(),
                        range: NSRange(location: 0, length: world.element.count)
                    )
                }
            }
            
            return attributedString
        }
        
        attributedStrings.enumerated().forEach {
            finalAttributedString.append($0.element)
            if $0.offset != attributedStrings.count - 1 {
                finalAttributedString.append(NSAttributedString(string: String(separator)))
            }
        }
        
        return finalAttributedString
    }
}

extension Array where Element == StringSettingsModel {
    internal subscript(worldIndex index: Int) -> [StringSettings] {
        guard let attributes = self.first(where: { $0.worldIndex.contains(index) })?.attributes else {
            return []
        }

        return attributes
    }
}
