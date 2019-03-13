//
//  ViewController.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    var game = Set()

    private var delayedCards: [SetCardView] = []

    var isMatched: Bool {
        return game.selectedCards.count > 0 && game.selectedCards.suffix(3) == game.matchedCards.suffix(3)
    }

    lazy var animator = UIDynamicAnimator(referenceView: view)

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var scoreView: UIView!

    @IBOutlet var deckButton: UIButton!

    @IBOutlet var playingFieldView: PlayingFieldView!
    {
        didSet {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            swipeGesture.direction = .down
            playingFieldView.addGestureRecognizer(swipeGesture)

            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(sender:)))
            playingFieldView.addGestureRecognizer(rotateGesture)
        }
    }

    @IBAction func dealThreeMoreCards(_ sender: UIButton?) {
        if isMatched {
            game.replaceCards()
        } else {
            game.dealCards(Set.Constants.numberOfCardsToDeal)
        }
        updateViewFromModel()
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        playingFieldView.subviews.forEach { $0.removeFromSuperview() }
        updateViewFromModel()
    }

    private func changeNumberOfCardsOnField(by count: Int, action: @escaping () -> Void) {
        if count >= 0 {
            for _ in 0..<count {
                let card = SetCardView()
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
                card.addGestureRecognizer(tapGesture)
                card.alpha = CGFloat(Set.Constants.Animation.alpha)
                playingFieldView.addSubview(card)
            }
        } else {
            for _ in 0..<abs(count) {
                playingFieldView.subviews.last?.removeFromSuperview()
            }
        }

        playingFieldView.layoutIfNeeded()

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Set.Constants.Animation.layout,
            delay: 0,
            options: [],
            animations: {
                for index in self.playingFieldView.subviews.indices {
                    self.playingFieldView.subviews[index].frame = self.playingFieldView.grid[index]!
                }
        },
            completion: { finish in
                action()
        }
        )
    }

    @objc private func touchCard(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let card = sender.view as? SetCardView,
                let selectIndex = playingFieldView.subviews.index(of: card) {
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

            //MARK: Fly away animation
            flyAwayAnimation(for: cardView)

        } else if game.selectedCards.count > 2 && game.selectedCards.contains(card) {
            cardView.isMatched = .mismatched
        } else {
            cardView.isMatched = .idle
        }
    }

    private func flyAwayAnimation(for cardView: SetCardView) {
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 2,
//            delay: 0,
//            options: [],
//            animations: {
//                cardView.alpha = CGFloat(Set.Constants.Animation.alpha)
//            })

        cardView.alpha = CGFloat(Set.Constants.Animation.alpha)

        var cardBehavior = CardBehavior(in: animator)

        let temporaryView: SetCardView = {
            let newFrame = view.convert(cardView.frame, to: scoreView)
            let temporaryView = SetCardView(frame: newFrame)
            temporaryView.shape = cardView.shape
            temporaryView.color = cardView.color
            temporaryView.shading = cardView.shading
            temporaryView.count = cardView.count
            return temporaryView
        }()

        var snapPosition: CGPoint {
            let newPosition = scoreView.convert(scoreView.bounds, to: view)
            return CGPoint(x: newPosition.midX , y: newPosition.midY)
        }

        scoreView.addSubview(temporaryView)

        cardBehavior.addItem(temporaryView)
        cardBehavior.snapPosition = snapPosition

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.25,
            delay: 0.25,
            options: [.repeat, .curveEaseInOut],
            animations: {
                temporaryView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi.arc4random)
                temporaryView.bounds.size.width = CGFloat(CardPile.Constants.width)
                temporaryView.bounds.size.height = CGFloat(CardPile.Constants.height)
            },
            completion: { position in
                temporaryView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            }
        )
    }

    private func updateViewFromModel() {
        var numberOfCards: Int {
            let result = game.cardsBeingPlayed.count - playingFieldView.subviews.count
            return result
        }

        changeNumberOfCardsOnField(by: numberOfCards) {
            for index in self.playingFieldView.subviews.indices {
                if let cardView = (self.playingFieldView.subviews[index] as? SetCardView) {
                    let card = self.game.cardsBeingPlayed[index]
                    self.setCardAppearance(to: cardView, from: card)
                }
            }
            self.game.replaceCards()
            self.dealAnimationHanlder(for: self.playingFieldView.subviews as! [SetCardView])
        }

        deckButton.isEnabled = !game.deck.cards.isEmpty || isMatched
        scoreLabel.text = "Sets: \(game.numberOfSets)"
    }

    private func dealAnimationHanlder(for collection: [SetCardView]) {
        var animatorsList: [UIViewPropertyAnimator] = []

        print(collection.count);

        collection.forEach { (cardView) in
            guard cardView.alpha == CGFloat(Set.Constants.Animation.alpha) else { return }

            let position: CGRect = cardView.frame
            let tempPosition: CGRect = deckButton.convert(deckButton.bounds, to: view)

            cardView.frame = tempPosition
            cardView.alpha = 1
            cardView.isFaceUp = !cardView.isFaceUp

            let animator = {
                UIViewPropertyAnimator(
                    duration: Set.Constants.Animation.deal,
                    curve: .easeIn,
                    animations: {
                        cardView.frame = position
                })
            }()

            animator.addCompletion({ _ in
                UIView.transition(with: cardView,
                                  duration: Set.Constants.Animation.deal,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                      cardView.isFaceUp = !cardView.isFaceUp
                                  },
                                  completion: nil)
            })

            animatorsList.append(animator)
        }

        guard !animatorsList.isEmpty else { return }

        animatorsList.forEach { (animator) in
            if let currentIndex = animatorsList.firstIndex(of: animator) {
                let nextIndex = animatorsList.index(currentIndex, offsetBy: 1)
                if nextIndex < animatorsList.count {
                    animator.addCompletion({ _ in
                        animatorsList[nextIndex].startAnimation()
                    })
                }
            }
        }

        animatorsList.first?.startAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animator.delegate = self
        game.delegate = self
        updateViewFromModel()
    }

    override func viewDidLayoutSubviews() {
        playingFieldView.setNeedsLayout()
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SetViewController: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        animator.removeAllBehaviors()
        //        scoreView.setNeedsLayout()
    }
}

extension SetViewController: SetDelegate {
    func didMatchCards() {
//        dealThreeMoreCards(nil)
    }
}
