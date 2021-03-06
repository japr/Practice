//
//  MainDatasource.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MainDatasource<Element: Codable, Cell: MovieCollectionViewCell>: NSObject, UICollectionViewDataSource where Cell.Element == Element {

    var uiUpdateRequired = BehaviorRelay<Bool>(value: false)

    private(set) var items: [Element] = []

    func setItems(_ items: [Element], animated: Bool = false) {
        self.items = items
        uiUpdateRequired.accept(animated)
    }

    func itemAt(indexPath: IndexPath) -> Element {
        return items[indexPath.item]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier(), for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        guard let element = items[indexPath.item] as? Movie else {
            return cell
        }
        cell.configure(with: element)
        return cell
    }
}
