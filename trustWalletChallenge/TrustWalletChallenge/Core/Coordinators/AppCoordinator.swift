//
//  AppCoordinator.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import Foundation
import UIKit

final class AppCoordinator: CoordinatorProtocol {

    // MARK: Private Properties

    private var homeCoordinator: HomeCoordinator?

    // MARK: Properties

    var rootViewController: UIViewController?
    var presentationStyle: CoordinatorPresentationStyle

    // MARK: Init

    init(presentationStyle: CoordinatorPresentationStyle) {
        self.presentationStyle = presentationStyle
    }

    @MainActor
    func start() -> UIViewController? {
        homeCoordinator = HomeCoordinator(presentationStyle: .pushed(nil))
        guard let viewController = homeCoordinator?.start() else { return nil }
        rootViewController = viewController
        return rootViewController
    }

    func stop() {
        homeCoordinator = nil
        rootViewController = nil
    }
}

// MARK: HomeCoordinatorDelegate

extension AppCoordinator: HomeCoordinatorDelegate {
    func didStopHomeCoordinator() {
        homeCoordinator = nil
    }
}
