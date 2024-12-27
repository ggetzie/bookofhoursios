//
//  model.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 12/7/24.
//

import Foundation

let quotes: [String] = [
    "Ask not what your country can do for you, ask what you can do for your country.\n- John F Kennedy", // 1
    "Everybody has a plan until they get punched in the mouth.\n- Mike Tyson", // 2
    "I have never seen a thin person drinking Diet Coke.\n- Donald Trump", // 3
    "Be the change you want to see in the world.\n- Gandhi", // 4
    "That's one small step for man, one giant leap for mankind. - Neil Armstrong", // 5
    "Not all who wander are lost.\n- J.R.R. Tolkein", // 6
    "Daring in design, cautious in execution\n- John D. Rockefeller, Sr.", // 7
    "If you think something's supposed to hurt, you're less likely to notice if you're doing it wrong.\n- Paul Graham", // 8
    "Mr. McCabe thinks that I am not serious but only funny, because Mr. McCabe thinks funny is the opposite of serious. Funny is the opposite of not funny, and of nothing else.\n- G.K. Chesterton", // 9
    "Tragedy is when I cut my finger. Comedy is when you fall into an open sewer and die.\n- Mel Brooks", // 10
    "Let's think the unthinkable, let's do the undoable. Let us prepare to grapple with the ineffable itself, and see if we may not eff it after all.\n- Douglas Adams", // 11
    "You only live once, but if you do it right, once is enough.\n-Mae West", // 12
    "What are you gonna do, stab me?\n-Man who got stabbed", // 13
    "Well done is better than well said.\n-Benjamin Franklin", // 14
    "Do not go where the path may lead, go instead where there is no path and leave a trail.\n-Ralph Waldo Emerson", // 15
    "Be yourself; everyone else is already taken.\n-Oscar Wilde", // 16
    "You have brains in your head. You have feet in your shoes. You can steer yoruself any direction you choose.\n-Dr. Seuss", // 17
    "Do I contradict myself?? Very well then, I contradict myself. (I am large, I contain multitudes.)-\nWalt Whitman", // 18
    "May you live all the days of your life.\n-Jonathan Swift", // 19
    "In the depth of windter, I finally learned that within me there lay an invincible summer.\n-Albert Camus", // 20
    "We have nothing to fear but fear itself.\n-Franklin Delano Rooselvelt", // 21
    "I find that the harder I work, the more luck I seem to have.\n-Thomas Jefferson", // 22
    "The secret to success is to do the common thing uncommonly well.\n- John D. Rockefeller Jr.", // 23
    "Everything you can imagine is real.\n-Pablo Picasso" // 24
]

let jokes: [String] = [
    "What does a baby computer call his father?\nData", // 1
    "After an unsuccessful harvest, why did the farmer decide to try a career in music?\nBecause he had a ton of sick beets.", // 2
    "I just found out I’m colorblind. The news came out of the purple!", // 3
    "Never date a tennis player. Love means nothing to them.", // 4
    "I don't trust stairs. They're always up to something.", // 5
    "Have you heard about the restaurant on the moon? Great food, no atmosphere.", // 6
    "I used to hate facial hair, but then it grew on me.", // 7
    "What's blue and not very heavy? Light blue.", // 8
    "I just applied for a job down at the diner. I told them I really bring a lot to the table.", // 9
    "The inventor of the rotating coffin must be spinning in his grave.", // 10
    "Where do cows go for entertainment?\nTo the moo-vies.", // 11
    "Why should you never brush your teeth with your left hand?\nBecause a toothbrush works better.", // 12
    "Do you know the last thing my grandfather said to me before he kicked the bucket?\n\"Grandson, watch how far I can kick this bucket.\"", // 13
    "What do you call a fake noodle?\nAn impasta", // 14
    "Why can't a leopard hide?\nBecause he's always spotted", // 15
    "What do you get from a pampered cow?\nSpoiled Milk", // 16
    "Can a kangaroo jump higher than the Empire State Building?\nOf course! Buildings can't jump.", // 17
    "Did you hear about the book I'm reading about anti-gravity?\nIt's impossible to put down.", // 18
    "What did one ocean say to the other ocean?\nNothing they just waved.", // 19
    "How do you organize a space party?\nYou planet.", // 20
    "Why are skeletons so calm?\nBecause nothing gets under their skin.", // 21
    "What is a mummy's favorite food?\nWraps", // 22
    "What was the child who wouldn't nap guilty of?\nResisting a rest!", // 23
    "What runs around a baseball field but never moves?\nA fence.", // 24
]

// settings key to indicate if user has saved settings
let BoHSettingsComplete = "BoHSettingsComplete"

// settings key - true if jokes selected, false if thoughts selected
let BoHJokes = "BoHJokes"

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
