//
//  View+Extension.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import Foundation
import SwiftUI

extension View {
    func textFieldStyle() -> some View {
        modifier(TextFieldStyle())
    }

    func subtitleStyle() -> some View {
        modifier(SubtitleStyle())
    }
}
