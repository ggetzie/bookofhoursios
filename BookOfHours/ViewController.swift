//
//  ViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 11/13/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        if UserDefaults.standard.object(forKey: BoHSettingsComplete) == nil {
            performSegue(withIdentifier: "toSettings", sender: nil)
            return
        }
        
        displayGnomicOrJoke()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayGnomicOrJoke()
    }
    
    func displayGnomicOrJoke() {
        // print("Found \(jokes.count) jokes.")
        // print("Found \(gnomics.count) quotes")
        
        let startHour = (UserDefaults.standard.object(forKey: BoHStartHour) ?? 9) as! Int
        let endHour = (UserDefaults.standard.object(forKey: BoHEndHour) ?? 17) as! Int
        let interval = (UserDefaults.standard.object(forKey: BoHInterval) ?? 2) as! Int
        let lastChecked = (UserDefaults.standard.object(forKey: BoHLastChecked) ?? Date()) as! Date
        let currentTime = Date()
        var index = (UserDefaults.standard.object(forKey: BoHIndex) ?? 0) as! Int
        let jokesSelected = (UserDefaults.standard.object(forKey: BoHJokesSelected) ?? false) as! Bool
        if shouldIncrement(startHour: startHour, endHour: endHour, interval: interval, lastChecked: lastChecked, currentTime: currentTime) {
            index += 1
            if jokesSelected {
                index = index % jokes.count
            } else {
                index = index % gnomics.count
            }
        }
        if jokesSelected {
            index = index >= jokes.count ? index % jokes.count : index
            quoteLabel.text = jokes[index]
        } else {
            index = index >= gnomics.count ? index % gnomics.count : index
            quoteLabel.text = gnomics[index]
        }
        UserDefaults.standard.setValue(index, forKey: BoHIndex)
        UserDefaults.standard.setValue(Date(), forKey: BoHLastChecked)
        
    }
}

