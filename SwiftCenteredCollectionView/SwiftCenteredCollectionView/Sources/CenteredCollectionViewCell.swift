//
//  CenteredCollectionViewCell.swift
//  SwiftCenteredCollectionView
//
//  Created by Ibrahim Yilmaz on 21.03.22.
//

import Foundation
import UIKit

class CenteredCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "centeredCollectionViewCell"

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = false

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setMotionEffect() {
        let minAngle: CGFloat = (315.0 * .pi) / 180.0
        let maxAngle: CGFloat = (45.0 * .pi) / 180.0

        var identity = CATransform3DIdentity
        identity.m34 = -1 / 1000.0

        contentView.layer.transform = identity
        let verticalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.transform",
            type: .tiltAlongVerticalAxis
        )
        verticalEffect.minimumRelativeValue = CATransform3DRotate(identity, minAngle, 1, 0, 0)
        verticalEffect.maximumRelativeValue = CATransform3DRotate(identity, maxAngle, 1, 0, 0)

        let horizontalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.transform",
            type: .tiltAlongHorizontalAxis
        )
        horizontalEffect.minimumRelativeValue = CATransform3DRotate(identity, minAngle, 0, 1, 0)
        horizontalEffect.maximumRelativeValue = CATransform3DRotate(identity, maxAngle, 0, 1, 0)

        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalEffect, horizontalEffect]
        addMotionEffect(group)
    }

    func resetMotionEffect() {
        motionEffects.forEach { removeMotionEffect($0) }
    }
}
