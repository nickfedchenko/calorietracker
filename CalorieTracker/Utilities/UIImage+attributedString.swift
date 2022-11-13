//
//  UIImage+attributedString.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.11.2022.
//

import UIKit

extension UIImage {
    var asAttributedString: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = self
        return NSAttributedString(attachment: imageAttachment)
    }
}
