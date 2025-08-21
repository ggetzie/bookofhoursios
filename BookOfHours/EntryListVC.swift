//
//  EntryListVC.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 8/21/25.
//
import Foundation
import UIKit
import CoreData

class EntryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var entryListTable: UITableView!
    var entryArray = [Entry]()
    var selectedEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Diary Entries"
        print("Loaded entry list")
        entryListTable.delegate = self
        entryListTable.dataSource = self
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let asyncFetchRequest = NSAsynchronousFetchRequest<Entry>(fetchRequest: fetchRequest) { result in
            guard let entries = result.finalResult else {
                print("No entries found or fetch failed")
                return
            }
            print("Fetched \(entries.count) entries")
            if entries.isEmpty {
                self.title = "No diary entries yet"
            }
            self.entryArray = entries
            self.entryListTable.reloadData()
        }
        do {
            let _ = try context.execute(asyncFetchRequest)
        } catch {
            let nsError = error as NSError
            print("Fectch error: \(nsError), \(nsError.userInfo)")
        }
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleStyle", for: indexPath)
        let thisEntry = entryArray[indexPath.row]
        cell.textLabel?.text = thisEntry.prompt
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let formattedDate = formatter.string(from: thisEntry.created!)
        cell.detailTextLabel?.text = formattedDate
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetailVC" {
            let destinationVC = segue.destination as! EntryDetailVC
            destinationVC.selectedEntry = selectedEntry
            
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = entryArray[indexPath.row]
        
        performSegue(withIdentifier: "toEntryDetailVC", sender: nil)
    }
    
    
}
