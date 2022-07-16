//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @StateObject var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumView(scrums: $store.scrums) {
                    saveData()
                } deleteAction: {
                    saveData()
                }
            }
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Try again later")
                }
            }
            .sheet(item: $errorWrapper) {
                store.scrums = DailyScrumModel.sampleData
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
            }

        }
    }
    
    func saveData() {
        Task {
            do {
                try await ScrumStore.saveData(scrums: store.scrums)
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "App will load sample data and continue")
            }
        }
        

    }
}
