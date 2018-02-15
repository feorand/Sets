//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 14.02.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ThemeChooseViewController: UIViewController {
    
    var lastSeguedVC:ConcentrationViewController?
    
    @IBAction func themeButtonPressed(sender: UIButton) {        
        let name = nameOf(sender: sender)
        let theme = themes[name]!
        (splitViewController?.viewControllers.last as? ConcentrationViewController)?.currentTheme = theme
    }

    private func nameOf(sender: Any?) -> String {
        let senderButton = sender! as! UIButton
        return senderButton.title(for: .normal)!
    }
}
