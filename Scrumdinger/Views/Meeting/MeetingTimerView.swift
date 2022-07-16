//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 17/06/22.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    let theme: Theme
    let recoding: Bool
    var timeRemaining: Int
    
    private var currentSpeaker: String {
            speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
        }
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Text(currentSpeaker)
                        .font(.title)
                    Text("is speaking")
                    Image(systemName: recoding ? "mic" : "mic.slash")
                        .font(.title)
                        .padding(.top)
                    VStack {
                        Text("Time Remaining for \(currentSpeaker): ")
                        Text(timer(time: self.timeRemaining))
                    }
                    .padding(.top)
                }
                .foregroundColor(theme.accentColor)
            }
            .overlay {
                ForEach(speakers) { speaker in
                    if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                            .rotation(Angle(degrees: -90.0))
                            .stroke(theme.mainColor, lineWidth: 12)
                            .clipped()
                    }
                }
            }
    }
    
    func timer(time: Int) -> String {
            let hours = time / 3600
            let minutes = time / 60
        return (hours > 0 ? String(format: "%0.1dh",hours) : "") +
        (hours > 0 && minutes > 0 ? ":" : "") +
        (minutes > 0 ? String(format: "%0.2dm",minutes) : "")
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var speakers: [ScrumTimer.Speaker] {
            [ScrumTimer.Speaker(name: "Bill", isCompleted: true), ScrumTimer.Speaker(name: "Cathy", isCompleted: false)]
        }
    static var previews: some View {
        MeetingTimerView(speakers: speakers, theme: .yellow, recoding: true, timeRemaining: 5)
    }
}
