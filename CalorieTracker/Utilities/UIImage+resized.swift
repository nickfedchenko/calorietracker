//
//  UIImage+resized.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 06.03.2023.
//

import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height
        let height = width / aspectRatio
        let newSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
