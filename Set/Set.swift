//
//  Game.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

class Set {
    private(set) var deck = SetDeck()
    private(set) var cardsBeingPlayed = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var score = 0

    ///Append `amount` cards to `cardsInGame`
    ///BUG: Probably will crash when deck is empty
    ///TODO: Should replace matched cards
    func dealCards(_ amount: Int) {
        for _ in 0..<amount {
            if let card = deck.drawCard() {
                cardsBeingPlayed.append(card)
            }
        }
    }

    private func matchCard() {
        for feature in SetProperties.Feature.all {
            let amountOfMatchedFeatures = selectedCards.filter({ $0[feature] == selectedCards.first?[feature] }).count
            guard amountOfMatchedFeatures != 2 else {
                score -= 5
                return
            }
        }

        matchedCards += selectedCards
        score += 3
    }

    /// BUG: You can select already selected card after it was matched
    func selectCard(_ index: Int) {
        let card = cardsBeingPlayed[index]

        if selectedCards.count > 2 {
            replaceCards()
            selectedCards.removeAll()
        }

        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
            score -= 1
        } else {
            selectedCards.append(card)
        }

        if selectedCards.count == 3 {
            matchCard()
        }
    }

    func replaceCards() {
        for index in cardsBeingPlayed.indices {
            if matchedCards.contains(cardsBeingPlayed[index]) {
                cardsBeingPlayed.remove(at: index)
                cardsBeingPlayed.insert(deck.drawCard()!, at: index)
                selectedCards.removeAll()
            }
        }
    }

    func newGame() {
        deck.clearDeck()
        deck = SetDeck()
        cardsBeingPlayed.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        dealCards(SetConstants.startingCardCount)
        score = 0
    }

    init() {
        dealCards(SetConstants.startingCardCount)
    }
}
