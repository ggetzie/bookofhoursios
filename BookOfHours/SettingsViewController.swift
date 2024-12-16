//
//  SettingsViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 12/7/24.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var startHourPicker: UIPickerView!
    @IBOutlet weak var endHourPicker: UIPickerView!
    @IBOutlet weak var intervalHourPicker: UIPickerView!
    
    
    @IBOutlet weak var HoursLabel: UILabel!
    
    
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
            print("selected row \(row) in  Picker \(pickerView.tag)")
            let interval = calculateInterval()
            HoursLabel.text = "\(interval) Hours"
            updateInterval()
        case 3:
            let selection = intervalHours[row]
            print("selected \(selection) in interval")
        default:
            print("selected row in picker tagged \(pickerView.tag)")
        }
    }
    
    func calculateInterval() -> Int {
        let start = startHourPicker.selectedRow(inComponent: 0)
        let end = endHourPicker.selectedRow(inComponent: 0)
        var interval: Int
        if start >= end {
            interval = end + 24 - start
        } else {
            interval = end - start
        }
        return interval
    }
    
    func divisors(number: Int) -> [Int] {
        var result = [1]
        for i in 2..<Int(Double(number).squareRoot()) + 1 {
            if number % i == 0 {
                if i * i != number {
                    result.append(i)
                    result.append(number / i)
                } else {
                    result.append(i)
                }
            }
        }
        return result.sorted()
    }
    
    func updateInterval() {
        let interval = calculateInterval()
        intervalHours = divisors(number: interval)
        intervalHourPicker.reloadAllComponents()
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startHourPicker.delegate = self
        startHourPicker.dataSource = self
        startHourPicker.tag = 1
        startHourPicker.selectRow(9, inComponent: 0, animated: false)
        
        endHourPicker.delegate = self
        endHourPicker.dataSource = self
        endHourPicker.tag = 2
        endHourPicker.selectRow(17, inComponent: 0, animated: false)
        
        intervalHourPicker.delegate = self
        intervalHourPicker.dataSource = self
        intervalHourPicker.tag = 3
        updateInterval()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save clicked")

        
    }
    
}
