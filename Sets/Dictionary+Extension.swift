//
//  Array+Extension.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 10.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension Dictionary {
    func randomElement() -> Value {
        let randomIndexInt = Int(arc4random_uniform(UInt32(count)))
        let randomCollectionIndex = index(startIndex, offsetBy: randomIndexInt)
        
        let randomKey = keys[randomCollectionIndex]
        return self[randomKey]!
    }
}
