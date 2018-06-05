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

    var numberOfCardsToDraw: Int = 12 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(12)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(12)
    }

    func setup(_ count: Int) {
        for i in 0..<count {
            if let gridFrame = grid[i] {
                addSubview( SetCardView(frame: gridFrame) )
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        grid = configureGrid()
        for index in subviews.indices {
            subviews[index].frame = grid[index]!
        }
    }
}
