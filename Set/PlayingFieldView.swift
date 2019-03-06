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

    var initialPosition: CGRect?

    private func configureGrid() -> Grid {
        var cardRatio: CGFloat {
            return self.bounds.width / self.bounds.height
        }

        var grid = Grid(layout: .aspectRatio(cardRatio), frame: self.bounds)
        grid.cellCount = numberOfCardsOnField > 12 ? numberOfCardsOnField : 12

        return grid
    }

    override func layoutSubviews() {
        grid = configureGrid()

        guard numberOfCardsOnField <= grid.cellCount else { return }

        for index in subviews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: SetViewController.Constants.animationTime,
                delay: 0,
                options: [],
                animations: {
                    self.subviews[index].frame = self.grid[index]!
            },
                completion: { finish in

            }
            )
        }
    }

    /*
    override func layoutSubviews() {
        super.layoutSubviews()

        if initialPosition == nil {
            grid = configureGrid()
            print("YEP")
            for index in subviews.indices {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: SetViewController.Constants.animationTime,
                    delay: 0,
                    options: [],
                    animations: {
                        self.subviews[index].frame = self.grid[index]!
                },
                    completion: { finish in
                        
                }
                )
            }
        } else {
            for index in subviews.indices {
                subviews[index].frame = initialPosition!
            }
        }
    }
    */
}
