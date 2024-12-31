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
            // print("selected \(startEndHours[row]) in  Picker \(pickerView.tag)")
            let startHour = startHourPicker.selectedRow(inComponent: 0)
            let endHour = endHourPicker.selectedRow(inComponent: 0)
            let duration = calculateActiveDuration(start: startHour, end: endHour)
            updateIntervalOptions(duration: duration)
        case 3:
            let selection = intervalHours[row]
            // print("selected \(selection) in interval")
        default:
            // should not happen
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
        // save the start hour, end hour, and interval
        UserDefaults.standard.setValue(startHourPicker.selectedRow(inComponent: 0), forKey: BoHStartHour)
        UserDefaults.standard.setValue(endHourPicker.selectedRow(inComponent: 0), forKey: BoHEndHour)
        let interval = intervalHours[intervalHourPicker.selectedRow(inComponent: 0)]
        UserDefaults.standard.setValue(interval, forKey: BoHInterval)
        
        // save the user's selection of thoughts or jokes
        let thoughtOrJokeIndex = ThoughtJoke.selectedSegmentIndex
        var joke: Bool = false
        if thoughtOrJokeIndex != UISegmentedControl.noSegment && thoughtOrJokeIndex != 0 {
            joke = true
        }
        UserDefaults.standard.setValue(joke, forKey: BoHJokesSelected)

        // clear any previous notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        UserDefaults.standard.setValue(disableNotificationsSwitch.isOn, forKey: BoHNotificationsDisabled)
        
        // schedule new notifications unless they have been disabled
        let hours = notificationHours()
        if !disableNotificationsSwitch.isOn {
           
            // print("Setting notifications for \(hours)")
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
        UserDefaults.standard.setValue(true, forKey: BoHSettingsComplete)
        
        // confirm their selections to the user.
        // "You will receive a notification for a new joke at 9am, 11am, 1pm, 3pm, 5pm"
        // "You will receive a new abstract thought every day at 8pm, 11pm, 1am"
        let hoursStr = hours.map({ self.startEndHours[$0] }).joined(separator: ", ")
        let toRecieve = joke ? "joke" : "abstract thought"

        var message = "You will receive "
        if !disableNotificationsSwitch.isOn {
            message += "a notification for "
        }
        message += ("a new " + toRecieve + " every day at " + hoursStr)
        message += ("\nTap \"OK\" to continue or \"Cancel\" to clear settings")
        
        let alert = makeAlert(title: "Settings Saved", message: message) { action in
            switch action.title {
            case "OK":
                self.navigationController?.popViewController(animated: true)
            case "Cancel":
                self.clearSettings()
            default:
                return
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
        alert.addAction(cancelAction)
        return alert
    }
    
    func clearSettings() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        UserDefaults.standard.set(nil, forKey: BoHStartHour)
        UserDefaults.standard.set(nil, forKey: BoHEndHour)
        UserDefaults.standard.set(nil, forKey: BoHInterval)
        UserDefaults.standard.set(nil, forKey: BoHLastChecked)
        UserDefaults.standard.set(nil, forKey: BoHJokesSelected)
        UserDefaults.standard.set(nil, forKey: BoHSettingsComplete)
        UserDefaults.standard.set(nil, forKey: BoHNotificationsDisabled)
        startHourPicker.selectRow(9, inComponent: 0, animated: true)
        endHourPicker.selectRow(17, inComponent: 0, animated: true)
        
        let duration = calculateActiveDuration(start: 9, end: 17)
        updateIntervalOptions(duration: duration)
        intervalHourPicker.selectRow(0, inComponent: 0, animated: true)
        ThoughtJoke.selectedSegmentIndex = 0
        disableNotificationsSwitch.setOn(false, animated: true)
    }
        
}
