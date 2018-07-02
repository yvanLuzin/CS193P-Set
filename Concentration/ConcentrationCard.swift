//
//  Card.swift
//  Concentration
//
//  Created by Иван Лузин on 17.04.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

struct ConcentrationCard {
    var isFaceUp = false
    var isMatched = false {
        didSet {
            isDiscovered = false
        }
    }
    var isDiscovered = false
    var identifier: Int

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
