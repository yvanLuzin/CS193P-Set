//
//  Concentration.swift
//  Concentration
//
//  Created by Иван Лузин on 17.04.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [ConcentrationCard]()
    var flipCount = 0
    var score = 0
    /* var indexOfOneAndOnlyFaceUpCard: Int? */
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    func chooseCard(at index: Int) {
        if !cards[index].isMatched {

            //make sure not selecting already selected card
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
                //match second card
                if cards[matchedIndex].identifier == cards[index].identifier {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }

                if cards[matchedIndex].isDiscovered { score -= 1 }
                if cards[index].isDiscovered { score -= 1 }

                //turn second card up
                cards[index].isDiscovered = true
                cards[matchedIndex].isDiscovered = true

                cards[index].isFaceUp = true
                /* indexOfOneAndOnlyFaceUpCard = nil */
            } else {
                //flips all cards down
                /*
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }

                //turn selected card up
                cards[index].isFaceUp = true
                */
                indexOfOneAndOnlyFaceUpCard = index
            }

            flipCount += 1
        }
    }

    func beginNewGame() {
        for card in cards.indices {
            cards[card].isMatched = false
            cards[card].isFaceUp = false
        }
        indexOfOneAndOnlyFaceUpCard = nil
        shuffleDeck()
        flipCount = 0
        score = 0
    }

    func shuffleDeck() {
        for i in cards.indices {
            let j = Int(arc4random_uniform(UInt32(cards.reversed().count)))
            cards.swapAt(i, j)
        }
    }

    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        shuffleDeck()
    }
}
