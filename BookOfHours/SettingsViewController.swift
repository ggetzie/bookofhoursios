//
//  SettingsViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 12/7/24.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var startHourPicker: UIPickerView!
    @IBOutlet weak var endHourPicker: UIPickerView!
    @IBOutlet weak var intervalHourPicker: UIPickerView!
    @IBOutlet weak var ThoughtJoke: UISegmentedControl!
    @IBOutlet weak var HoursLabel: UILabel!
    @IBOutlet weak var disableNotificationsSwitch: UISwitch!
    
    let startEndHours = ["midnight", "1 am", "2 am", "3 am", "4 am", "5 am",
    "6 am", "7 am", "8 am", "9 am", "10 am", "11 am", "noon", "1 pm", "2 pm",
    "3 pm", "4 pm", "5 pm", "6 pm", "7 pm", "8 pm", "9 pm", "10 pm", "11 pm"]
    
    var intervalHours: [Int] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1, 2:
            return startEndHours.count
        case 3:
            return intervalHours.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 || pickerView.tag == 2 {
            return startEndHours[row]
        } else {
            return "\(intervalHours[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1, 2:
            print("selected \(startEndHours[row]) in  Picker \(pickerView.tag)")
            let startHour = startHourPicker.selectedRow(inComponent: 0)
            let endHour = endHourPicker.selectedRow(inComponent: 0)
            let duration = calculateActiveDuration(start: startHour, end: endHour)
            HoursLabel.text = "\(duration) Hours"
            updateIntervalOptions(duration: duration)
        case 3:
            let selection = intervalHours[row]
            print("selected \(selection) in interval")
        default:
            print("selected row in picker tagged \(pickerView.tag)")
        }
    }
            
    func notificationHours() -> [Int] {
        // create an array of hours at which to send notifications
        // These will be integers 0 - 23 indicating a time when a notification will be sent
        let startHour = startHourPicker.selectedRow(inComponent: 0)
        let endHour = endHourPicker.selectedRow(inComponent: 0)
        let interval = intervalHours[intervalHourPicker.selectedRow(inComponent: 0)]
        return getNotificationHours(startHour: startHour, endHour: endHour, interval: interval)
    }
                
    func updateIntervalOptions(duration: Int) {
        intervalHours = getIntervalOptions(duration: duration)
        intervalHourPicker.reloadAllComponents()
        
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        startHourPicker.delegate = self
        startHourPicker.dataSource = self
        startHourPicker.tag = 1
        
        
        endHourPicker.delegate = self
        endHourPicker.dataSource = self
        endHourPicker.tag = 2

        
        intervalHourPicker.delegate = self
        intervalHourPicker.dataSource = self
        intervalHourPicker.tag = 3
        
        let startHour = (UserDefaults.standard.object(forKey: BoHStartHour) ?? 9) as! Int
        let endHour = (UserDefaults.standard.object(forKey: BoHEndHour) ?? 17) as! Int
        
        startHourPicker.selectRow(startHour , inComponent: 0, animated: false)
        endHourPicker.selectRow(endHour , inComponent: 0, animated: false)
        let duration = calculateActiveDuration(start: startHour, end: endHour)
        updateIntervalOptions(duration: duration)
        
        let selectedInterval = (UserDefaults.standard.object(forKey: BoHInterval) ?? 0) as! Int
        
        let intervalIndex = intervalHours.firstIndex(of: selectedInterval) ?? 0
        intervalHourPicker.selectRow(intervalIndex, inComponent: 0, animated: false)
        
    }
  

    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save clicked")
        // store the list of notification hours in UserDefaults
        // store the selection of jokes or quotes
        // set up notifications
        // store that settings have been set


        // save the start hour and end hour
        UserDefaults.standard.setValue(startHourPicker.selectedRow(inComponent: 0), forKey: BoHStartHour)
        UserDefaults.standard.setValue(endHourPicker.selectedRow(inComponent: 0), forKey: BoHEndHour)
        
        // save the user's selection of thoughts or jokes
        let thoughtOrJokeIndex = ThoughtJoke.selectedSegmentIndex
        var joke: Bool = false
        if thoughtOrJokeIndex != UISegmentedControl.noSegment && thoughtOrJokeIndex != 0 {
            joke = true
        }
        UserDefaults.standard.setValue(joke, forKey: BoHJokes)

        // clear any previous notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // schedule new notifications unless they have been disabled
        if !disableNotificationsSwitch.isOn {
            let hours = notificationHours()
            print("Setting notifications for \(hours)")
            for hour in hours {
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let contentBody = "Time for a new \(joke ? "joke" : "abstract thought")"
                let content = UNMutableNotificationContent()
                content.title = "Book of Hours"
                content.body = contentBody
                content.sound = .default
                let request = UNNotificationRequest(identifier: "BoH_\(hour)", content: content, trigger: trigger)
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for \(self.startEndHours[hour])")
                    }
                }
            }
        }
        if UserDefaults.standard.object(forKey: BoHIndex) == nil {
            UserDefaults.standard.setValue(0, forKey: BoHIndex)
        }
        if UserDefaults.standard.object(forKey: BoHLastChecked) == nil {
            UserDefaults.standard.setValue(Date(), forKey: BoHLastChecked)
        }
        UserDefaults.standard.setValue(startHourPicker.selectedRow(inComponent: 0), forKey: BoHStartHour)
        UserDefaults.standard.setValue(endHourPicker.selectedRow(inComponent: 0), forKey: BoHEndHour)
        UserDefaults.standard.setValue(true, forKey: BoHSettingsComplete)
    }
}
