//
//  DiaryEntryViewCell.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 8/21/25.
//

import UIKit

class DiaryEntryViewCell: UITableViewCell {
    
    @IBOutlet weak var promptLabel: UILabel!
        
    
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    

}
