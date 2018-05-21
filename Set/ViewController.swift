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
        game.dealCards(3)
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
    }

    @IBAction func touchCardButton(_ sender: UIButton) {
        if let cardNumber = cardButton.index(of: sender) {
            if game.selectedCards.count < 3 {
                let card = game.cardsBeingPlayed[cardNumber]

                if game.selectedCards.contains(card) {
                    game.selectedCards.remove(at: game.selectedCards.index(of: card)!)
                } else {
                    game.selectedCards.append(card)
                }
            } else {
                game.selectedCards.removeAll()
            }
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
            button.layer.borderColor = UIColor.blue.cgColor
        } else {
            button.layer.borderWidth = 0.0
        }
    }

    func updateViewFromModel() {
        for index in game.cardsBeingPlayed.indices {
            let button = cardButton[index]
            let card = game.cardsBeingPlayed[index]
            setButtonAppearance(card, for: button)
        }
        dealThreeMoreCardsButton.isEnabled = game.cardsBeingPlayed.count <= cardButton.count-3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

