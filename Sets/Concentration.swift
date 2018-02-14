//
//  Game.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 27.12.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [CardOfPair]()
    var seenCards = Set<CardOfPair>()
    private(set) var flipCount = 0
    private(set) var score = 0
    var isOver = false
    var lastCardTime: Date? = nil
    var bonus = 0
    
    init(numberOfPairs: Int) {
        var nextId: Int = 0
        
        func newId() -> Int {
            let newId = nextId
            nextId += 1
            return newId
        }
        
        for _ in 0..<numberOfPairs {
            let card = CardOfPair(withId: newId())
            cards += [card, card]
        }
        
        shuffleCards()
    }
    
    private func getRandomNumber(upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(cards.count)))
    }
    
    private func shuffleCards() {
        for _ in 0...20 {
            let firstElementIndex = getRandomNumber(upperBound: cards.count)
            let secondElementIndex = getRandomNumber(upperBound: cards.count)
            cards.swapAt(firstElementIndex, secondElementIndex)
        }
    }
    
    private func getFlippedCards() -> [CardOfPair] {
        return cards.filter{$0.isFlipped}
    }
    
    func win() {
        isOver = true
    }
    
    private func isWinningConditionMet() -> Bool {
        let hiddenCardsCount = cards.filter{!$0.isEnabled}.count
        return (hiddenCardsCount == cards.count - 2)
    }
    
    func flipCard(number:Int) {
        guard cards[number].isEnabled else { return }
        
        var flippedCards = getFlippedCards()
        
        switch flippedCards.count {
        case 0:
            cards[number].flip()
        case 1:
            cards[number].flip()
            
            if isWinningConditionMet() {
                win()
            }
        case 2:
            if flippedCards[0] == flippedCards[1] {
                for i in 0..<cards.count {
                    if !cards[i].isFlipped { continue }
                    cards[i].flip()
                    cards[i].isEnabled = false
                }
                
                score += 20
                score += bonus

            } else {
                for i in 0..<cards.count {
                    if !cards[i].isFlipped { continue }
                    cards[i].flip()
                }
                
                for card in flippedCards {
                    if seenCards.contains(card) {
                        score -= 5
                    }
                }
            }
            
            seenCards.insert(flippedCards[0])
            seenCards.insert(flippedCards[1])
            
            flipCard(number: number)
        default :
            print("class Game - illegal number of flippedCards: \(flippedCards.count)")
        }
        
        if let lastCardTime = lastCardTime {
            let timeElapsed = Date().timeIntervalSince(lastCardTime)
            bonus = calculateBonusScore(ofTimeElapsed: timeElapsed)
            
            self.lastCardTime = Date()
        } else {
            lastCardTime = Date()
        }

        flipCount += 1
    }
    
    private func calculateBonusScore(ofTimeElapsed time:TimeInterval) -> Int {
        let rawValue = Int(10 + 1 - time)
        return rawValue > 0 ? rawValue : 0
    }
}
