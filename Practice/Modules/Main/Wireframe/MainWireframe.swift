//
//  MainWireframe.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

protocol MainWireframeInterface {
    func toMovie(with movie: Movie)
}

class MainWireframe {
    private let navigationController: UINavigationController
    private let storyBoard: UIStoryboard

    // MARK: Initialization

    required init(
        navigationController: UINavigationController,
        storyBoard: UIStoryboard = UIStoryboard(storyboardName: .main)
        ) {

        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
}

extension MainWireframe: MainWireframeInterface {
    func toMovie(with movie: Movie) {

    }
}
