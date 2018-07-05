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
    var isRearranged = false;

    var numberOfCardsOnField: Int {
        return subviews.indices.count
    }

    private func configureGrid() -> Grid {
        var cardSize: CGSize {
            switch numberOfCardsOnField {
            case 1...16:
                return CGSize(width: self.bounds.width/4, height: self.bounds.height/4)
            case 17...25:
                return CGSize(width: self.bounds.width/5, height: self.bounds.height/5)
            case 26...36:
                return CGSize(width: self.bounds.width/6, height: self.bounds.height/6)
            case 37...49:
                return CGSize(width: self.bounds.width/7, height: self.bounds.height/7)
            case 50...64:
                return CGSize(width: self.bounds.width/8, height: self.bounds.height/8)
            default:
                return CGSize(width: self.bounds.width/9, height: self.bounds.height/9)
            }
        }

        return Grid(layout: .fixedCellSize(cardSize), frame: self.bounds)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        grid = configureGrid()
        for index in subviews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [],
                animations: {
                    self.subviews[index].frame = self.grid[index]!
                },
                completion: { finish in
                    self.isRearranged = true
                }
            )
        }
    }
}
