//
//  Int+Extension.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 23/06/22.
//

import Foundation

extension Int {
    func formattedTime() -> String {
        let hours = self / 60
        let minutes = (self % 60)
        return (hours > 0 ? String(format: "%0.1dh",hours) : "") +
        (hours > 0 && minutes > 0 ? ":" : "") +
        (minutes > 0 ? String(format: "%0.2dm",minutes) : "")
    }
}
