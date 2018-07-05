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
//        for color in SetProperties.Value.all {
//            for shape in SetProperties.Value.all {
//                for shading in SetProperties.Value.all {
//                    for count in SetProperties.Value.all {
//                        cards.append(Card(colorValue: color, shapeValue: shape, shadingValue: shading, countValue: count))
//                    }
//                }
//            }
//        }

        for color in SetProperties.Value.all {
            for shading in SetProperties.Value.all {
                for count in SetProperties.Value.all {
                    cards.append(Card(colorValue: color, shapeValue: .second, shadingValue: shading, countValue: count))
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
