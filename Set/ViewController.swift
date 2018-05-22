//
//  ViewController.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    var isBoardHaveEnoughSpace: Bool {
        return game.cardsBeingPlayed.count <= cardButton.count-3
    }

    @IBOutlet var scoreLabel: UILabel!

    ///Collection of cards on playing field
    @IBOutlet var cardButton: [UIButton]! {
        didSet {
            cardButton.forEach {
                $0.layer.cornerRadius = 8.0
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
            }
        }
    }

    @IBOutlet var dealThreeMoreCardsButton: UIButton!

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        if isMatched {
            game.replaceCards()
            print("replace")
        } else {
            game.dealCards(3)
            print("deal")
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        cardButton.forEach { (button) in
            button.setAttributedTitle(NSAttributedString(string: "", attributes: nil), for: .normal)
        }
        game.newGame()
        updateViewFromModel()
    }

    @IBAction func touchCardButton(_ sender: UIButton) {
        if let index = cardButton.index(of: sender) {
            guard index < game.cardsBeingPlayed.count else {return}
            game.selectCard(index)
            updateViewFromModel()
        }
    }

    /// Sets the appearance of `button` based on `card` enum options
    fileprivate func setButtonAppearance(_ card: Card, for button: UIButton) {
        let count = card.count.rawValue
        var color: UIColor {
            switch card.color {
            case .firstColor: return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            case .secondColor: return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            case .thirdColor: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
        var shape: String {
            switch card.shape {
            case .firstShape: return "▲"
            case .secondShape: return "●"
            case .thirdShape: return "■"
            }
        }
        var attributes: [NSAttributedStringKey:Any] {
            switch card.shading {
            case .firstShading:
                return [
                    NSAttributedStringKey.foregroundColor: color
                ]
            case .secondShading:
                return [
                    NSAttributedStringKey.strokeWidth: -8.0,
                    NSAttributedStringKey.strokeColor: color,
                    NSAttributedStringKey.foregroundColor: color.withAlphaComponent(0)
                ]
            case .thirdShading:
                return [
                    NSAttributedStringKey.strokeWidth: -8.0,
                    NSAttributedStringKey.strokeColor: color,
                    NSAttributedStringKey.foregroundColor: color.withAlphaComponent(0.3)
                ]
            }
        }

        button.setAttributedTitle(NSAttributedString(
            string:
                String(repeating: shape, count: count),
                attributes: attributes),
            for: .normal)

        if game.selectedCards.contains(card) {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        } else {
            button.layer.borderWidth = 0.0
        }

        var backgroundColor: CGColor {
            if game.matchedCards.contains(card) {
                return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            } else if game.selectedCards.count > 2 && game.selectedCards.contains(card) {
                return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            } else {
                return #colorLiteral(red: 0.9607843137, green: 0.9529411765, blue: 0.9450980392, alpha: 1)
            }
        }

        button.layer.backgroundColor = backgroundColor
    }

    func updateViewFromModel() {
        for index in game.cardsBeingPlayed.indices {
            let button = cardButton[index]
            let card = game.cardsBeingPlayed[index]
            setButtonAppearance(card, for: button)
        }

        ///TODO: move code removing empty cards here

        scoreLabel.text = "Score: \(game.score)"
        dealThreeMoreCardsButton.isEnabled = isBoardHaveEnoughSpace || isMatched
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

