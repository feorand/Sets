//
//  Game.swift
//  Sets
//
//  Created by Pavel Prokofyev on 15.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct Game {
    
    private(set) var score = 0
    private(set) var isOver = false
    private(set) var displayedCards: [Int: Card]
    private(set) var selectedCards: [Int]

    private var timeSinceLastSet: Date
    private var deck: [Card]
    
    var isDeckEmpty: Bool {
        return deck.isEmpty
    }

    init(numberOfCards: Int) {
        deck = Card.AllPossibleCards.shuffled()
        timeSinceLastSet = Date()
        displayedCards = [:]
        selectedCards = []
        
        dealCards(number:numberOfCards)
    }
    
    mutating func askToDealThreeCards() {
        dealCards(number: 3)
        
        if findSet() != nil {
            score -= 3
        }
    }
    
    mutating func select(card: Card) -> [Int:Card]? {
        let key = displayedCards.first(where: { $0.value == card })!.key
        return select(key: key)
    }
    
    mutating func select(key: Int) -> [Int:Card]? {
        if let lastSelected = selectedCards.last, lastSelected == key {
            selectedCards.removeLast()
            return nil
        }
        
        if selectedCards.count == 2 && displayedCards.count == 3 {
            isOver = true
        }
        
        if selectedCards.count < 3 {
            selectedCards.append(key)
            return nil
        }
        
        if isSetSelected() {
            let elapsedTime = Date().timeIntervalSince(timeSinceLastSet)
            timeSinceLastSet = Date()
            score += 10 + max(0, 10 - Int(elapsedTime))
            
            let previousSelectedCards = displayedCards.filter{ selectedCards.contains($0.key) }
            removeSelectedCards()
            dealCards(number: 3)
            selectedCards.append(key)
            
            return previousSelectedCards
        } else {
            score -= 5
            selectedCards = [key]
        }
        
        return nil
    }
    
    mutating func getHint() {
        switch selectedCards.count {
        case 0:
            if let foundSet = findSet() {
                _ = select(key: foundSet[0])
                score -= 5
            } else {
                dealCards(number: 3)
            }
        case 1, 2:
            if let foundSet = findSet(withFixedCards: selectedCards) {
                let firstUnselectedCard = foundSet.first(where: {!selectedCards.contains($0)})!
                _ = select(key: firstUnselectedCard)
                score -= 5
            } else {
                selectedCards.removeLast()
            }
        case 3:
            if isSetSelected() {
                removeSelectedCards()
                dealCards(number: 3)
                getHint()
            } else {
                selectedCards = []
                getHint()
            }
        default:
            break
        }
    }
    
    private mutating func dealCards(number: Int) {
        for _ in 0..<number where !deck.isEmpty {
            let indexOfFirstEmptySlot = findFirstEmptySlot()
            displayedCards[indexOfFirstEmptySlot] = deck.removeLast()
        }        
    }
    
//    private mutating func dealCard() -> Card? {
//        return deck.isEmpty ? nil : deck.removeLast()
//    }
//
//    private mutating func replaceCardWithDealt(index: Int) {
//        if let dealtCard = dealCard() {
//            displayedCards[index] = dealtCard
//        } else {
//            //TODO: replace rubrange with empty array
//        }
//    }
    
    private func isSetSelected() -> Bool {
        if selectedCards.count < 3 { return false }
        
        return isSet(key1: selectedCards[0], key2: selectedCards[1], key3: selectedCards[2])
    }
    
    private func isSet(key1: Int, key2: Int, key3: Int) -> Bool {
//        let card1 = displayedCards[key1]!
//        let card2 = displayedCards[key2]!
//        let card3 = displayedCards[key3]!
//
//        let isNumberSet = isPropertySet(value1: card1.number, value2: card2.number, value3: card3.number)
//        let isColorSet = isPropertySet(value1: card1.color, value2: card2.color, value3: card3.color)
//        let isShadingSet = isPropertySet(value1: card1.shading, value2: card2.shading, value3: card3.shading)
//        let isSymbolSet = isPropertySet(value1: card1.symbol, value2: card2.symbol, value3: card3.symbol)
//        return isShadingSet && isSymbolSet && isNumberSet && isColorSet
        
        return true
    }
    
    private func isPropertySet<T: Equatable>(value1: T, value2: T, value3: T) -> Bool {
        let areAllSame = (value1 == value2 && value2 == value3)
        let areAllDirrefent = (value1 != value2 && value2 != value3 && value3 != value1)
        return areAllSame || areAllDirrefent
    }
    
    private func findSet(withFixedCards fixedCards: [Int] = []) -> [Int]? {
        let firstCardCandidates = fixedCards.count == 0 ? displayedCards : [fixedCards[0]:displayedCards[fixedCards[0]]!]
        let secondCardCandidates = fixedCards.count <= 1 ? displayedCards : [fixedCards[1]:displayedCards[fixedCards[1]]!]
        let thirdCardCandidates = fixedCards.count <= 2 ? displayedCards : [fixedCards[2]:displayedCards[fixedCards[2]]!]
        
        for key1 in firstCardCandidates.keys {
            for key2 in secondCardCandidates.keys where key1 != key2 {
                for key3 in thirdCardCandidates.keys where key1 != key3 && key2 != key3 {
                    if isSet(key1: key1, key2: key2, key3: key3) {
                        return [key1, key2, key3]
                    }
                }
            }
        }
        
        return nil
    }
    
    private func findFirstEmptySlot() -> Int {
        var i = 0
        while displayedCards[i] != nil {
            i += 1
        }
        return i
    }
    
    mutating private func removeSelectedCards() {
        for cardKey in selectedCards {
            displayedCards[cardKey] = nil
        }
        selectedCards = []
    }
    
    mutating public func shuffleDisplayCards() {
        let positionlessDisplayedCards = Array(displayedCards.values)
        let shuffledpositionlessDisplayCards = positionlessDisplayedCards.shuffled()
        
        for (key, card) in zip(displayedCards.keys, shuffledpositionlessDisplayCards) {
            displayedCards[key] = card
        }
    }
}
