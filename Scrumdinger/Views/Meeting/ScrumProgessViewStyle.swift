//
//  ScrumProgessViewStyle.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 09/06/22.
//

import SwiftUI

struct ScrumProgessViewStyle: ProgressViewStyle {
    var theme: Theme
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(theme.accentColor)
                .frame(height: 20)
            ProgressView(configuration)
                .tint(theme.mainColor)
                .frame(height: 12.0)
                .padding(.horizontal)
        }
    }
}

struct ScrumProgessViewStyle_Preview: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.4)
            .progressViewStyle(ScrumProgessViewStyle(theme: .bubblegum))
    }
}

