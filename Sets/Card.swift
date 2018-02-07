//
//  Card.swift
//  Sets
//
//  Created by Pavel Prokofyev on 15.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class Card {
    static var AllPossibleCards: [Card] {
        var cardsStorage = [Card]()
        
        for number in Card.Number.all() {
            for symbol in Card.Symbol.all() {
                for shading in Card.Shading.all() {
                    for color in Card.Color.all() {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color)
                        cardsStorage.append(card)
                    }
                }
            }
        }
        
        return cardsStorage
    }
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color

    init(number: Number, symbol: Symbol, shading: Shading, color: Color) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.number == rhs.number &&
            lhs.shading == rhs.shading &&
            lhs.symbol == rhs.symbol
    }
}

extension Card {
    enum Number: Int {
        case number1, number2, number3
        static func all() -> [Number] {
            return [Number.number1, number2, number3]
        }
    }
    
    enum Symbol: Int {
        case symbol1, symbol2, symbol3
        static func all() -> [Symbol] {
            return [Symbol.symbol1, symbol2, symbol3]
        }
    }
    
    enum Shading: Int {
        case shading1, shading2, shading3
        static func all() -> [Shading] {
            return [Shading.shading1, shading2, shading3]
        }
    }
    
    enum Color: Int {
        case color1, color2, color3
        static func all() -> [Color] {
            return [Color.color1, color2, color3]
        }
    }
}
