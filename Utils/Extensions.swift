//
//  Utils.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        let random = CGFloat(arc4random_uniform(UInt32(100))) / 100
        return random * self
    }
}

extension Array {
    mutating func shuffle() {
        for i in self.indices {
            let j = self.count.arc4random
            self.swapAt(i, j)
        }
    }
}
