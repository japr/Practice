//
//  UIViewController+Additions.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable: NSObjectProtocol {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
