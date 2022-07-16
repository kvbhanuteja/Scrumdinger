//
//  ThemePickerView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: Theme
    var body: some View {
        Picker("Theme", selection: $selectedTheme) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView(selectedTheme: .constant(.buttercup))
    }
}
