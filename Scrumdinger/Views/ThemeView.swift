//
//  ThemeView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct ThemeView: View {
    let theme: Theme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(theme.mainColor)
                .padding([.leading, .trailing], 5)
                .ignoresSafeArea()
            Label(theme.name, systemImage: "paintpalette")
                .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: .bubblegum)
    }
}
