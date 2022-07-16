//
//  ScrumView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI
import AVFoundation

struct ScrumView: View {
    @Binding var scrums: [DailyScrumModel]
    @State private var isPresentingNewScrum = false
    @State private var newScrum = DailyScrumModel.Data()
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    let deleteAction: ()->Void
    
    var body: some View {
        VStack {
            List {
                ForEach($scrums) { $scrum in
                    ZStack {
                        NavigationLink(destination: DetailsView(scrum: $scrum)) {
                            EmptyView()
                        }
                        HStack {
                        CardView(data: scrum)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 7)
                            .foregroundColor(scrum.theme.accentColor)
                            .padding(.trailing, 20)
                        }
                    }
                    .foregroundColor(.black)
                    .listRowBackground(scrum.theme.mainColor)
                    .listRowSeparator(.hidden)
                    
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Daily Scrums")
            
            .sheet(isPresented: $isPresentingNewScrum) {
                NavigationView {
                    EditDetailsView(data: $newScrum)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewScrum = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    isPresentingNewScrum = false
                                    let scrum = DailyScrumModel(data: newScrum)
                                    scrums.append(scrum)
                                    newScrum = DailyScrumModel.Data()
                                }
                            }
                        }
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive {
                    saveAction()
                }
            }
            FloatingButton(buttonAction: {
                isPresentingNewScrum = true
            }, theme: Theme.yellow)

        }
    }
    func delete(at offsets: IndexSet) {
        scrums.remove(atOffsets: offsets)
        deleteAction()
    }
}

struct ScrumView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumView(scrums: .constant(DailyScrumModel.sampleData), saveAction: {}, deleteAction: {})
    }
}
