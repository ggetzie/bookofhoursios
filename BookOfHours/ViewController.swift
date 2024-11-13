//
//  ViewController.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 11/13/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    
    let quotes: [String] = [
        "Ask not what your country can do for you, ask what you can do for your country. - John F Kennedy",
        "Everybody has a plan until they get punched in the mouth. - Mike Tyson",
        "I have never seen a thin person drinking Diet Coke. - Donald Trump",
        "Be the change you want to see in the world. - Gandhi",
        "That's one small step for man, one giant leap for mankind. - Neil Armstrong",
        "Not all who wander are lost. - J.R.R. Tolkein",
        "Daring in design, cautious in execution - John D. Rockefeller, Sr.",
        "If you think something's supposed to hurt, you're less likely to notice if you're doing it wrong. - Paul Graham",
        "Mr. McCabe thinks that I am not serious but only funny, because Mr. McCabe thinks funny is the opposite of serious. Funny is the opposite of not funny, and of nothing else. - G.K. Chesterton",
        "Tragedy is when I cut my finger. Comedy is when you fall into an open sewer and die. - Mel Brooks",
        "Let's think the unthinkable, let's do the undoable. Let us prepare to grapple with the ineffable itself, and see if we may not eff it after all. - Douglas Adams"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newQuote()
    }


    @IBAction func newQuoteTapped(_ sender: Any) {
        newQuote()
    }

    func newQuote() {
        let randomIndex = Int(arc4random_uniform(UInt32(quotes.count)))
        quoteLabel.text = quotes[randomIndex]
    }
}

