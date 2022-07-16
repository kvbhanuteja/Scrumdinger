//
//  HistoryModel.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 09/06/22.
//

import Foundation

struct HistoryModel: Identifiable, Codable {

    var id = UUID().uuidString
    let date: Date
    var attendee: [DailyScrumModel.Attendee]
    var lengthInMinute: Int
    var transcript: String?
    
    internal init(id: String = UUID().uuidString,
                  date: Date = Date(),
                  attendee: [DailyScrumModel.Attendee],
                  lengthInMinute: Int,
                  transcript: String? = nil) {
        self.id = id
        self.date = date
        self.attendee = attendee
        self.lengthInMinute = lengthInMinute
        self.transcript = transcript
    }
    
        var attendeeString: String {
            ListFormatter.localizedString(byJoining: attendee.map { $0.name })
        }
}
