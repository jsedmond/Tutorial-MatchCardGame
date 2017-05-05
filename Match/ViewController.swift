//
//  ViewController.swift
//  Match
//
//  Created by Jacob Edmond on 3/23/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let model = CardModel()
    var cards = [Card]()
    var revealedCard:Card?
    var timer:Timer?
    var countdown = 50
    
    var cardFlipSoundPlayer:AVAudioPlayer?
    var correctSoundPlayer:AVAudioPlayer?
    var wrongSoundPlayer:AVAudioPlayer?
    var shuffleSoundPlayer:AVAudioPlayer?
    
    var stackViewArray = [UIStackView]()
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var fourthStackView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create and initialize the sound players
        do {
            let shuffleFlipSoundPath = Bundle.main.path(forResource: "shuffle", ofType: "wav")
            let shuffleFlipSoundURL = URL(fileURLWithPath: shuffleFlipSoundPath!)
            shuffleSoundPlayer = try AVAudioPlayer(contentsOf: shuffleFlipSoundURL)
        
        }
        catch {
            // Sound player couldn't be created
        }
        
        do {
            let cardFlipSoundPath = Bundle.main.path(forResource: "cardflip", ofType: "wav")
            let cardFlipSoundURL = URL(fileURLWithPath: cardFlipSoundPath!)
            cardFlipSoundPlayer = try AVAudioPlayer(contentsOf: cardFlipSoundURL)
            
        }
        catch {
            // Sound player couldn't be created
        }
        
        do {
            let correctSoundPath = Bundle.main.path(forResource: "dingcorrect", ofType: "wav")
            let correctSoundURL = URL(fileURLWithPath: correctSoundPath!)
            correctSoundPlayer = try AVAudioPlayer(contentsOf: correctSoundURL)
            
        }
        catch {
            // Sound player couldn't be created
        }
        
        do {
            let wrongSoundPath = Bundle.main.path(forResource: "dingwrong", ofType: "wav")
            let wrongSoundURL = URL(fileURLWithPath: wrongSoundPath!)
            wrongSoundPlayer = try AVAudioPlayer(contentsOf: wrongSoundURL)
            
        }
        catch {
            // Sound player couldn't be created
        }
        
        // Put the four stackviews into an array
        stackViewArray += [firstStackView, secondStackView, thirdStackView, fourthStackView]
        
        
        // Get the cards
        cards = model.getCards()
        
        
        // Layout the cards
        layoutCards()
        
        // Set the countdown label
        countDownLabel.text = String(countdown)
        
        // Create and schedule a timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    func timerUpdate() {
        countdown -= 1
        
        if countdown == 0 {
            // Stop the timer
            timer?.invalidate()
            
            // Check if the user matched all the cards
            var userHasMatchedAllCards = true
            for card in cards {
                if card.isDone == false {
                    userHasMatchedAllCards = false
                    break
                }
            }
            
            var popUpMessage = ""
            if userHasMatchedAllCards == true {
                // Game is won
                popUpMessage = "Won"
            }
            else {
                // Game is lost
                popUpMessage = "Lost"

        }
            // Create alert
            let alert = UIAlertController(title: "Time's Up!", message: popUpMessage, preferredStyle: .alert)
            
            // Create alert action
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                self.restart()
            })
            
            // Attach action to alert
            alert.addAction(alertAction)
            
            // Present the alert
            present(alert, animated: true, completion: nil)
        
        }
        
        // Update the label in the UI
        countDownLabel.text = String(countdown)
        
    }
    
    func layoutCards() {
        
        // Play shuffle sound
        shuffleSoundPlayer?.play()
        
        // Keeps track of which card we are at
        var cardIndex = 0
        
        // Loop through the four stackviews and put four cards into each
        for stackview in stackViewArray {
            
            // Put four card objects into the StackView
            for _ in 1...4 {
                
                // Check if card exists at index before adding
                if cardIndex < cards.count {
                
                    // Set card that we are looking at
                    let card = cards[cardIndex]
                    card.translatesAutoresizingMaskIntoConstraints = false
                    
                    // Create a gesture recognizer and attach it to the card
                    let recognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped(gestureRecognizer:)))
                    card.addGestureRecognizer(recognizer)
                    
                    // Set the size of the card object
                    let heightConstraint = NSLayoutConstraint(item: card, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 170)
                    
                    let widthConstraint = NSLayoutConstraint(item: card, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
                    
                    card.addConstraints([heightConstraint, widthConstraint])
                    
                    // Put a card into the StackView
                    stackview.addArrangedSubview(card)
                    cardIndex += 1
                }
            }
        }
    }
    
    func cardTapped(gestureRecognizer:UITapGestureRecognizer) {
        
        // Check if countdown is zero
        if countdown == 0 {
            return
        }
        
        // Play sound
        cardFlipSoundPlayer?.play()
        
        // Card is tapped
        let card = gestureRecognizer.view as! Card
        
        // Check if the card is already flipped up
        if card.flippedUp == false {
            // Reveal card
            card.flipUp()
            
            if revealedCard == nil {
                // First card being flipped up

                // Track this card as the first card being flipped up
                revealedCard = card
            
            }
            else {
                // Second card being flipped up
                if card.cardValue == revealedCard?.cardValue {
                    // Cards match
                    
                    correctSoundPlayer?.play()
                    
                    // Remove both cards from the grid
                    card.isDone = true
                    revealedCard?.isDone = true
                    
                    // Reset the tracking of the first card
                    revealedCard = nil
                    
                    // Check if all pairs have been matched
                    checkPairs()
                }
                else {
                    // Cards don't match
                
                    wrongSoundPlayer?.play()
                    
                    // Flip both of them down again
                    let _ = Timer.scheduledTimer(timeInterval: 1, target: card, selector: #selector(Card.flipDown), userInfo: nil, repeats: false)
                    
                    let _ = Timer.scheduledTimer(timeInterval: 1, target: revealedCard!, selector: #selector(Card.flipDown), userInfo: nil, repeats: false)
                    
                    // Reset the tracking of the first card
                    revealedCard = nil
                    
                }
            }
        }
        

        
    }
    
    func checkPairs() {
        
        // Check if all the pairs have been matched
        var allDone = true
        
        for card in cards {
            if !card.isDone {
                allDone = false
                break;
            }
        }
        
        // Check if it's all done
        if allDone {
            
            // Stop the timer
            timer?.invalidate()
            
            // User has won and show alert
            
            // Create alert
            let alert = UIAlertController(title: "All Pairs Matched!", message: "You Win!", preferredStyle: .alert)
            
            // Create alert action
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                self.restart()
            })
            
            // Attach action to alert
            alert.addAction(alertAction)
            
            // Present the alert
            present(alert, animated: true, completion: nil)
        }
    }
    
    func restart() {
        
        // Clear out all cards
        for card in cards {
            card.removeFromSuperview()
        }
        
        // Get the cards
        cards = model.getCards()
        
        // Layout the cards
        layoutCards()
        
        // Set the countdown label
        countdown = 40
        countDownLabel.text = String(countdown)
        
        // Create and schedule a timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

