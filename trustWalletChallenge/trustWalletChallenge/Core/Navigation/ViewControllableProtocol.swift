//
//  ViewControllableProtocol.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import Foundation
import SwiftUI

protocol ViewControllableProtocol {
    func viewController() -> UIViewController
    func customViewController(onViewDisappeared: @escaping () -> ()?) -> UIViewController
}

extension ViewControllableProtocol where Self: View {
    func viewController() -> UIViewController {
        UIHostingController(rootView: self)
    }

    func customViewController(onViewDisappeared: @escaping () -> ()?) -> UIViewController {
        CustomHostingController(rootView: self, onViewDisappeared: onViewDisappeared)
    }
}

extension AnyView: ViewControllableProtocol {}
