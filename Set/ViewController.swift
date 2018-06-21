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

    @IBOutlet var playingFieldView: PlayingFieldView!
    {
        didSet {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            swipeGesture.direction = .down
            playingFieldView.addGestureRecognizer(swipeGesture)

            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(sender:)))
            playingFieldView.addGestureRecognizer(rotateGesture)
        }
    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        //BUG: Crashes when no card on field (all on the deck) and tries to replace cards
        guard game.deck.cards.count >= 3 else { return }

        if isMatched {
            game.replaceCards()
        } else {
            game.dealCards(3)
            addCardsOnField(3)
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        playingFieldView.subviews.forEach { $0.removeFromSuperview() }
        addCardsOnField(SetConstants.startingCardCount)
        updateViewFromModel()
    }

    func addCardsOnField(_ count: Int) {
        for _ in 0..<count {
            let card = SetCardView()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
            card.addGestureRecognizer(tapGesture)
            playingFieldView.addSubview(card)
        }
    }

    @objc private func touchCard(sender: UITapGestureRecognizer) {
        if let card = sender.view as? SetCardView {
            if let selectIndex = playingFieldView.subviews.index(of: card) {
                game.selectCard(selectIndex)
            }
        }
        updateViewFromModel()
    }

    @objc private func shuffleCards(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleCards()
            updateViewFromModel()
        default: break
        }
    }

    private func updateViewFromModel() {
        for index in game.cardsBeingPlayed.indices {
            let card = game.cardsBeingPlayed[index]

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

                cardView.isSelected = game.selectedCards.contains(card)

                if game.matchedCards.contains(card) {
                    cardView.isMatched = .matched
                } else if game.selectedCards.count > 2 && game.selectedCards.contains(card) {
                    cardView.isMatched = .mismatched
                } else {
                    cardView.isMatched = .idle
                }
            }
        }

        dealThreeMoreCardsButton.isEnabled = game.deck.cards.count > 0
        scoreLabel.text = "Score: \(game.score)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addCardsOnField(SetConstants.startingCardCount)
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

