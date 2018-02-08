//
//  UICardView.swift
//  Sets
//
//  Created by Pavel Prokofyev on 23.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class UIBoardView: UIView {
    
    private var cardsCount = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFrames()
    }
    
    private func updateFrames() {
        var grid = Grid(layout: .aspectRatio(0.64), frame: bounds)
        grid.cellCount = cardsCount
        
        for i in 0..<cardsCount {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { self.subviews[i].frame = grid[i]! }
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
        cardsCount += 1
    }
    
    func removeLast() {
        subviews.last!.removeFromSuperview()
        cardsCount -= 1
    }
}
