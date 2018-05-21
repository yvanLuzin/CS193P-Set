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

    ///Append `amount` cards to `cardsInGame`
    ///BUG: Probably will crash when deck is empty
    func dealCards(_ amount: Int) {
        for _ in 0..<amount {
            if let card = deck.drawCard() {
                cardsBeingPlayed.append(card)
            }
        }
    }

    /// TODO: Implement set rules of card matching
    func matchCard() {
        matchedCards += selectedCards
    }

    /// BUG: You can select already selected card after it was matched
    func selectCard(_ index: Int) {
        let card = cardsBeingPlayed[index]

        if selectedCards.count > 2 {
            for index in cardsBeingPlayed.indices {
                if matchedCards.contains(cardsBeingPlayed[index]) {
                    cardsBeingPlayed.remove(at: index)
                    cardsBeingPlayed.insert(deck.drawCard()!, at: index)
                }
            }
            selectedCards.removeAll()
        }

        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
        } else {
            selectedCards.append(card)
        }

        if selectedCards.count == 3 {
            matchCard()
        }
    }

    init() {
        dealCards(12)
    }
}
