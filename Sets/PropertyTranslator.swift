//
//  PropertyTranslator.swift
//  Sets
//
//  Created by Pavel Prokofyev on 26.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct PropertyTranslator {
    static let Numbers: [Card.Number : Int] = [
        .number1: 1,
        .number2: 2,
        .number3: 3
    ]
    
    static let Symbols: [Card.Symbol : UICardView.Symbol] = [
        .symbol1: .circle,
        .symbol2: .diamond,
        .symbol3: .triangle
    ]
    
    static let Shadings: [Card.Shading : UICardView.Shading] = [
        .shading1: .open,
        .shading2: .solid,
        .shading3: .striped
    ]
    
    static let Colors: [Card.Color : UIColor] = [
        .color1: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
        .color2: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
        .color3: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    ]
    
    static func ViewFrom(card: Card) -> UICardView {
        let number = Numbers[card.number]!
        let symbol = Symbols[card.symbol]!
        let shading = Shadings[card.shading]!
        let color = Colors[card.color]!
        return UICardView(frame: CGRect.zero, number: number, symbol: symbol, shading: shading, color: color)
    }
    
    static func CardFrom(view: UICardView) -> Card {
        let number = Numbers.first(where: { $0.value == view.number })!.key
        let symbol = Symbols.first(where: { $0.value == view.symbol })!.key
        let shading = Shadings.first(where:{ $0.value == view.shading })!.key
        let color = Colors.first(where: { $0.value == view.color })!.key
        return Card(number: number, symbol: symbol, shading: shading, color: color)
    }
}
