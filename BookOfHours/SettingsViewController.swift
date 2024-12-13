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
    
    
    let startEndHours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let AMPM = ["AM", "PM"]
    var intervalHours = [1, 2, 4]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 || pickerView.tag == 2 {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1, 2:
            if component == 0 {
                return startEndHours.count
            } else {
                return AMPM.count
            }
        case 3:
            return intervalHours.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 || pickerView.tag == 2 {
            if component == 0 {
             return "\(startEndHours[row])"
            } else {
                return AMPM[row]
            }
        } else {
            return "\(intervalHours[row])"
        }
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
