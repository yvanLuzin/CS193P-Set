//
//  playingFieldView.swift
//  Set
//
//  Created by Иван Лузин on 03.06.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class PlayingFieldView: UIView {
    lazy var grid: Grid = configureGrid()

    var numberOfCardsOnField: Int {
        return subviews.indices.count
    }

    private func configureGrid() -> Grid {
        var cardRatio: CGFloat {
            return 1.7
        }
        var grid = Grid(layout: .aspectRatio(cardRatio), frame: self.bounds)
        grid.cellCount = numberOfCardsOnField > 12 ? numberOfCardsOnField : 12
        return grid
    }

    override func layoutSubviews() {
        print("layout subviews")
        super.layoutSubviews()
        grid = configureGrid()
        guard numberOfCardsOnField <= grid.cellCount else { return }
    }

    
}
