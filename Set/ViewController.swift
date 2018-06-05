//
//  ViewController.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var dealThreeMoreCardsButton: UIButton!

    @IBOutlet var playingFieldView: UIView!
//    {
//        didSet {
//            let cellSize = CGSize(width: playingFieldView.bounds.width/4, height: playingFieldView.bounds.width/4)
//            let grid = Grid(layout: .fixedCellSize(cellSize), frame: playingFieldView.bounds)
//
//            for i in 1...12 {
//                if let gridFrame = grid[i-1] {
//                    playingFieldView.addSubview( SetCardView(frame: gridFrame) )
//                }
//            }
//        }
//    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
//        if isMatched {
//            game.replaceCards()
//        } else {
//            game.dealCards(3)
//        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        for index in game.cardsBeingPlayed.indices {
            let card = game.cardsBeingPlayed[index]
            if let cardView = (playingFieldView.subviews[index] as? SetCardView) {
                cardView.textRepresentation = card.description

                switch card[.color] {
                    case .first: cardView.color = SetCardView.Color.red
                    case .second: cardView.color = SetCardView.Color.green
                    case .third: cardView.color = SetCardView.Color.purple
                }
                switch card[.shape] {
                    case .first: cardView.shape = SetCardView.Shape.diamond
                    case .second: cardView.shape = SetCardView.Shape.squiggle
                    case .third: cardView.shape = SetCardView.Shape.oval
                }
                switch card[.shading] {
                    case .first: cardView.shading = SetCardView.Shading.solid
                    case .second: cardView.shading = SetCardView.Shading.striped
                    case .third: cardView.shading = SetCardView.Shading.open
                }
                switch card[.count] {
                    case .first: cardView.count = SetCardView.Count.one.rawValue
                    case .second: cardView.count = SetCardView.Count.two.rawValue
                    case .third: cardView.count = SetCardView.Count.three.rawValue
                }
            }
        }

        for card in playingFieldView.subviews {
            print((card as! SetCardView).textRepresentation)
        }

        scoreLabel.text = "Score: \(game.score)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
//        playingFieldView.addSubview(SetCardView(frame: CGRect(x: 0, y: 0, width: playingFieldView.frame.width/2, height: 120)))
//        playingFieldView.addSubview(SetCardView(frame: CGRect(x: playingFieldView.frame.width/2, y: 0, width: playingFieldView.frame.width/2, height: 120)))
//        print(playingFieldView.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

