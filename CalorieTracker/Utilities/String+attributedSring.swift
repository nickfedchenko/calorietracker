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
    case lineHeightMultiple(CGFloat?)
}

struct StringSettingsModel {
    let worldIndex: [Int]
    let attributes: [StringSettings]
}

struct StringImageModel {
    let image: UIImage?
    let font: UIFont?
    let position: ImagePosition
    
    enum ImagePosition {
        case left
        case right
    }
}

extension String {
    func attributedString(_ settings: [StringSettingsModel],
                          separator: String.Element = " ",
                          image: StringImageModel? = nil) -> NSAttributedString {
        let finalAttributedString = NSMutableAttributedString()
        let worlds = self.split(separator: separator).map { String($0) }
        
        var attributedStrings: [NSMutableAttributedString] = worlds.enumerated().map { world in
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
                case .lineHeightMultiple(let heightMultiple):
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = heightMultiple ?? 1
                    attributedString.addAttribute(.paragraphStyle,
                                                  value: paragraphStyle,
                                                  range: NSRange(location: 0, length: world.element.count)
                    )
                }
            }
            
            return attributedString
        }
        
        if let imageData = image {
            let imageAttributed = getAttributedStringImage(imageData: imageData)
            attributedStrings.insert(
                NSMutableAttributedString(attributedString: imageAttributed),
                at: {
                    switch imageData.position {
                    case .left:
                        return 0
                    case .right:
                        return attributedStrings.count
                    }
                }()
            )
        }
        
        attributedStrings.enumerated().forEach {
            finalAttributedString.append($0.element)
            if $0.offset != attributedStrings.count - 1 {
                finalAttributedString.append(NSAttributedString(string: String(separator)))
            }
        }
        
        return finalAttributedString
    }
    
    private func getAttributedStringImage(imageData: StringImageModel) -> NSAttributedString {
        guard let image = imageData.image, let font = imageData.font else {
            return NSAttributedString()
        }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(
            x: 20,
            y: (font.capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )

        return NSAttributedString(attachment: imageAttachment)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
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
