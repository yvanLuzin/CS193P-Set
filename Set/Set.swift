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
    private(set) var numberOfSets = 0

    func dealCards(_ amount: Int) {
        for _ in 0..<amount {
            if let card = deck.drawCard() {
                cardsBeingPlayed.append(card)
            }
        }
    }

    private func matchCard() {
        var matchingResults = [Int]()

        for feature in SetProperties.Feature.all {
            let amountOfMatchedFeatures = selectedCards.filter({ $0[feature] == selectedCards.first?[feature] }).count
            matchingResults.append(amountOfMatchedFeatures)
        }

        if matchingResults.contains(2) {
            score -= 5
        } else {
            matchedCards += selectedCards
            score += 3
            numberOfSets += 1
        }
    }

    private func matchAnyCard() {
        matchedCards += selectedCards
        score += 3
        numberOfSets += 1
    }

    func selectCard(_ index: Int) {
        let card = cardsBeingPlayed[index]

        guard !matchedCards.contains(card) else { print("no"); return }

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
            if Options.isDebug {
                matchAnyCard()
            } else {
                matchCard()
            }
        }
    }

    func replaceCards() {
        let count = cardsBeingPlayed.count-1
        for index in stride(from: count, through: 0, by: -1) {
            if matchedCards.contains(cardsBeingPlayed[index]) {
                cardsBeingPlayed.remove(at: index)
                if let newCard = deck.drawCard() {
                    cardsBeingPlayed.insert(newCard, at: index)
                }
                selectedCards.removeAll()
            }
        }
    }

    func shuffleCards() {
        cardsBeingPlayed.shuffle()
    }

    func newGame() {
        deck.clearDeck()
        deck = SetDeck()
        cardsBeingPlayed.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        dealCards(Set.Constants.startingCardCount)
        score = 0
        numberOfSets = 0
    }

    init() {
        dealCards(Set.Constants.startingCardCount)
    }
}
