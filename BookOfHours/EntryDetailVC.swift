//
//  EntryDetailVC.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 8/21/25.
//

import UIKit

class EntryDetailVC: UIViewController {
    
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var entryTextView: UITextView!
    
    var selectedEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptLabel.text = selectedEntry?.prompt ?? "No entry found"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let formattedDate = formatter.string(from: selectedEntry?.created! ?? Date())
        dateLabel.text = formattedDate
        
        entryTextView.text = selectedEntry?.text ?? ""
        

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

}
