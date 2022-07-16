//
//  DailyScrumModel.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct DailyScrumModel: Identifiable, Codable {

    var id = UUID().uuidString
    var title: String
    var attendees: [Attendee]
    var lengthInMinutes: Int
    var theme: Theme
    var date: Date
    var startTime: Date
    var endTime: Date
    var history: [HistoryModel] = []
    
    internal init(id: String = UUID().uuidString,
                  title: String,
                  attendees: [String],
                  lengthInMinutes: Int,
                  theme: Theme,
                  date: Date = Date(),
                  startTime: Date,
                  endTime: Date) {
        self.id = id
        self.title = title
        self.attendees = attendees.map {Attendee(name: $0)}
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
    }
    
    init(data: Data) {
        self.title = data.title
        self.attendees = data.attendees
        self.theme = data.theme
        self.date = data.date
        self.startTime = data.startTime
        self.endTime = data.endTime
        let diff = endTime - startTime
        let minutes = (NSInteger(diff) / 60) % 60
        let hours = (NSInteger(diff) / 3600)
        let totalMinutes = (hours * 60 + minutes)
        lengthInMinutes = Int(totalMinutes)
    }
    
}

extension DailyScrumModel {
    struct Attendee: Identifiable, Codable {
        var id = UUID().uuidString
        var name: String
    }
    
    struct Data {
        var title: String = ""
        var attendees: [Attendee] = []
        var lengthInMinutes: Double = 5
        var theme: Theme = .seafoam
        var date: Date = Date()
        var startTime: Date = Date()
        var endTime: Date = Date()
    }
    
    var data: Data {
        Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), theme: theme, date: date, startTime: startTime, endTime: endTime)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        theme = data.theme
        date = data.date
        startTime = data.startTime
        endTime = data.endTime
        let diff = endTime - startTime
        let minutes = (NSInteger(diff) / 60) % 60
        let hours = (NSInteger(diff) / 3600)
        let totalMinutes = (hours * 60 + minutes)
        lengthInMinutes = Int(totalMinutes)

        
    }
}

extension DailyScrumModel {
    static let sampleData: [DailyScrumModel] =
    [
        DailyScrumModel(title: "Design", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow, startTime: Date(), endTime: Date()),
        DailyScrumModel(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange, startTime: Date(), endTime: Date()),
        DailyScrumModel(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 5, theme: .poppy, startTime: Date(), endTime: Date())
    ]
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
