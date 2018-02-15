//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 14.02.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ThemeChooseViewController: UIViewController {
    
    var lastShownConcentrationVC:ConcentrationViewController?
    
    @IBAction func themeButtonPressed(sender: UIButton) {
        if let cvc = splitViewController?.viewControllers.last as? ConcentrationViewController {
            setThemeOf(cvc, toNameOf: sender)
        } else {
            if let cvc = lastShownConcentrationVC {
                setThemeOf(cvc, toNameOf: sender)
                navigationController?.pushViewController(cvc, animated: true)
            } else {
                performSegue(withIdentifier: "Chose Theme", sender: sender)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("Chose Theme"):
            let controller = segue.destination as! ConcentrationViewController
            setThemeOf(controller, toNameOf: sender)
            lastShownConcentrationVC = controller
        default: break
        }
    }
    
    private func concentrationAsSplitVC() -> ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private func setThemeOf(_ controller:ConcentrationViewController, toNameOf sender: Any?) {
        let senderButton = sender! as! UIButton
        let name = senderButton.title(for: .normal)!
        let theme = themes[name]!
        controller.currentTheme = theme
    }
}
