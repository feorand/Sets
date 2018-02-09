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
    
    @IBOutlet weak var deckButton: UIButton!
    
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
        let possibleCardsToDiscard = game.getHint()
        discardCardsIfAny(cards: possibleCardsToDiscard)
        
        updateViewFromModel()    }
    
    @IBAction func deckButtonTouch() {
        guard !game.isDeckEmpty else { return }
        
            game.askToDealThreeCards()
            updateViewFromModel()
    }
    
    @objc func cardTouched(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        
        let cardView = recognizer.view! as! UICardView
        let card = PropertyTranslator.CardFrom(view: cardView)
        
        let possibleCardsToDiscard = game.select(card: card)
        discardCardsIfAny(cards: possibleCardsToDiscard)
        
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
                board.updateCardView(index: key, cardView: cardView)
            } else {
                board.add(cardView: cardView)
            }
        }
        
        let cardViews = board.subviews.map{ $0 as! UICardView }
        for cardView in cardViews {
            let card = PropertyTranslator.CardFrom(view: cardView)
            if !game.displayedCards.values.contains(card) {
                cardView.isHidden = true
                board.setNeedsLayout()
            }
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func startNewGame() {
        board.clearAll()
        game = Game(numberOfCards: 12)
    }
    
    private func discardCardsIfAny(cards: [Int:Card]?) {
        if let cards = cards {
            for (index, card) in cards {
                showRemoveAnimation(index: index, card: card)
            }
        }
    }
    
    //MARK:- Animations
    
    func showRemoveAnimation(index: Int, card: Card) {
        board.subviews[index].alpha = 0
        
        let cardView = PropertyTranslator.ViewFrom(card: card)
        cardView.frame = board.subviews[index].frame.offsetBy(dx: board.frame.origin.x, dy: board.frame.origin.y)
        view.addSubview(cardView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: [.curveLinear],
            animations: { cardView.alpha = 0 },
            completion: { position in
                cardView.removeFromSuperview()
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: [.curveLinear],
                    animations: { self.board.subviews[index].alpha = 1 }
                )
            }
        )
    }
}

