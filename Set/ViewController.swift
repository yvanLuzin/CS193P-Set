//
//  ViewController.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

struct SetConstants {
    static var startingCardCount = 12
}

class ViewController: UIViewController {

    var game = Set()

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var dealThreeMoreCardsButton: UIButton!

    @IBOutlet var playingFieldView: PlayingFieldView! {
        didSet {

        }
    }
//    {
//        didSet {
//            for view in playingFieldView.subviews {
//                let card = view as? SetCardView
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
//                card?.addGestureRecognizer(tapGesture)
//            }
//        }
//    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        if isMatched {
            game.replaceCards()
        } else {
            game.dealCards(3)
            playingFieldView.numberOfCardsToDraw = 3
            playingFieldView.setup(3)
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        playingFieldView.subviews.forEach { $0.removeFromSuperview() }
        playingFieldView.numberOfCardsToDraw = SetConstants.startingCardCount
        playingFieldView.setup(SetConstants.startingCardCount)
        updateViewFromModel()
    }

    @objc func touchCard(sender: UITapGestureRecognizer) {
//        print(self)
//        print(sender.view)
//        if let card = sender.view as? SetCardView {
//            print(playingFieldView.subviews.index(of: sender.view!)!)
//        }
//        print(playingFieldView.subviews)
    }

    private func updateViewFromModel() {
        for index in game.cardsBeingPlayed.indices {
            let card = game.cardsBeingPlayed[index]
//            print(playingFieldView.subviews.isEmpty)
            if let cardView = (playingFieldView.subviews[index] as? SetCardView) {
                cardView.textRepresentation = card.description
                cardView.identifier = card.hashValue

                switch card[.color] {
                    case .first: cardView.color = SetCardView.Color.red
                    case .second: cardView.color = SetCardView.Color.green
                    case .third: cardView.color = SetCardView.Color.purple
                }
                switch card[.shape] {
                    case .first: cardView.shape = SetCardView.Shape.diamond
                    case .second: cardView.shape = SetCardView.Shape.squiggle
                    case .third: cardView.shape = SetCardView.Shape.oval
                }
                switch card[.shading] {
                    case .first: cardView.shading = SetCardView.Shading.solid
                    case .second: cardView.shading = SetCardView.Shading.striped
                    case .third: cardView.shading = SetCardView.Shading.open
                }
                switch card[.count] {
                    case .first: cardView.count = SetCardView.Count.one.rawValue
                    case .second: cardView.count = SetCardView.Count.two.rawValue
                    case .third: cardView.count = SetCardView.Count.three.rawValue
                }
            }
        }

//        for card in playingFieldView.subviews {
//            print((card as! SetCardView).textRepresentation)
//        }

        dealThreeMoreCardsButton.isEnabled = game.deck.cards.count > 0
        scoreLabel.text = "Score: \(game.score)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

