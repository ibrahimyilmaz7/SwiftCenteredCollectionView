//
//  ViewController.swift
//  SwiftCenteredCollectionView
//
//  Created by Ibrahim Yilmaz on 21.03.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var container: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let centeredCollectionView = CenteredCollectionView()
        centeredCollectionView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(centeredCollectionView)
        NSLayoutConstraint.activate([
            centeredCollectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            centeredCollectionView.topAnchor.constraint(equalTo: container.topAnchor),
            centeredCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            centeredCollectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        centeredCollectionView.dataSet = [
            UIImage(named: "Pokemon1")!,
            UIImage(named: "Pokemon2")!,
            UIImage(named: "Pokemon3")!,
            UIImage(named: "Pokemon4")!,
            UIImage(named: "Pokemon5")!,
            UIImage(named: "Pokemon6")!
        ]
    }
}

