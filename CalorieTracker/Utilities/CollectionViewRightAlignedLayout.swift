//
//  CollectionViewRightAlignedLayout.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    func rightAlignFrameOnWidth(_ width: CGFloat, with sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = width - frame.size.width - sectionInset.left
        self.frame = frame
    }
}

class CollectionViewRightAlignedLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach {
                if let collectionViewLayoutAttributes = $0.copy() as? UICollectionViewLayoutAttributes {
                attributesCopy.append(collectionViewLayoutAttributes)
                }
            }
        }
        
        for attributes in attributesCopy where attributes.representedElementKind == nil {
                let indexpath = attributes.indexPath
                if let attr = layoutAttributesForItem(at: indexpath) {
                    attributes.frame = attr.frame
                }
        }
        return attributesCopy

    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let currentItemAttributes = super.layoutAttributesForItem(
            at: indexPath as IndexPath
        )?.copy() as? UICollectionViewLayoutAttributes {
            
            let sectionInset = self.evaluatedSectionInsetForItem(at: indexPath.section)
            let layoutWidth = self.collectionView!.frame.width - sectionInset.left - sectionInset.right

            let isFirstItemInSection = indexPath.item == 0
            
            if isFirstItemInSection {
                currentItemAttributes.rightAlignFrameOnWidth(self.collectionView!.frame.size.width, with: sectionInset)
                return currentItemAttributes
            }
            
            let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
            
            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect(
                x: sectionInset.right,
                y: currentFrame.origin.y,
                width: layoutWidth,
                height: currentFrame.size.height
            )

            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            
            if isFirstItemInRow {

                currentItemAttributes.rightAlignFrameOnWidth(self.collectionView!.frame.size.width, with: sectionInset)
                return currentItemAttributes
            }
            
            let previousFrameLeftPoint = previousFrame.origin.x
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameLeftPoint
            - evaluatedMinimumInteritemSpacing(at: indexPath.section)
            - frame.size.width
            currentItemAttributes.frame = frame
            return currentItemAttributes
            
        }
        return nil
    }
    
    func evaluatedMinimumInteritemSpacing(at sectionIndex: Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let inteitemSpacing = delegate.collectionView?(
                self.collectionView!,
                layout: self,
                minimumInteritemSpacingForSectionAt: sectionIndex
            )
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return self.minimumInteritemSpacing
        
    }
    
    func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let insetForSection = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return self.sectionInset
    }
}
