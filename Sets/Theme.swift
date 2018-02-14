//
//  Theme.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 14.02.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

typealias Theme = (images:[String], backgroundColor: UIColor, foregroundColor: UIColor)

let themes:[String: Theme] = [
    "Halloween": (["👻", "🎃", "💀", "🦇", "🧙‍♀️", "🍎"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
    "Christmas": (["🌲", "☃️", "🍭", "🎅", "❄️", "👶"], #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
    "Faces": (["😀", "😂", "😘", "😎", "🤪", "😱"], #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
]
