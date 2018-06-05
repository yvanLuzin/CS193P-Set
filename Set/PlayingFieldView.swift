//
//  playingFieldView.swift
//  Set
//
//  Created by Иван Лузин on 03.06.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class PlayingFieldView: UIView {
    var grid: Grid?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

//        print("Awaken from Nib")
//        let cellSize = CGSize(width: playingFieldView.bounds.width/4, height: playingFieldView.bounds.width/4)
//        let grid = Grid(layout: .fixedCellSize(cellSize), frame: playingFieldView.bounds)
//
//        for i in 1...12 {
//            if let gridFrame = grid[i-1] {
//                playingFieldView.addSubview( SetCardView(frame: gridFrame) )
//            }
//        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
//        let cellSize = CGSize(width: self.bounds.width/4, height: self.bounds.width/4)
        grid = Grid(layout: .dimensions(rowCount: 9, columnCount: 9), frame: self.bounds)
        for i in 1...81 {
            if let gridFrame = grid?[i-1] {
                addSubview( SetCardView(frame: gridFrame) )
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        grid?.frame = self.bounds
        print(grid![0])
        for index in subviews.indices {
            subviews[index].frame = grid![index]!
        }

        //subviews should redraws\relayout too too

        //put grid initialization here
        //grid works fine when simulating same device as in storyboard
        //require to change bounds manually?
    }

}
