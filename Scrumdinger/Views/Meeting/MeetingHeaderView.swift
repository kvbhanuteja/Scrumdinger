//
//  MeetingHeaderView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 09/06/22.
//

import SwiftUI

struct MeetingHeaderView: View {
    var minutesElapsed: Int
    var minutesRemaining: Int
    var theme: Theme
    @State private var isRotated = false
    private var totalMinutes: Int {
        return minutesElapsed + minutesRemaining
    }
    
    private var progress: Double {
        guard totalMinutes > 0 else {return 1}
        return Double(minutesElapsed) / Double(totalMinutes)
    }
    
    var animation: Animation {
        Animation.easeOut
        .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10) {
            ProgressView(value: progress)
                .progressViewStyle(ScrumProgessViewStyle(theme: theme))
            HStack {
                VStack(alignment: .leading) {
                    Text("Minutes Elapsed")
                        .font(.caption)
                    HStack {
                        Text("\(minutesElapsed)")
                        Image(systemName: "hourglass.bottomhalf.fill")
                            .animation(animation)
                            .rotationEffect(Angle.degrees(isRotated ? 180 : 0))
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Minutes Remaining")
                        .font(.caption)
                    HStack {
                        Text("\(minutesRemaining)")
                        Image(systemName: "hourglass.tophalf.fill")
                            .animation(animation)
                            .rotationEffect(Angle.degrees(isRotated ? 180 : 0))

                    }
                    
                }
            }
        }
        .padding([.top, .horizontal])
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.isRotated.toggle()
            }
        }
    }
}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(minutesElapsed: 60, minutesRemaining: 600, theme: .bubblegum)
            .previewLayout(.sizeThatFits)
    }
}
