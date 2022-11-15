//
//  RoundedView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.11.2022.
//

import UIKit

class RoundedView: UIView {
    
    private var firstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerCurve = .circular
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        layer.cornerRadius = min(frame.height, frame.width) / 2.0
        firstDraw = false
    }
}

class RoundedImageView: UIImageView {
    
    private var firstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerCurve = .circular
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        layer.cornerRadius = min(frame.height, frame.width) / 2.0
        firstDraw = false
    }
}
