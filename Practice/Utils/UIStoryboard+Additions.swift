//
//  UIStoryboard+Additions.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
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
