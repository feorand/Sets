//
//  ViewController.swift
//  Sets
//
//  Created by Pavel Prokofyev on 15.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var board: UIBoardView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var game:Game! { didSet { updateViewFromModel() }}
    
    //MARK:- UIViewController method overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateGestured(recognizer:)))
        view.addGestureRecognizer(rotationRecognizer)
                
        startNewGame()
    }
    
    //MARK:- Handling touches and gestures
    
    @IBAction func newGameButtonTouch() {
        startNewGame()
    }
    
    @IBAction func giveHintButtonTouch() {
        game.getHint()
        updateViewFromModel()
    }
    
    @IBAction func deckButtonTouch() {
        guard !game.isDeckEmpty else { return }
        
            game.askToDealThreeCards()
            updateViewFromModel()
    }
    
    @objc func cardTouched(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let cardView = recognizer.view! as! UICardView
        
        let card = PropertyTranslator.CardFrom(view: cardView)
        
        game.select(card: card)
        updateViewFromModel()
        
        if game.isOver {
            startNewGame()
        }
    }
    
    @objc func rotateGestured(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .ended {
            game.shuffleDisplayCards()
            updateViewFromModel()
        }
    }
    
    //MARK:- Utility
    
    private func addGestureRecognizersToCard(card: UICardView) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cardTouched(recognizer:)))
        card.addGestureRecognizer(recognizer)
    }
    
    private func updateViewFromModel() {
        for (key, card) in game.displayedCards.sorted(by: { $0.key < $1.key }) {
            let cardView = PropertyTranslator.ViewFrom(card: card)
            cardView.isSelected = game.selectedCards.contains(key)
            addGestureRecognizersToCard(card: cardView)

            if key < board.subviews.count {
                board.updateCardView(at: key, with: cardView)
            } else {
                board.add(cardView: cardView)
            }
        }
        
        if game.displayedCards.count < board.subviews.count {
            for _ in game.displayedCards.count..<board.subviews.count {
                board.removeLast()
            }
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func startNewGame() {
        game = Game(numberOfCards: 12)
    }
    
    //MARK:- Animations
    
    
}

