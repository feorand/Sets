//
//  UICardView.swift
//  Sets
//
//  Created by Pavel Prokofyev on 23.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class UIBoardView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFrames()
    }
    
    private func updateFrames() {
        let notHiddenSubviews = subviews.filter{ !$0.isHidden }
        var grid = Grid(layout: .aspectRatio(0.64), frame: bounds)
        grid.cellCount = notHiddenSubviews.count
        
        for (index, view) in notHiddenSubviews.enumerated() {
            if view.frame == CGRect.zero {
                view.frame = grid[index]!
                continue
            }
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { view.frame = grid[index]! }
            )
        }
    }
    
    func updateCardView(index: Int, cardView: UICardView) {
        let subviewCard = subviews[index] as! UICardView
        subviewCard.color = cardView.color
        subviewCard.number = cardView.number
        subviewCard.shading = cardView.shading
        subviewCard.symbol = cardView.symbol
        
        setNeedsDisplay()
    }
    
    func add(cardView: UICardView) {
        addSubview(cardView)
        setNeedsLayout()
    }
    
    func removeLast() {
        subviews.last!.removeFromSuperview()
        setNeedsLayout()
    }
    
    func clearAll() {
        for view in subviews {
            view.removeFromSuperview()
        }
        setNeedsLayout()
    }
}
