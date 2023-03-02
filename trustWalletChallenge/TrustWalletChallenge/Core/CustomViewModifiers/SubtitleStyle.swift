//
//  SubtitleStyle.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import SwiftUI

struct SubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.gray)
    }
}
