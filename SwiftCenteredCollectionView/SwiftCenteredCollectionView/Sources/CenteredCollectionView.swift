//
//  CenteredCollectionView.swift
//  Swift«CenteredCollectionView
//
//  Created by Ibrahim Yilmaz on 14.01.22.
//

import UIKit
import Foundation

class CenteredCollectionView: UIView {

    private let collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private let flowLayout = CenteredCollectionFlowLayout()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .fast
        collection.showsHorizontalScrollIndicator = false

        collection.register(
            CenteredCollectionViewCell.self,
            forCellWithReuseIdentifier: CenteredCollectionViewCell.identifier
        )

        collection.dataSource = self
        collection.delegate = self

        return collection
    }()

    private let pageControlView: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.isUserInteractionEnabled = false
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        return control
    }()

    var dataSet: [UIImage] = [] {
        didSet {
            pageControlView.numberOfPages = dataSet.count
            collectionView.reloadData()
        }
    }

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

        setupCollectionView()
        setupPageControlView()

        DispatchQueue.main.async {
            self.applyCellTransform()
            self.applyCellMotionEffect()
        }
    }

    private func setupCollectionView() {
        addSubview(collectionViewContainer)

        collectionViewContainer.addSubview(collectionView)

        NSLayoutConstraint.activate([
            // CollectionViewContainer
            collectionViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionViewContainer.topAnchor.constraint(equalTo: topAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            // CollectionView
            collectionView.heightAnchor.constraint(equalToConstant: CenteredCollectionFlowLayout.totalLayoutHeight),
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: collectionViewContainer.centerYAnchor)
        ])
    }

    private func setupPageControlView() {
        addSubview(pageControlView)
        NSLayoutConstraint.activate([
            pageControlView.heightAnchor.constraint(equalToConstant: 30),
            pageControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControlView.topAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor),
            pageControlView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func applyCellTransform()  {
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width) / 2
        for cell in collectionView.visibleCells {
            let offsetX = abs(centerX - cell.center.x)
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (bounds.width * 2.0)
            let scaleX = 1 - offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }

    private func applyCellMotionEffect() {
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width) / 2
        collectionView.visibleCells
            .compactMap { $0 as? CenteredCollectionViewCell }
            .forEach { cell in
                cell.resetMotionEffect()
                if abs(centerX - cell.center.x) < 1 {
                    cell.setMotionEffect()
                }
            }
    }
}

extension CenteredCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dataSet.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CenteredCollectionViewCell.identifier,
            for: indexPath
        ) as! CenteredCollectionViewCell
        cell.image = dataSet[indexPath.item]
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        applyCellTransform()

        let visibleRect = CGRect(
            origin: collectionView.contentOffset,
            size: collectionView.bounds.size
        )
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControlView.currentPage = visibleIndexPath.row
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        applyCellMotionEffect()
    }
}
