//
//  Game.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

class Set {
    var deck = SetDeck()
    private(set) var cardsBeingPlayed = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()

    ///Append `amount` cards to `cardsInGame`
    func dealCards(_ amount: Int) {
        for _ in 0..<amount {
            if let card = deck.drawCard() {
                cardsBeingPlayed.append(card)
            }
        }
    }

    func selectCard(_ card: Card) {
        selectedCards.append(card)
    }

    init() {
        dealCards(12)
    }
}
