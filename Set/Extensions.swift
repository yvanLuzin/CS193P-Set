//
//  Utils.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

//extension Array {
//    func matched(by feature: Card.Feature) {
//        let buffer = self[0]
//
//        return self.filter({ (element: Card) -> Bool in
//            element.feature
//        })
//    }
//}
