//
//  ErrorView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 17/06/22.
//

import SwiftUI

struct ErrorView: View {
    var errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Text("An error has occurred")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                }

            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum sampleError: Error {
        case errorRequired
    }
    
    static var errorWrapper: ErrorWrapper {
        ErrorWrapper(error: sampleError.errorRequired, guidance: "You can safely ignore this error")
    }
    static var previews: some View {
        ErrorView(errorWrapper: errorWrapper)
    }
}
