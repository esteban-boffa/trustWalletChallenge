//
//  CustomHostingController.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import Foundation
import SwiftUI

final class CustomHostingController<Content>: UIHostingController<Content> where Content: View {

    // MARK: Properties

    var onViewDisappeared: () -> ()?

    // MARK: Init

    init(rootView: Content, onViewDisappeared: @escaping () -> ()?) {
        self.onViewDisappeared = onViewDisappeared
        super.init(rootView: rootView)
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onViewDisappeared()
    }
}
