//
//  CardBehavior.swift
//  Set
//
//  Created by Иван Лузин on 06.07.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    var snapPosition: CGPoint = CGPoint(x: 0, y: 0)

    lazy var gravityBehavior: UIGravityBehavior = {
        let behavior = UIGravityBehavior()
        behavior.gravityDirection = CGVector(dx: 0, dy: 3)
        return behavior
    }()

    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        behavior.collisionMode = .boundaries
        return behavior
    }()

    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 0.3
        behavior.resistance = 0.5
        return behavior
    }()

    private weak var timer: Timer?

    var snapBehavior: UISnapBehavior!

    private func snap(_ item: UIDynamicItem) {
        let snap = UISnapBehavior(item: item, snapTo: snapPosition)
        snap.damping = 1.0
        snapBehavior = snap
        snap.action = { [unowned snap] in
            snap.dynamicAnimator?.removeBehavior(snap)
        }
        addChildBehavior(snap)
    }

    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.pushDirection = CGVector(dx: 5.arc4random, dy: -5)
        push.magnitude = (item.bounds.width + item.bounds.height) * 0.1
        push.action = { [unowned push] in
            push.dynamicAnimator?.removeBehavior(push)
        }
        addChildBehavior(push)
    }

    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        gravityBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.35,
            repeats: false) { timer in
                self.snap(item)
        }
    }

    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        gravityBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }

    override init() {
        super.init()
        addChildBehavior(gravityBehavior)
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }

    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
