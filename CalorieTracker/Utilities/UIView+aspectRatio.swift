//
//  UIView+aspectRatio.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

extension UIView {
    func aspectRatio(_ multipliedBy: CGFloat = 1) {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width).multipliedBy(multipliedBy)
        }
    }
}

extension UIView {

    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }
}
