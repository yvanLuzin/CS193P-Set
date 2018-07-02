//
//  ViewController.swift
//  Concentration
//
//  Created by Иван Лузин on 11.04.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    // MARK: - properties

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    var theme = Theme(
        name: "Init",
        symbols: ["🐶", "🐱", "🐭", "🦊", "🐻", "🐸", "🐙", "🦁"],
        primaryColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),
        secondaryColor: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
        {didSet {
            updateViewFromModel()
        }}

    var emoji = [Int:String]()

    // MARK: - view outlets

    @IBOutlet var flipCountLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            for card in cardButtons {
                card.layer.cornerRadius = 3.0
            }
        }
    }

    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("not in array")
        }
    }

    @IBAction func beingNewGame(_ sender: Any) {
        game.beginNewGame()
        updateViewFromModel()
    }

    // MARK: - methods

    func updateViewFromModel() {
        guard cardButtons != nil else { return }

        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]

            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6832544749, blue: 0.05503074124, alpha: 0) : theme.primaryColor
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }

    func emoji(for card: ConcentrationCard) -> String {
        if emoji[card.identifier] == nil, theme.symbols.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(theme.symbols.count)))
            emoji[card.identifier] = theme.symbols.remove(at: randomIndex)
        }

        return emoji[card.identifier] ?? "?"
    }
}

