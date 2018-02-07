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
    
    var game:Game! { didSet { update() }}
    
    //MARK:- UIViewController method overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(recognizer:)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
        
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
        update()
    }
    
    @objc func cardTouched(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let cardView = recognizer.view! as! UICardView
        
        let card = PropertyTranslator.CardFrom(view: cardView)
        
        game.select(card: card)
        update()
        
        if game.isOver {
            startNewGame()
        }
    }
    
    @objc func swipedDown(recognizer: UISwipeGestureRecognizer) {
        guard !game.isDeckEmpty else { return }
        
        if recognizer.state == .ended {
            game.askToDealThreeCards()
            update()
        }
    }
    
    @objc func rotateGestured(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .ended {
            game.shuffleDisplayCards()
            update()
        }
    }
    
    //MARK:- Utility
    
    private func addGestureRecognizersToCard(card: UICardView) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.cardTouched(recognizer:)))
        card.addGestureRecognizer(recognizer)
    }
    
    private func update() {
        board.cards = []
        for card in game.displayedCards {
            let cardView = PropertyTranslator.ViewFrom(card: card.value)
            cardView.isSelected = game.selectedCards.contains(card.key)
            board.cards.append(cardView)
            addGestureRecognizersToCard(card: cardView)
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func startNewGame() {
        game = Game(numberOfCards: 12)
        update()
    }
    
    //MARK:- Animations
    
    
}

