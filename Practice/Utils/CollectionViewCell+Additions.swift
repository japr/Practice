//
//  CollectionViewCell+Additions.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import UIKit

protocol CellIdentifiable where Self: UICollectionViewCell {
    static func identifier() -> String
}

protocol ConfigurableCell where Self: UICollectionViewCell {
    associatedtype Element
    func configure(with item: Element)
}

extension UICollectionViewCell: CellIdentifiable {
    class func identifier() -> String {
        return String(describing: self) + "Identifier"
    }
}
