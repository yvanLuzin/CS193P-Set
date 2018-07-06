//
//  ViewController.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

struct SetConstants {
    static var startingCardCount = 12
    static var numberOfCardsToDeal = 3
}

class SetViewController: UIViewController {

    var game = Set()

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var gravityBehavior: UIGravityBehavior = {
        let behavior = UIGravityBehavior()
        behavior.gravityDirection = CGVector(dx: 0, dy: 3)
        animator.addBehavior(behavior)
        return behavior
    }()

    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        behavior.collisionMode = .boundaries
        animator.addBehavior(behavior)
        return behavior
    }()

    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0.0
        return behavior
    }()

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var deckButton: UIButton!

    @IBOutlet var playingFieldView: PlayingFieldView!
    {
        didSet {
            /*
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            swipeGesture.direction = .down
            playingFieldView.addGestureRecognizer(swipeGesture)

            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(sender:)))
            playingFieldView.addGestureRecognizer(rotateGesture)
             */
        }
    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        if isMatched {
            game.replaceCards()
        } else {
            game.dealCards(SetConstants.numberOfCardsToDeal)
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        playingFieldView.subviews.forEach { $0.removeFromSuperview() }
        updateViewFromModel()
    }

    private func changeNumberOfCardsOnField(by count: Int) {
        if count >= 0 {
            for _ in 0..<count {
                let card = SetCardView()
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
                card.addGestureRecognizer(tapGesture)
                card.alpha = 0
                playingFieldView.addSubview(card)

                if let cardPositionInSubviews = playingFieldView.subviews.index(of: card) {
                    playingFieldView.subviews[cardPositionInSubviews].center = getPosition(of: deckButton)
                }
            }
        } else {
            for _ in 0..<abs(count) {
                playingFieldView.subviews.last?.removeFromSuperview()
            }
        }
    }

    @objc private func touchCard(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let card = sender.view as? SetCardView, let selectIndex = playingFieldView.subviews.index(of: card) {
                game.selectCard(selectIndex)
            }
            updateViewFromModel()
        default: break
        }
    }

    @objc private func shuffleCards(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleCards()
            updateViewFromModel()
        default: break
        }
    }

    private func getPosition(of view: UIView) -> CGPoint {
        let y = view.superview?.center.y
        let x = view.center.x

        return CGPoint(x: x, y: y ?? 0.0)
    }

    private func setCardAppearance(to cardView: SetCardView, from card: Card) {
        cardView.identifier = card.hashValue
        cardView.textualRepresentation = card.description

        // MARK: Deal animation
        if cardView.alpha == 0 {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: [],
                animations: {
                    cardView.alpha = 1
            }
            )
        }

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

        cardView.isSelected = game.selectedCards.contains(card)

        if game.matchedCards.contains(card) {
            cardView.isMatched = .matched

            // MARK: Fly away animation
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [],
                animations: {
                    cardView.alpha = 0
                },
                completion: { finish in
            })

            let temporaryView: SetCardView = {
                let view = SetCardView(frame: cardView.frame)
                view.shape = cardView.shape
                view.color = cardView.color
                view.shading = cardView.shading
                view.count = cardView.count
                return view
            }()

            view.addSubview(temporaryView)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1,
                delay: 0.0,
                options: [.repeat, .curveEaseInOut],
                animations: {
                    temporaryView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi.arc4random)
                }
            )

            collisionBehavior.addItem(temporaryView)
            itemBehavior.addItem(temporaryView)
            gravityBehavior.addItem(temporaryView)

            let push = UIPushBehavior(items: [temporaryView], mode: .instantaneous)
//            push.angle = CGFloat.pi.arc4random
            push.pushDirection = CGVector(dx: 5.arc4random, dy: -5)
            push.magnitude = (temporaryView.bounds.width + temporaryView.bounds.height)/2 * 0.05
            push.action = { [unowned push] in
                push.dynamicAnimator?.removeBehavior(push)
            }
            animator.addBehavior(push)

        } else if game.selectedCards.count > 2 && game.selectedCards.contains(card) {
            cardView.isMatched = .mismatched
        } else {
            cardView.isMatched = .idle
        }
    }

    private func updateViewFromModel() {

        var numberOfCards: Int {
            let result = game.cardsBeingPlayed.count - playingFieldView.subviews.count
            return result
        }

        changeNumberOfCardsOnField(by: numberOfCards)

        for index in playingFieldView.subviews.indices {
            if let cardView = (playingFieldView.subviews[index] as? SetCardView) {
                let card = game.cardsBeingPlayed[index]
                setCardAppearance(to: cardView, from: card)
            }

            playingFieldView.isRearranged = false
        }

        deckButton.isEnabled = !game.deck.cards.isEmpty || isMatched
        scoreLabel.text = "Sets: \(game.numberOfSets)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

