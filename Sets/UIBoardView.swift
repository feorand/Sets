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
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { view.frame = grid[index]! }
            )
        }
    }
    
    func updateCardView(at index: Int, with cardView: UICardView) {
        cardView.frame = subviews[index].frame
        
        let subviewCard = subviews[index] as! UICardView
        subviewCard.color = cardView.color
        subviewCard.isSelected = cardView.isSelected
        subviewCard.number = cardView.number
        subviewCard.shading = cardView.shading
        subviewCard.symbol = cardView.symbol
    }
    
    func add(cardView: UICardView) {
        addSubview(cardView)
        setNeedsLayout()
    }
    
    func removeLast() {
        subviews.last!.removeFromSuperview()
        setNeedsLayout()
    }
}
