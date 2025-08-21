//
//  ViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 11/13/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    
    
    @IBOutlet weak var entryTextbox: UITextView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        if UserDefaults.standard.object(forKey: BoHSettingsComplete) == nil {
            performSegue(withIdentifier: "toSettings", sender: nil)
            return
        }
        
        displayGnomicOrJoke()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayGnomicOrJoke()
    }
    
    
    func displayGnomicOrJoke() {
        // print("Found \(jokes.count) jokes.")
        // print("Found \(gnomics.count) quotes")
        print("display gnomic or joke called")
        
        let startHour = (UserDefaults.standard.object(forKey: BoHStartHour) ?? 9) as! Int
        let endHour = (UserDefaults.standard.object(forKey: BoHEndHour) ?? 17) as! Int
        let interval = (UserDefaults.standard.object(forKey: BoHInterval) ?? 2) as! Int
        let lastChecked = (UserDefaults.standard.object(forKey: BoHLastChecked) ?? Date()) as! Date
        let currentTime = Date()
        var index = (UserDefaults.standard.object(forKey: BoHIndex) ?? 0) as! Int
        let jokesSelected = (UserDefaults.standard.object(forKey: BoHJokesSelected) ?? false) as! Bool
        if shouldIncrement(startHour: startHour, endHour: endHour, interval: interval, lastChecked: lastChecked, currentTime: currentTime) {
            print("getting new index")
            index = newIndex(oldIndex: index, maxVal: jokesSelected ? jokes.count : gnomics.count)
        } else {
            print("no index update required")
        }
        if jokesSelected {
            quoteLabel.text = jokes[index % jokes.count]
        } else {
            quoteLabel.text = gnomics[index % gnomics.count]
        }
        UserDefaults.standard.setValue(index, forKey: BoHIndex)
        UserDefaults.standard.setValue(Date(), forKey: BoHLastChecked)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Save clicked, text box text: \(entryTextbox.text ?? "")")
        if (entryTextbox.text == "" || entryTextbox.text == nil) {
            let alert = UIAlertController(title:"Error", message: "Please enter some text", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let newEntry = Entry(context: context)
        newEntry.id = UUID()
        newEntry.text = self.entryTextbox.text!
        newEntry.created = Date()
        newEntry.prompt = self.quoteLabel.text!
        do {
            try context.save()
            let alert = UIAlertController(title:"Success", message: "Saved!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            entryTextbox.text = ""
        } catch {
            let nsError = error as NSError
            let alert = UIAlertController(title:"Error", message: "Could not save! \(nsError)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
    
}

