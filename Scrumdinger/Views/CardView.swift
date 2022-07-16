//
//  CardView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct CardView: View {
    var data: DailyScrumModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(data.title)
                    .font(.headline)
                Spacer()
                Text(data.date, style: .date)
                    .font(.caption)
                Image(systemName: "calendar")
                    .font(.caption)
            }
            Spacer()
            HStack {
                Label("\(data.attendees.count)", systemImage: "person.3")
                Spacer()
                Text(data.lengthInMinutes.formattedTime())
                Image(systemName: "clock")
                    .rotationEffect(Angle(degrees: 360))
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(data.theme.accentColor)
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(data: DailyScrumModel.sampleData[0])
            .background(DailyScrumModel.sampleData[0].theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}


