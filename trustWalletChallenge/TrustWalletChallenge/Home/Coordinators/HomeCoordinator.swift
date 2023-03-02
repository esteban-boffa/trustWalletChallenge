//
//  HomeCoordinator.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import UIKit
import SwiftUI

protocol HomeCoordinatorDelegate: AnyObject {
    func didStopHomeCoordinator()
}

final class HomeCoordinator: CoordinatorProtocol {

    // MARK: Constants

    struct Constants {
        static let homeViewTitle = "Transactional Key Value Store"
    }

    // MARK: Properties

    var presentationStyle: CoordinatorPresentationStyle
    var rootViewController: UIViewController?
    weak var delegate: HomeCoordinatorDelegate?

    @MainActor
    private lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    // MARK: Init

    init(presentationStyle: CoordinatorPresentationStyle) {
        self.presentationStyle = presentationStyle
    }

    @MainActor
    func start() -> UIViewController? {
        let viewController = HomeView(viewModel: viewModel).customViewController { [weak self] in
            self?.handleViewDisappearance()
        }
        viewController.title = Constants.homeViewTitle
        rootViewController = UINavigationController(rootViewController: viewController)
        return rootViewController
    }

    func stop() {
        rootViewController = nil
        delegate?.didStopHomeCoordinator()
    }
}

// MARK: Private methods

private extension HomeCoordinator {
    func handleViewDisappearance() {}
}

// MARK: HomeViewModelDelegate

extension HomeCoordinator: HomeViewModelDelegate {}
