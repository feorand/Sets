//
//  Card.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 27.12.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct CardOfPair {

    var isFlipped = false
    var isEnabled = true
    var id:Int
    
    init(withId id: Int) {
        self.id = id
    }
    
    mutating func flip() {
        isFlipped = !isFlipped
    }
}

extension CardOfPair: Equatable {
    public static func ==(lhs: CardOfPair, rhs: CardOfPair) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension CardOfPair: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
