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
    static var numberOfCardsToDeal = 3
}

class SetViewController: UIViewController {

    var game = Set()

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var deckButton: UIButton!

    @IBOutlet var playingFieldView: PlayingFieldView!
    {
        didSet {
            /*
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            swipeGesture.direction = .down
            playingFieldView.addGestureRecognizer(swipeGesture)

            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(sender:)))
            playingFieldView.addGestureRecognizer(rotateGesture)
             */
        }
    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        if isMatched {
            game.replaceCards()
        } else {
            game.dealCards(SetConstants.numberOfCardsToDeal)
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        playingFieldView.subviews.forEach { $0.removeFromSuperview() }
        updateViewFromModel()
    }

    private func changeNumberOfCardsOnField(by count: Int) {
        if count >= 0 {
            for _ in 0..<count {
                let card = SetCardView()
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
                card.addGestureRecognizer(tapGesture)
                card.alpha = 0
                playingFieldView.addSubview(card)
            }
        } else {
            for _ in 0..<abs(count) {
                playingFieldView.subviews.last?.removeFromSuperview()
            }
        }
    }

    @objc private func touchCard(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let card = sender.view as? SetCardView, let selectIndex = playingFieldView.subviews.index(of: card) {
                game.selectCard(selectIndex)
            }
            updateViewFromModel()
        default: break
        }
    }

    @objc private func shuffleCards(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleCards()
            updateViewFromModel()
        default: break
        }
    }

    private func setCardAppearance(to cardView: SetCardView, from card: Card) {
        cardView.identifier = card.hashValue
        cardView.textualRepresentation = card.description

        //deal animation
        if cardView.alpha == 0 {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [],
                animations: {
                    cardView.alpha = 1
            }
            )
        }

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

            //fly away animation
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [],
                animations: {
                    cardView.alpha = 0
                },
                completion: { finish in

            })
        } else if game.selectedCards.count > 2 && game.selectedCards.contains(card) {
            cardView.isMatched = .mismatched
        } else {
            cardView.isMatched = .idle
        }
    }

    private func updateViewFromModel() {

        var numberOfCards: Int {
            let result = game.cardsBeingPlayed.count - playingFieldView.subviews.count
            return result
        }

        changeNumberOfCardsOnField(by: numberOfCards)

        for index in playingFieldView.subviews.indices {
            if let cardView = (playingFieldView.subviews[index] as? SetCardView) {
                let card = game.cardsBeingPlayed[index]
                setCardAppearance(to: cardView, from: card)
            }

            playingFieldView.isRearranged = false
        }

        deckButton.isEnabled = !game.deck.cards.isEmpty || isMatched
        scoreLabel.text = "Sets: \(game.numberOfSets)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

