//
//  Constants.swift
//  Set
//
//  Created by Иван Лузин on 06.07.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

extension Set {
    struct Constants {
        struct Animation {
            static var deal = 1.0
            static var flyaway = 1.0
            static var layout = 0.3 //0.3
        }
        static var startingCardCount = 12 //12
        static var numberOfCardsToDeal = 3 //3
    }
}

extension CardPile {
    struct Constants {
        static var width = 85
        static var height = 50
    }
}

struct Options {
    static var isDebug = true
}
