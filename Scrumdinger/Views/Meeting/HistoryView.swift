//
//  HistoryView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 17/06/22.
//

import SwiftUI

struct HistoryView: View {
    let history: HistoryModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Attendee")
                    .font(.headline)
                Text(history.attendeeString)
                if let transcript = history.transcript {
                    Text("Transcript")
                        .font(.headline)
                        .padding(.top)

                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var history: HistoryModel {
        HistoryModel(attendee: [DailyScrumModel.Attendee(name: "Jon"),
                                DailyScrumModel.Attendee(name: "Darla"),
                                DailyScrumModel.Attendee(name: "Luis")],
                     lengthInMinute: 10, transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...")
    }
    static var previews: some View {
        HistoryView(history: history)
    }
}
