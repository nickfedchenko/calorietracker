//
//  ContentFittingCollectionView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

class ContentFittingCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            if !constraints.isEmpty {
                invalidateIntrinsicContentSize()
            } else {
                sizeToFit()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }
}
