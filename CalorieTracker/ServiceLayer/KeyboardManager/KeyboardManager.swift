//
//  KeyboardManager.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import UIKit

typealias KeyboardManagerEventClosure = (KeyboardManagerEvent) -> Void

enum KeyboardManagerEvent {
    case willShow(KeyboardNotification)
    case didShow(KeyboardNotification)
    case willHide(KeyboardNotification)
    case didHide(KeyboardNotification)
    case willFrameChange(KeyboardNotification)
    case didFrameChange(KeyboardNotification)
    
    var data: KeyboardNotification {
        switch self {
        case let .willShow(data),
            let .didShow(data),
            let .willHide(data),
            let .didHide(data),
            let .willFrameChange(data),
            let .didFrameChange(data):
            return data
        }
    }
}

final class KeyboardManager {
    var eventClosure: KeyboardManagerEventClosure?
    
    let notificationCenter: NotificationCenter
    
    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidChangeFrame(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
    }
    
    private var innerEventClosures: [KeyboardManagerEventClosure] = []
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        invokeClosures(.willShow(extractData(from: notification)))
    }
    
    @objc
    private func keyboardDidShow(_ notification: Notification) {
        invokeClosures(.didShow(extractData(from: notification)))
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        invokeClosures(.willHide(extractData(from: notification)))
    }
    
    @objc
    private func keyboardDidHide(_ notification: Notification) {
        invokeClosures(.didHide(extractData(from: notification)))
    }
    
    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        invokeClosures(.willFrameChange(extractData(from: notification)))
    }
    
    @objc
    private func keyboardDidChangeFrame(_ notification: Notification) {
        invokeClosures(.didFrameChange(extractData(from: notification)))
    }
    
    private func invokeClosures(_ event: KeyboardManagerEvent) {
        eventClosure?(event)
        innerEventClosures.forEach { $0(event) }
    }
    
    private func extractData(from notification: Notification) -> KeyboardNotification {
        return .init(notification)
    }
}

extension KeyboardManager: KeyboardManagerProtocol {
    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat,
        animated: Bool
    ) {
        let closure: KeyboardManagerEventClosure = {
            let animationDuration: Double
            switch $0 {
            case let .willShow(data), let .willFrameChange(data):
                animationDuration = data.animationDuration
                bottomConstraint.constant = -data.endFrame.height
            case let .willHide(data):
                animationDuration = data.animationDuration
                bottomConstraint.constant = bottomOffset
            default:
                return
            }
            if animated {
                UIView.animate(withDuration: animationDuration) {
                    superview.layoutIfNeeded()
                }
            } else {
                superview.layoutIfNeeded()
            }
        }
        innerEventClosures += [closure]
    }
    
    func bindToKeyboardNotifications(scrollView: UIScrollView) {
        let initialScrollViewInsets = scrollView.contentInset
        let closure = { [unowned self] event in
            self.handle(by: scrollView, event: event, initialInset: initialScrollViewInsets)
        }
        innerEventClosures += [closure]
    }
    
    private func handle(by scrollView: UIScrollView, event: KeyboardManagerEvent, initialInset: UIEdgeInsets) {
        switch event {
        case let .willShow(data), let .willFrameChange(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: .init(rawValue: data.animateCurve.rawValue),
                animations: {
                    let inset = initialInset.bottom + data.endFrame.height
                    scrollView.contentInset.bottom = inset
                    if #available(iOS 11.1, *) {
                        scrollView.verticalScrollIndicatorInsets.bottom = inset
                    }
                }
            )
        case let .willHide(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: .init(rawValue: data.animateCurve.rawValue),
                animations: {
                    scrollView.contentInset.bottom = initialInset.bottom
                    if #available(iOS 11.1, *) {
                        scrollView.verticalScrollIndicatorInsets.bottom = initialInset.bottom
                    }
                }
            )
        default:
            break
        }
    }
}
