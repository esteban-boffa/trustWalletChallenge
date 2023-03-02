//
//  TextFieldStyle.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 70)
            .padding(.all, 8)
            .background(Color(uiColor: .lightGray).opacity(0.3))
            .cornerRadius(8)
    }
}
