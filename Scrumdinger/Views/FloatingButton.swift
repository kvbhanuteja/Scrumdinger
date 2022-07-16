//
//  FloatingButton.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 23/06/22.
//

import SwiftUI

struct FloatingButton: View {
    let buttonAction: ()->Void
    let theme: Theme
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button {
                    buttonAction()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(20)
                        .foregroundColor(theme.accentColor)
                        .background(theme.mainColor, in: Circle())
                }
                
            }
        }.padding(10)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(buttonAction: {}, theme: Theme.bubblegum)
    }
}
