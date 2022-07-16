//
//  EditDetailsView.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 08/06/22.
//

import SwiftUI

struct EditDetailsView: View {
    @Binding var data: DailyScrumModel.Data
    @State var attendeeName = ""
    @State private var calendarId: Int = 0
    
    let datesRange: ClosedRange<Date> = {
        let component = Calendar.current
        let todayComponents = component.dateComponents([.year, .month, .day], from: Date())
        let startDate = DateComponents(year: todayComponents.year,
                                       month: todayComponents.month,
                                       day: todayComponents.day)
        let endDate = DateComponents(year: (todayComponents.year ?? 0) + 1,
                                     month: todayComponents.month,
                                     day: todayComponents.day)
        return component.date(from: startDate)! ... component.date(from: endDate)!
    }()
        
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $data.title)
                DatePicker("Pick Date",
                           selection: $data.date,
                           in: datesRange,
                           displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .id(calendarId)
                    .onChange(of: data.date, perform: { _ in
                      calendarId += 1
                    })
                    .onTapGesture {
                      calendarId += 1
                    }
                
                DatePicker("Start Time",
                           selection: $data.startTime,
                           displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)

                DatePicker("End Time",
                           selection: $data.endTime,
                           in: Calendar.current.date(byAdding: .minute, value: 5, to: data.startTime)! ... Calendar.current.date(byAdding: .minute, value: 3600, to: data.startTime)!,
                           displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)
                
                ThemePickerView(selectedTheme: $data.theme)
            } header: {
                Text("Meeting info")
            }
           
            Section {
                ForEach(data.attendees) {attendee in
                    Text(attendee.name)
                }
                .onDelete { index in
                    data.attendees.remove(atOffsets: index)
                }
            } header: {
                Text("Attendee")
            }
            HStack {
            TextField("Attendee", text: $attendeeName)
                Button {
                    withAnimation {
                        let attendee = DailyScrumModel.Attendee(name: attendeeName)
                        data.attendees.append(attendee)
                        attendeeName = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(attendeeName.isEmpty)
            }

        }
    }
}

struct EditDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EditDetailsView(data: .constant( DailyScrumModel.sampleData[0].data))
    }
}
