//
//  CoordinatorProtocol.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import UIKit

enum CoordinatorPresentationStyle: Equatable {
    case pushed(UINavigationController?)
    case presented(UIViewController)
    case sheet(UIViewController)

    var shouldShowCloseButton: Bool {
        switch self {
        case .pushed, .sheet:
            return false
        case .presented:
            return true
        }
    }
}

protocol CoordinatorProtocol {
    var rootViewController: UIViewController? { get set }
    var presentationStyle: CoordinatorPresentationStyle { get set }
    func start() -> UIViewController?
    func stop()
    func present(from viewController: UIViewController?) -> Bool
}

extension CoordinatorProtocol {
    func present(from viewController: UIViewController?) -> Bool {
        return false
    }
}
