//
//  Array+Extension.swift
//  Sets
//
//  Created by Pavel Prokofyev on 15.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension Array {
    func shuffled() -> [Element] {
        var result = self
        
        for i in 0..<count {
            let j = Int(arc4random_uniform(UInt32(count)))
            result.swapAt(i, j)
        }
        
        return result
    }
}
