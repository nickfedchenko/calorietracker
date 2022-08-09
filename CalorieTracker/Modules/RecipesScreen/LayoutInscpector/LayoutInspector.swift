//
//  LayoutInspector.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 04.08.2022.
//

import AsyncDisplayKit

final class RecipesCollectionLayoutInspector: NSObject, ASCollectionViewLayoutInspecting {
    func scrollableDirections() -> ASScrollDirection {
        [.up, .down]
    }
    
    func collectionView(
        _ collectionView: ASCollectionView,
        constrainedSizeForNodeAt indexPath: IndexPath
    ) -> ASSizeRange {
        ASSizeRange(
            min: CGSize(width: 160, height: 128),
            max: CGSize(width: 160, height: 128)
        )
    }
    
    func collectionView(
        _ collectionView: ASCollectionView,
        constrainedSizeForSupplementaryNodeOfKind kind: String,
        at indexPath: IndexPath
    ) -> ASSizeRange {
        ASSizeRange(
            min: CGSize(width: 375, height: 24),
            max: CGSize(width: 428, height: 24)
        )
    }
    
    func collectionView(
        _ collectionView: ASCollectionView,
        supplementaryNodesOfKind kind: String,
        inSection section: UInt
    ) -> UInt {
        1
    }
}
