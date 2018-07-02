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

    let DEBUG = true

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    var theme: Theme!

    var emoji = [Int:String]()

    var themes = [
        Theme(
            name: "animals",
            symbols: ["🐶", "🐱", "🐭", "🦊", "🐻", "🐸", "🐙", "🦁"],
            primaryColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
        Theme(
            name: "sports",
            symbols: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱"],
            primaryColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)),
        Theme(
            name: "hearts",
            symbols: ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "💖"],
            primaryColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
            secondaryColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(
            name: "things",
            symbols: ["☎️", "📺", "💽", "🕹", "🎛", "⏰", "🔋", "💡"],
            primaryColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)),
        Theme(
            name: "cars",
            symbols: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑"],
            primaryColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
        Theme(
            name: "travel",
            symbols: ["🗿", "🗽", "🗼", "🏰", "🏯", "🏟", "🏝", "⛲️"],
            primaryColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))
    ]

    // MARK: - view outlets

    @IBOutlet var flipCountLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

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
        selectRandomTheme()
    }

    // MARK: - methods

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]

            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                DEBUG
                    ? button.setTitle(String(card.identifier), for: .normal)
                    : button.setTitle("", for: .normal)

                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6832544749, blue: 0.05503074124, alpha: 0) : theme.primaryColor
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }

    func selectRandomTheme() {
        let randomTheme = Int(arc4random_uniform(UInt32(themes.count)))
        theme = themes[randomTheme]
        view.backgroundColor = theme.secondaryColor
        if !emoji.isEmpty { emoji.removeAll() }
    }

    func emoji(for card: ConcentrationCard) -> String {
        if emoji[card.identifier] == nil, theme.symbols.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(theme.symbols.count)))
            emoji[card.identifier] = theme.symbols.remove(at: randomIndex)
        }

        return emoji[card.identifier] ?? "?"
    }

    // MARK: - lifecycle

    override func viewDidLoad() {
        selectRandomTheme()
    }
}

