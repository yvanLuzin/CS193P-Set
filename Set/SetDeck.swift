//
//  Deck.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

struct SetDeck {
    var cards = [Card]()

    init() {
        for color in Card.Color.all {
            for shape in Card.Shape.all {
                for number in Card.Count.all {
                    for shading in Card.Shading.all {
                        cards.append(Card(color: color, shape: shape, count: number, shading: shading))
                    }
                }
            }
        }
    }

    mutating func drawCard() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }

    mutating func clearDeck() {
        cards.removeAll()
    }
}
