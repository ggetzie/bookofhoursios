//
//  BookOfHoursTests.swift
//  BookOfHoursTests
//
//  Created by Gabriel Getzie on 11/13/24.
//

import Foundation
import Testing
@testable import BookOfHours


let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()


struct BookOfHoursTests {
        

    @Test("Test when thought/joke index should increment", arguments: [
        
        // active time within one day, last checked outside active time
        (startHour:9, endHour: 17, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 08:15:00")!,
         currentTime:formatter.date(from: "2024-12-25 10:15:00")!,
         expected: true),
        
        // active time within one day, last checked and current time inside active time, spanning notification hour
        (startHour: 9, endHour: 17, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 10:15:00")!,
         currentTime: formatter.date(from: "2024-12-25 11:15:00")!,
         expected: true),
        
        // active time within one day, last checked and current time both between notifications
        (startHour: 9, endHour: 17, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 11:15:00")!,
         currentTime: formatter.date(from: "2024-12-25 11:20:00")!,
         expected: false),
        
        // active time within one day, last checked and current time both outside active time
        (startHour: 9, endHour: 17, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 18:15:00")!,
         currentTime: formatter.date(from: "2024-12-26 03:20:00")!,
         expected: false),
        
        // active time within one day, last checked more than a day ago
        (startHour: 9, endHour: 17, interval: 2,
         lastChecked: formatter.date(from: "2024-12-20 12:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 13:01:00")!,
         expected: true
        ),
        
        // only one notification per day, last checked less than a day
        // but before notification
        (startHour: 9, endHour: 9, interval: 0,
         lastChecked: formatter.date(from: "2024-12-25 08:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 13:01:00")!,
         expected: true
        ),
        
        // only one notification per day, last checked less than a day
        // but currentTime is before notification
        (startHour: 9, endHour: 9, interval: 0,
         lastChecked: formatter.date(from: "2024-12-25 08:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 08:59:00")!,
         expected: false
        ),
        
        // only one notification per day, last checked more than a day ago
        (startHour: 9, endHour: 9, interval: 0,
         lastChecked: formatter.date(from: "2024-12-24 08:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 13:01:00")!,
         expected: true
        ),
        
        // active time spans midnight, last checked before midnight
        // current time not yet notification
        (startHour: 17, endHour: 9, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 23:30:00")!,
         currentTime: formatter.date(from: "2024-12-26 00:03:00")!,
         expected: false
        ),
        
        // checking after end of active time, last check still in active time
        (startHour: 17, endHour: 9, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 08:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 09:01:00")!,
         expected: true
        ),
        
        // span midnight, last check and current both outside active time
        (startHour: 17, endHour: 9, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 09:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 11:01:00")!,
         expected: false
        ),
        
        // span midnight, last check in active time, current time
        // after a notification
        (startHour: 17, endHour: 9, interval: 2,
         lastChecked: formatter.date(from: "2024-12-25 11:30:00")!,
         currentTime: formatter.date(from: "2024-12-25 03:01:00")!,
         expected: true
        ),
        
        
    ]) func testShouldIncrement(startHour: Int, endHour: Int, interval: Int, lastChecked: Date, currentTime: Date, expected: Bool) async throws {
        
        print("Testing with startHour: \(startHour), endHour: \(endHour), interval: \(interval), lastChecked: \(lastChecked), currentTime: \(currentTime), expected: \(expected)")
        let result = shouldIncrement(startHour: startHour, endHour: endHour, interval: interval, lastChecked: lastChecked, currentTime: currentTime)
        #expect(result == expected)
        
    }

}
