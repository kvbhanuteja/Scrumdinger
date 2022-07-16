//
//  DetailsView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct DetailsView: View {
    
    @State private var data = DailyScrumModel.Data()
    @Binding var scrum: DailyScrumModel
    @State var isPresentingEditView = false
    var body: some View {
        List {
            Section {
                NavigationLink(destination: MeetingView(scrum: $scrum)) {
                    Label("Starting Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text(scrum.lengthInMinutes.formattedTime())
                }
                HStack {
                    Label("Date", systemImage: "calendar")
                    Spacer()
                    Text(scrum.date, style: .date)
                }
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundColor(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .cornerRadius(4)
                }
            } header: {
                Text("Meeting info")
            }
            
            Section {
                ForEach(scrum.attendees) {attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } header: {
                Text("Attendees")
            }
            Section {
                if scrum.history.isEmpty {
                    Label("No history yet", systemImage: "calendar.badge.exclamationmark")
                } else {
                    ForEach(scrum.history) { history in
                        NavigationLink(destination: HistoryView(history: history)) {
                            HStack {
                                Image(systemName: "calendar")
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(history.date, style: .date)
                                    Text("Meeting happened for \(history.lengthInMinute) mins")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        scrum.history.remove(atOffsets: indexSet)
                    }
                }
            } header: {
                Text("History")
            }
            
        }
        .navigationTitle(scrum.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresentingEditView, content: {
            NavigationView {
                EditDetailsView(data: $data)
                    .navigationTitle(scrum.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                scrum.update(from: data)
                            }
                        }
                    }
            }
        })
        .toolbar {
            Button {
                isPresentingEditView = true
                data = scrum.data
            }label: {
                Text("Edit")
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                DetailsView(scrum: .constant( DailyScrumModel.sampleData[0]))
            }
            .preferredColorScheme(.dark)
        }
    }
}
