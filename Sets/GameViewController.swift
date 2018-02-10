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
    
    var game:Game!
    
    var discardedCardsToAnimate: [Int: Card] = [:]
    
    var newDealedCardsToAnimate: [Int] = []
    
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
        updateViewFromModel(discardedCards: possibleCardsToDiscard)
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
        
        let possibleCardsToDiscard = game.select(card: card)
        
        updateViewFromModel(discardedCards: possibleCardsToDiscard)
        
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
    
    private func updateViewFromModel(discardedCards: [Int:Card]? = nil) {
        //Deal cards from deck if needed
        if board.subviews.count < game.displayedCards.count {
            let firstNewCardIndex = board.subviews.count
            for i in firstNewCardIndex..<game.displayedCards.count {
                let card = game.displayedCards[i]!
                let cardView = PropertyTranslator.ViewFrom(card: card)
                addGestureRecognizersToCard(card: cardView)
                board.add(cardView: cardView)
            }
            
            board.updateFrames()

            for i in firstNewCardIndex..<game.displayedCards.count {
                newDealedCardsToAnimate.append(i)
            }
        }
        
        //Discard or Update cards if needed
        if let discardedCards = discardedCards {
            for (key, value) in discardedCards {
                if game.displayedCards[key] == nil {
                    board.subviews[key].isHidden = true
                } else {
                    let newCard = game.displayedCards[key]!
                    let cardView = PropertyTranslator.ViewFrom(card: newCard)
                    addGestureRecognizersToCard(card: cardView)
                    board.updateCardView(index: key, cardView: cardView)
                }
                
                discardedCardsToAnimate[key] = value
            }
            
            board.setNeedsLayout()
        }
        
        animateCards()
        
        //Update selection
        for key in game.displayedCards.keys {
            let cardView = board.subviews[key] as! UICardView
            cardView.isSelected = game.selectedCards.contains(key)
            board.setNeedsDisplay()
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func startNewGame() {
        board.clearAll()
        game = Game(numberOfCards: 12)
        updateViewFromModel()
    }
    
    //MARK:- Animations
    
    private func animateCards() {
        for (key, value) in discardedCardsToAnimate {
            performDiscardAnimation(at: key, oldCard: value)
        }
        
        discardedCardsToAnimate = [:]
        
        for i in newDealedCardsToAnimate {
            performDealAnimation(index: i)
        }
        
        newDealedCardsToAnimate = []
    }
    
    func performDiscardAnimation(at index: Int, oldCard card: Card) {
        let newCardView = board.subviews[index]
        newCardView.alpha = 0

        let discardedCardView = PropertyTranslator.ViewFrom(card: card)
        discardedCardView.frame = board.subviews[index].frame.offsetBy(dx: board.frame.origin.x, dy: board.frame.origin.y)
        view.addSubview(discardedCardView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: [.curveLinear],
            animations: { discardedCardView.alpha = 0 },
            completion: { position in
                discardedCardView.removeFromSuperview()
                self.performDealAnimation(index: index)
        })
    }
    
    func performDealAnimation(index: Int) {
        let actualCard = board.subviews[index]
        actualCard.alpha = 1
        let cardFrame = actualCard.frame
        actualCard.frame = deckButton.frame.offsetBy(dx: -board.frame.origin.x, dy: -board.frame.origin.y)

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { actualCard.frame = cardFrame }
            )
    }
}

