//
//  CenteredCollectionFlowLayout.swift
//  SwiftCenteredCollectionView
//
//  Created by Ibrahim Yilmaz on 21.03.22.
//

import Foundation
import UIKit

class CenteredCollectionFlowLayout: UICollectionViewFlowLayout {

    public static var totalLayoutHeight: CGFloat {
        return itemHeight + (verticalSpacing * 2)
    }

    private static let itemHeight: CGFloat = 292.8
    private static let itemWidth: CGFloat = 238.4
    private static let itemPreviewWidth: CGFloat = 40
    private static let verticalSpacing: CGFloat = 30

    override func prepare() {
        guard let collectionView = collectionView else { return }

        scrollDirection = .horizontal
        itemSize = CGSize(width: Self.itemWidth, height: Self.itemHeight)

        // To align first and last item to the middle of the collectionView
        let horizontalInsets = (collectionView.bounds.width - itemSize.width) / 2

        collectionView.contentInset = UIEdgeInsets(
            top: Self.verticalSpacing,
            left: horizontalInsets,
            bottom: Self.verticalSpacing,
            right: horizontalInsets
        )
        minimumLineSpacing = horizontalInsets - (Self.itemPreviewWidth * 2)
    }

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        let offsetAdjustment: CGFloat = layoutAttributesArray?
            .map { $0.frame.origin.x - horizontalOffset }
            .min { abs($0) < abs($1) } ?? 0.0

        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }
}
