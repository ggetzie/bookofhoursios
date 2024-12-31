//
//  model.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 12/7/24.
//

import Foundation

// settings key to indicate if user has saved settings
let BoHSettingsComplete = "BoHSettingsComplete"

// settings key - true if jokes selected, false if thoughts selected
let BoHJokesSelected = "BoHJokesSelected"

// settings key - the index of the current quote or joke to display
let BoHIndex = "BoHIndex"

// settings key - the last time the user checked the current thought or joke
let BoHLastChecked = "BoHLastChecked"

// settings key - the start hour for notifications
let BoHStartHour = "BoHStartHour"

// settings key - the end hour for notifications
let BoHEndHour = "BoHEndHour"

// settings key - the number hours between notifications
let BoHInterval = "BoHInterval"

// settings key - whether the user has disabled notifications
let BoHNotificationsDisabled = "BoHNotificationsDisabled"


func getNotificationHours(startHour: Int, endHour: Int, interval: Int) -> [Int] {
    // get an array of integers between 0 and 23 indicating the hours
    // of the day to send a notification
    if interval == 0 {
        return [startHour]
    }
    // adjust end in case we're going past midnight to the next day
    // e.g. from 10pm to 4am
    let counterEnd = endHour <= startHour ? endHour + 24 : endHour
    var hours: [Int] = []
    for hour in stride(from: startHour, through: counterEnd, by: interval) {
        hours.append(hour % 24)
    }
    return hours
}

func calculateActiveDuration(start: Int, end: Int) -> Int {
    // how many hours between start and end
    // start and end are integers between 0 and 23 representing hours
    // of the day. end may be less than start, representing a duration that
    // goes past middnight to the next day
    var duration: Int
    if start > end {
        duration = end + 24 - start
    } else {
        duration = end - start
    }
    return duration
}

func getIntervalOptions(duration: Int) -> [Int]{
    // how many hours the user may choose between notifications
    // set between 1 and half of the duration, so there are at least
    // 2 notifications, or 1 notification if the duration is 0
    // i.e. when start and end hour are the same
    if duration <= 0 {
        return [0]
    } else {
        return Array(1...((duration + 1)/2))
    }
}

func shouldIncrement(startHour: Int, endHour: Int, interval: Int, lastChecked: Date, currentTime: Date) -> Bool {
    // we should increment the joke/thought index if a notification has
    // occurred since lastChecked
   
    let hours = getNotificationHours(startHour: startHour, endHour: endHour, interval: interval)
    let calendar = Calendar.current
    let oneHour = TimeInterval(60*60)
    let oneDay = TimeInterval(60*60*24)
    if currentTime.timeIntervalSince(lastChecked) >= oneDay {
        return true
    }
    let currentHour = calendar.component(.hour, from: currentTime)
    if currentTime.timeIntervalSince(lastChecked) <= oneHour {
        // if it has been less than an hour since last checked, then
        // we should increment if we passed into a different hour
        // that is in the hours
        let lastCheckedHour = calendar.component(.hour, from: lastChecked)
        return (currentHour != lastCheckedHour) && hours.contains(currentHour)
    }

    let checkComponents = calendar.dateComponents([.year, .month, .day, .hour], from: lastChecked)
    var check = calendar.date(from: checkComponents)!
    // increment one hour at a time from lastChecked until now
    // if we reach an hour that is in the hours array, we have
    // passed a notification time
    while check <= currentTime {
        check = check + oneHour
        let checkHour = calendar.component(.hour, from: check)
        if hours.contains(checkHour) {
            return true
        }
    }
    return false
}
