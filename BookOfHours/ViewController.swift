//
//  ViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 11/13/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    var quoteIndex = 0
    
    override func viewDidLoad() {
        // Userdefaults.standard.set -- save data in userdefaults
        // UserDefaults.standard.object(forKey) -- retrieve data from userdefaults
        super.viewDidLoad()
        newQuote()
        if UserDefaults.standard.object(forKey: BoHSettingsComplete) == nil {
            performSegue(withIdentifier: "toSettings", sender: nil)
            return
        }
        
        print("Found \(jokes.count) jokes.")
        print("Found \(gnomics.count) quotes")

    }


    @IBAction func newQuoteTapped(_ sender: Any) {
        newQuote()
    }

    func newQuote() {
        
        quoteLabel.text = gnomics[quoteIndex]
        quoteIndex = (quoteIndex + 1) % gnomics.count
    }
}

