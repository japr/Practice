//
//  MainWireframe.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
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
        let detailsStoryboard = UIStoryboard(storyboardName: .details)
        let wireframe = DetailsWireframe(navigationController: navigationController,
                                         storyBoard: detailsStoryboard)
        let presenter = DetailsPresenter(movie: movie)
        presenter.wireframe = wireframe

        let controller: DetailsViewController = detailsStoryboard.instantiateViewController()
        controller.presenter = presenter

        navigationController.pushViewController(controller, animated: true)
    }
}
