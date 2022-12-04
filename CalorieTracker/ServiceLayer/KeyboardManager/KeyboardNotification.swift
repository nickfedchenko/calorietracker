//
//  NSNotification+decodeKeyboard.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.11.2022.
//

import UIKit

struct KeyboardNotification {
    let animateCurve: UIView.AnimationOptions
    let animationDuration: Double
    let startFrame: CGRect
    let endFrame: CGRect
    
    static var zero: KeyboardNotification = .init(
        animateCurve: .init(rawValue: 0),
        animationDuration: 0,
        startFrame: .zero,
        endFrame: .zero
    )
    
    init(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animateCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let startFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            self.init(.zero)
            return
        }
        
        self.init(
            animateCurve: UIView.AnimationOptions(rawValue: animateCurve),
            animationDuration: animationDuration,
            startFrame: startFrame,
            endFrame: endFrame
        )
    }
    
    private init(animateCurve: UIView.AnimationOptions,
                 animationDuration: Double,
                 startFrame: CGRect,
                 endFrame: CGRect) {
        self.animateCurve = animateCurve
        self.animationDuration = animationDuration
        self.startFrame = startFrame
        self.endFrame = endFrame
    }
    
    private init(_ keyboardNotification: KeyboardNotification) {
        self.animateCurve = keyboardNotification.animateCurve
        self.animationDuration = keyboardNotification.animationDuration
        self.startFrame = keyboardNotification.startFrame
        self.endFrame = keyboardNotification.endFrame
    }
}
