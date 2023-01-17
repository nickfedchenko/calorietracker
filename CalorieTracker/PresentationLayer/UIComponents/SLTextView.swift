//
//  SLTextView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.01.2023.
//

import UIKit

class SLTextView: UITextView {
    
    var separatorLinesColor: UIColor? = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var firstDraw = true
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        clearsContextBeforeDrawing = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let fontHeight = font?.lineHeight else { return }
        let path = UIBezierPath()
        let topInset = textContainerInset.top
        for i in 1...Int(rect.height / fontHeight) {
            path.append(getLine(pointY: topInset + CGFloat(i) * fontHeight))
        }
        path.lineWidth = 1
        separatorLinesColor?.setStroke()
        path.stroke()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
        addObserve()
    }
    
    private func addObserve() {
        guard firstDraw else {
            return
        }
        
        _ = textContainer.observe(\.exclusionPaths) { _, _ in
            self.setNeedsDisplay()
        }
        
        firstDraw = false
    }
    
    private func getLine(pointY: CGFloat) -> UIBezierPath {
        let fontHeight = font?.lineHeight ?? 4
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: pointY))
        textContainer.exclusionPaths
            .sorted(by: { $0.bounds.origin.x < $1.bounds.origin.x })
            .forEach {
                if pointY >= $0.bounds.minY - fontHeight && pointY <= $0.bounds.maxY + fontHeight {
                    path.addLine(to: CGPoint(x: $0.bounds.minX - 8, y: pointY))
                    path.move(to: CGPoint(x: $0.bounds.maxX + 8, y: pointY))
                }
            }
        
        path.addLine(to: CGPoint(x: frame.width, y: pointY))
        return path
    }
}
