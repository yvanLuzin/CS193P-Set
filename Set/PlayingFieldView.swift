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
    var isRearranged = false

    var numberOfCardsOnField: Int {
        return subviews.indices.count
    }

    var delegate: PlayingFieldViewDelegate?

    private func configureGrid() -> Grid {
        var cardRatio: CGFloat {
            return 1.7
        }

        var grid = Grid(layout: .aspectRatio(cardRatio), frame: self.bounds)
        grid.cellCount = numberOfCardsOnField > 12 ? numberOfCardsOnField : 12

        return grid
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        grid = configureGrid()
        guard numberOfCardsOnField <= grid.cellCount else { return }

        isRearranged = true

        print("Layout animation")
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Set.Constants.Animation.layout,
            delay: 0,
            options: [],
            animations: {
                for index in self.subviews.indices {
                    self.subviews[index].frame = self.grid[index]!
                }
        },
            completion: { finish in
                self.delegate?.playingFieldViewFinishedLayout()
                self.isRearranged = false
        }
        )
    }
}

protocol PlayingFieldViewDelegate {
    func playingFieldViewFinishedLayout()
}
