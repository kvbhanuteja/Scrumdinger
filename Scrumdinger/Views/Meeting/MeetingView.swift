//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrumModel
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecongnizer = SpeechRecongnizer()
    @State var isRecording = true
    private var player: AVPlayer {
        return AVPlayer.sharedDingPlayer
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(minutesElapsed: scrumTimer.minutesElapsed,
                                  minutesRemaining: scrumTimer.minutesRemaining,
                                  theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers,
                                 theme: scrum.theme,
                                 recoding: isRecording,
                                 timeRemaining: scrumTimer.timeRemainingForSpeakerInSeconds)
                    .padding()
                MeetingFooterView(speakers: scrumTimer.speakers,
                                  skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            speechRecongnizer.reset()
            speechRecongnizer.transcribe()
            isRecording = true
            scrumTimer.startScrum()
        }
        .onDisappear {
            scrumTimer.stopScrum()
            speechRecongnizer.stopTranscribing()
            isRecording = false
            let history = HistoryModel(attendee: scrum.attendees,
                                       lengthInMinute: scrumTimer.minutesElapsed,
                                       transcript: speechRecongnizer.transcript)
            scrum.history.insert(history, at: 0)
        }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrumModel.sampleData[0]))
    }
}
