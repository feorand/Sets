//
//  UICardView.swift
//  Sets
//
//  Created by Pavel Prokofyev on 23.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class UIBoardView: UIView {
    
    private(set) var cards: [Int: UICardView] = [:] { didSet { setNeedsLayout() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clearCardsFromView()
        
        let frames = calculateFramesForCards()
        updateCards(withFrames: frames)
        
        addCardsToView()
    }
    
    public func addCardView(key:Int, value: UICardView) {
        cards[key] = value
    }
    
    public func clearCards() {
        cards = [:]
    }
    
    private func clearCardsFromView() {
        _ = subviews
            .filter{ $0 is UICardView }
            .map{ $0.removeFromSuperview() }
    }
    
    private func calculateFramesForCards() -> Grid {
        var grid = Grid(layout: .aspectRatio(0.66), frame: bounds)
        grid.cellCount = cards.filter{ !$0.value.isHidden }.count
        return grid
    }
    
    private func updateCards(withFrames frames: Grid) {
//        for card in cards{
//            UIViewPropertyAnimator.runningPropertyAnimator(
//                withDuration: 1,
//                delay: 0,
//                options: [.curveEaseInOut],
//                animations: { card.value.frame = frames[card.key]! }
//            )
//        }
        
        for card in cards {
            card.value.frame = frames[card.key]!
        }
    }
    
    private func addCardsToView() {
        for card in cards {
            addSubview(card.value)
        }
    }
}
