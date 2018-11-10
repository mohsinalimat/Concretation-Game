//
//  ViewController.swift
//  Concretation
//
//  Created by Gerasim Israyelyan on 11/4/18.
//  Copyright © 2018 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concretation(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount: Int = 30 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var matchedCount: Int = 0
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        cardButtons.shuffle()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            if !game.cards[cardNumber].isFaceUp {
                flipCount -= 1
            }
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
        if flipCount == 0 {
            gameOver()
        }
        if flipCount == 10 {
            flipCountLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9817972716, green: 0.9817972716, blue: 0.9817972716, alpha: 1)
            } else{
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                button.setTitle("", for: UIControl.State.normal)
            }
            if card.isMatched {
                button.isEnabled = false
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                matchedCount += 1
            }
        }
        if matchedCount == cardButtons.count{
            completeGame()
        }
        matchedCount = 0
    }
    
    var emojiChoices = ["🦋","🦅","🐊","🐞","🐼","🐯","🦊","🦁","🦖","🕷","🐇","🐁","🐍","🐙","🐝","🐢","🐥","🦉","🦇","🦎"]
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    func completeGame() {
        performSegue(withIdentifier: "complete", sender: nil)
    }
    
    func gameOver() {
        performSegue(withIdentifier: "gameOver", sender: nil)

    }
    

}
