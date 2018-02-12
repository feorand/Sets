//
//  CardBehavior.swift
//  Sets
//
//  Created by Pavel Prokofyev on 12.02.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {

    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private func push(item: UIDynamicItem) {
        let behavior = UIPushBehavior()
        addChildBehavior(behavior)
        behavior.action = { self.removeChildBehavior(behavior) }
    }
    
    func addItem(item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        push(item: item)
    }
    
    func removeItem(item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
    }
    
    convenience init(at animator: UIDynamicAnimator) {
        self.init()
        
        animator.addBehavior(self)
        
        addChildBehavior(collisionBehavior)
    }
}
