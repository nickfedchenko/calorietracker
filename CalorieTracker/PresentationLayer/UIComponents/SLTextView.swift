//
//  SLTextView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.01.2023.
//

import UIKit

class SLTextView: UITextView {

    var lineHeightMultiple: CGFloat = 1

    var separatorLinesColor: UIColor? = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    var lineHeight: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var firstDraw = true
    private var exclusionPathsObserver: NSKeyValueObservation?
    
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
        var lineHeight = fontHeight * lineHeightMultiple
        if let defaultLineHeight = self.lineHeight {
            lineHeight = defaultLineHeight
        }
        let path = UIBezierPath()
        let topInset = textContainerInset.top
        for i in 1...Int(rect.height / lineHeight) {
            path.append(getLine(pointY: topInset + CGFloat(i) * lineHeight))
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

    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }

        let bottomDistance: CGFloat = 3
        let height = font.pointSize - font.descender
        let yPos = superRect.size.height - height + superRect.origin.y - bottomDistance
        superRect.origin.y = yPos
        superRect.size = CGSize(width: 2, height: height)
        return superRect
    }

    private func addObserve() {
        guard firstDraw else {
            return
        }
        
        exclusionPathsObserver = textContainer.observe(\.exclusionPaths) { [weak self] _, _ in
            self?.setNeedsDisplay()
        }
        
        firstDraw = false
    }
    
    private func getLine(pointY: CGFloat) -> UIBezierPath {
        let fontHeight = font?.lineHeight ?? 4
        var lineHeight = fontHeight * lineHeightMultiple
        if let defaultLineHeight = self.lineHeight {
            lineHeight = defaultLineHeight
        }
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: pointY))
        textContainer.exclusionPaths
            .sorted(by: { $0.bounds.origin.x < $1.bounds.origin.x })
            .forEach {
                if pointY >= $0.bounds.minY - lineHeight && pointY <= $0.bounds.maxY + lineHeight {
                    path.addLine(to: CGPoint(x: $0.bounds.minX - 8, y: pointY))
                    path.move(to: CGPoint(x: $0.bounds.maxX + 8, y: pointY))
                }
            }
        
        path.addLine(to: CGPoint(x: frame.width, y: pointY))
        return path
    }
}
