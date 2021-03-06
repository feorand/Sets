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
    
    @IBOutlet weak var board: BoardView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deckButton: UIButton!
    
    var game:Game!
    
    lazy var cardAnimator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }()
    
    lazy var cardBehavior:CardBehavior = {
        let behavior = CardBehavior(at: cardAnimator)
        return behavior
    }()
    
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
        
        let cardView = recognizer.view! as! CardView
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
    
    private func addGestureRecognizersToCard(card: CardView) {
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
            let cardView = board.subviews[key] as! CardView
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
        
        for (index, key) in discardedCardsToAnimate.keys.enumerated() {
            let _ = Timer.scheduledTimer(
                withTimeInterval: 0.1 * Double(index),
                repeats: false,
                block: { timer in self.performDealAnimation(index: key) })

        }
        
        discardedCardsToAnimate = [:]
        
        for (index, card) in newDealedCardsToAnimate.enumerated() {
            board.subviews[card].alpha = 0
            let _ = Timer.scheduledTimer(
                withTimeInterval: 0.1 * Double(index),
                repeats: false,
                block: { timer in self.performDealAnimation(index: card) })
        }
        
        newDealedCardsToAnimate = []
    }
    
    func performDiscardAnimation(at index: Int, oldCard card: Card) {
        let newCardView = board.subviews[index]
        newCardView.alpha = 0

        let discardedCardView = PropertyTranslator.ViewFrom(card: card)
        discardedCardView.frame = board.subviews[index].frame.offsetBy(dx: board.frame.origin.x, dy: board.frame.origin.y)
        discardedCardView.isSelected = true
        view.addSubview(discardedCardView)
        
        cardBehavior.addItem(item: discardedCardView)
        
        let _ = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: false,
            block: { timer in
                self.cardBehavior.removeItem(item: discardedCardView)
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: {
                        discardedCardView.center = self.scoreLabel.superview!.convert(self.scoreLabel.center, to: self.view)
                        discardedCardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                },
                    completion: { position in discardedCardView.removeFromSuperview()})
            }
        )
    }
    
    func performDealAnimation(index: Int) {
        let card = board.subviews[index] as! CardView
        let cardFrame = card.frame
        card.frame = deckButton.frame.offsetBy(dx: -board.frame.origin.x, dy: -board.frame.origin.y)
        card.isBack = true
        card.alpha = 1
        view.bringSubview(toFront: card)

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { card.frame = cardFrame },
            completion: { position in
                UIView.transition(
                    with: card,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: { card.isBack = false },
                    completion: { finished in self.deckButton.isHidden = self.game.isDeckEmpty }
                )
            }
        )
    }
}

