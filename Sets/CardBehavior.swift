//
//  CardBehavior.swift
//  Sets
//
//  Created by Pavel Prokofyev on 12.02.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0
        behavior.allowsRotation = true
        behavior.resistance = 0
        return behavior
    }()
    
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private func push(item: UIDynamicItem) {
        let behavior = UIPushBehavior(items: [item], mode: .instantaneous)
        behavior.angle = CGFloat.pi * CGFloat(arc4random_uniform(180)) / CGFloat(180)
        behavior.magnitude = 20
        behavior.action = { [unowned behavior, weak self] in self?.removeChildBehavior(behavior) }
        behavior.addItem(item)
        addChildBehavior(behavior)
    }
    
    func addItem(item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item: item)
    }
    
    func removeItem(item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(at animator: UIDynamicAnimator) {
        self.init()
        
        animator.addBehavior(self)
    }
}
