//
//  UIStoryboard+Additions.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

extension UIStoryboard {

    enum StoryboardName: String {
        case main = "Main"
    }

    convenience init(storyboardName: StoryboardName, bundle: Bundle? = nil) {
        self.init(name: storyboardName.rawValue, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("No view controller found")
        }

        return viewController
    }
}
