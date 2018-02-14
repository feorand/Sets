//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Prokofyev on 04.12.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var flipCardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    var currentTheme: Theme = themes["Faces"]! {
        didSet {
            setTheme()
            UpdateGameView(flips: game.flipCount, score: game.score)
        }
    }
    
    var game:Concentration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
        
        startNewGame()
        UpdateGameView(flips: 0, score: 0)
        setTheme()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard let index = flipCardButtons.index(of: sender) else { return }
        
        game.flipCard(number: index)
        
        if game.isOver {
            startNewGame()
        }
        
        UpdateGameView(flips: game.flipCount, score: game.score)
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
        UpdateGameView(flips: 0, score: 0)
    }
    
    private func UpdateGameView(flips:Int, score:Int) {
        for i in 0..<flipCardButtons.count {
            if game.cards[i].isFlipped {
                flipCardButtons[i].setTitle(currentTheme.images[game.cards[i].id], for: .normal)
                flipCardButtons[i].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                flipCardButtons[i].setTitle("", for: .normal)
                flipCardButtons[i].backgroundColor = currentTheme.foregroundColor
            }
            
            if !game.cards[i].isEnabled {
                flipCardButtons[i].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                flipCardButtons[i].setTitle("", for: .normal)
            }
            
            flipCardButtons[i].isEnabled = game.cards[i].isEnabled
        }
        
        flipCountLabel.text = "Flips:\(flips)"
        scoreLabel.text = "Score:\(score)"
    }
    
    private func startNewGame() {
        game = Concentration(numberOfPairs: 6)
    }
    
    private func setTheme() {
        view.backgroundColor = currentTheme.backgroundColor
                
        flipCountLabel.textColor = currentTheme.foregroundColor
        scoreLabel.textColor = currentTheme.foregroundColor
        newGameButton.setTitleColor(currentTheme.foregroundColor, for: .normal)
    }
}

extension ConcentrationViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

