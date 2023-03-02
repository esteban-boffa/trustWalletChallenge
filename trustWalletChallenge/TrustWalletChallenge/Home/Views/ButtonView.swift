//
//  ButtonView.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 01/03/2023.
//

import SwiftUI

struct ButtonView: View {

    // MARK: Properties

    var title: String

    // MARK: Body

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .cornerRadius(8)
                .frame(width: 90, height: 40)
            Text(title)
                .foregroundColor(.white)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "")
    }
}
