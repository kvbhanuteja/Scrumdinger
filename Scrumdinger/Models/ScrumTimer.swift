//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 09/06/22.
//

import Foundation
import SwiftUI

class ScrumTimer: ObservableObject {
    /// A struct to keep track of meeting attendees during a meeting.
    struct Speaker: Identifiable {
        /// The attendee name.
        let name: String
        /// True if the attendee has completed their turn to speak.
        var isCompleted: Bool
        /// Id for Identifiable conformance.
        let id = UUID()
    }
    
    /// The name of the meeting attendee who is speaking.
    @Published var activeSpeaker = ""
    /// The number of seconds since the beginning of the meeting.
    @Published var minutesElapsed = 0
    /// The number of seconds until all attendees have had a turn to speak.
    @Published var minutesRemaining = 0
    /// All meeting attendees, listed in the order they will speak.
    private(set) var speakers: [Speaker] = []
    
    /// The scrum meeting length.
    private(set) var lengthInMinutes: Int
    /// A closure that is executed when a new attendee begins speaking.
    var speakerChangedAction: (() -> Void)?
    
    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    //    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    var minutesPerSpeaker: Int {
        lengthInMinutes / speakers.count
    }
    private var minutesElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    @Published var timeRemainingForSpeakerInSeconds: Int = 0
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     -  attendees: A list of attendees for the meeting.
     */
    init(lengthInMinutes: Int = 0, attendees: [DailyScrumModel.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        minutesRemaining = lengthInMinutes
        activeSpeaker = speakerText
    }
    
    /// Start the timer.
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    
    /// Advance the timer to the next speaker.
    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }
    
    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        minutesElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText
        timeRemainingForSpeakerInSeconds = minutesPerSpeaker*60
        minutesElapsed = index * minutesPerSpeaker
        minutesRemaining = lengthInMinutes - minutesElapsed
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(minutesElapsed: Int(secondsElapsed / 60))
            }
        }
    }
    
    private func update(minutesElapsed: Int) {
        minutesElapsedForSpeaker = minutesElapsed
        self.minutesElapsed = minutesPerSpeaker * speakerIndex + minutesElapsedForSpeaker
        guard minutesElapsed <= minutesPerSpeaker else {
            return
        }
        minutesRemaining = max(lengthInMinutes - self.minutesElapsed, 0)
        timeRemainingForSpeakerInSeconds = max(minutesPerSpeaker*60 - minutesElapsedForSpeaker*60 , 0)
        guard !timerStopped else { return }
        
        if minutesElapsedForSpeaker >= minutesPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }
    
    /**
     Reset the timer with a new meeting length and new attendees.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     - attendees: The name of each attendee.
     */
    func reset(lengthInMinutes: Int, attendees: [DailyScrumModel.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        minutesRemaining = lengthInMinutes
        activeSpeaker = speakerText
    }
}

extension DailyScrumModel {
    /// A new `ScrumTimer` using the meeting length and attendees in the `DailyScrum`.
    var timer: ScrumTimer {
        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
    }
}

extension Array where Element == DailyScrumModel.Attendee {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}
