//
//  CardPile.swift
//  Set
//
//  Created by Иван Лузин on 06/03/2019.
//  Copyright © 2019 Иван Лузин. All rights reserved.
//

import UIKit

class CardPile: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var snapPosition: CGPoint {
        let newPosition = self.convert(self.bounds, to: superview)
        return CGPoint(x: newPosition.midX , y: newPosition.midY)
    }

    override func layoutSubviews() {
        print("Card pile layout")
        subviews.forEach { (card ) in
            card.frame = CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.height)
            card.bounds = CGRect(x: 0, y: 0, width: CardPile.Constants.width , height: CardPile.Constants.height)
        }
    }
}
