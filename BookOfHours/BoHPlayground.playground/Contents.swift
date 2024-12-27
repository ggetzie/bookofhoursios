import UIKit
import Foundation
var greeting = "Hello, playground"

let now = Date()
print(now.ISO8601Format())

let later = now + TimeInterval(60*60)

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter
}()
let d = formatter.date(from: "2024-12-25 18:36:00")!
print(d)
shouldIncrement(startHour: 9, endHour: 17, interval: 2, lastChecked: formatter.date(from:"2024-12-25 10:15:00")!, currentTime: formatter.date(from:"2024-12-25 11:12:00")!)

getNotificationHours(startHour: 17, endHour: 9, interval: 2)
