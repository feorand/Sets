//
//  UICardView.swift
//  Sets
//
//  Created by Pavel Prokofyev on 23.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class UIBoardView: UIView {
    
    var cards: [UICardView] = [] { didSet { setNeedsLayout() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clearCardsFromView()
        let frames = calculateFramesForCards()
        updateCards(withFrames: frames)
        
        addCardsToView()
    }
    
    private func clearCardsFromView() {
        _ = subviews
            .filter{ $0 is UICardView }
            .map{ $0.removeFromSuperview() }
    }
    
    private func calculateFramesForCards() -> Grid {
        var grid = Grid(layout: .aspectRatio(0.66), frame: bounds)
        grid.cellCount = cards.filter{ !$0.isHidden }.count
        return grid
    }
    
    private func updateCards(withFrames frames: Grid) {
        for (index, card) in cards.enumerated() {
            card.frame = frames[index]!
        }
    }
    
    private func addCardsToView() {
        for card in cards {
            addSubview(card)
        }
    }
}
